/*
Schema: https://rs.gbif.org/core/dwc_occurrence_2022-02-02.xml
*/

/* HELPER TABLES */

WITH
-- ANIMALS
-- Select animals from animal_project_code
animals AS (
  SELECT *
  FROM common.animal_release_limited AS animal
    LEFT JOIN common.projects AS animal_project
      ON animal.project_fk = animal_project.id
  WHERE
    LOWER(animal_project.projectcode) = {animal_project_code}
),
-- EVENTS
-- Animals contain multiple events (capture, release, surgery, recapture) as columns
-- Transpose events to rows and exclude those without date information
events AS (
  SELECT *
  FROM
    (
      SELECT
        animal.id_pk                    AS animal_id_pk,
        'capture'                       AS protocol,
        animal.catched_date_time        AS date,
        animal.capture_location         AS locality,
        animal.capture_latitude         AS latitude,
        animal.capture_longitude        AS longitude
      FROM animals AS animal
      UNION
      SELECT
        animal.id_pk                    AS animal_id_pk,
        'surgery'                       AS protocol,
        animal.date_of_surgery          AS date,
        animal.surgery_location         AS locality,
        animal.surgery_latitude         AS latitude,
        animal.surgery_longitude        AS longitude
      FROM animals AS animal
      UNION
      SELECT
        animal.id_pk                    AS animal_id_pk,
        'release'                       AS protocol,
        animal.utc_release_date_time    AS date,
        animal.release_location         AS locality,
        animal.release_latitude         AS latitude,
        animal.release_longitude        AS longitude
      FROM animals AS animal
      UNION
      SELECT
        animal.id_pk                    AS animal_id_pk,
        'recapture'                     AS protocol,
        animal.recapture_date           AS date,
        NULL                            AS locality,
        NULL                            AS latitude,
        NULL                            AS longitude
      FROM animals AS animal
    ) AS events
  WHERE
    date IS NOT NULL
  ORDER BY
    animal_id_pk,
    date
),
-- HOURLY DETECTION GROUPS
-- Select detections from animal_project_code
-- Group detections by animal+tag+date+hour combination and get first timestamp and count
detection_groups AS (
  SELECT
    det.animal_id_pk || det.tag_serial_number || DATE_TRUNC('hour', det.datetime) AS det_group,
    det.animal_id_pk,
    det.tag_serial_number,
    min(det.datetime) AS datetime,
    count(*) AS det_group_count
  FROM acoustic.detections_limited AS det
  WHERE LOWER(animal_project_code) = {animal_project_code}
  GROUP BY
    det_group,
    det.animal_id_pk,
    det.tag_serial_number
),
-- SUBSAMPLED DETECTIONS
-- Join hour_groups with detections to get all fields
-- Exclude animal+tag+timestamp duplicates with DISTINCT ON
detections AS (
  SELECT DISTINCT ON (det_group.det_group)
    det_group.det_group_count,
    det.*
  FROM detection_groups AS det_group
  LEFT JOIN (
    SELECT *
    FROM acoustic.detections_limited AS det
    WHERE LOWER(det.animal_project_code) = {animal_project_code}
  ) AS det
    -- Joining on these 3 fields is faster than creating det_group again
    ON
      det_group.animal_id_pk = det.animal_id_pk
      AND det_group.tag_serial_number = det.tag_serial_number
      AND det_group.datetime = det.datetime
)

/* DATASET-LEVEL */

SELECT
  'Event'                               AS "type",
  {license}                             AS "license",
  {rights_holder}                       AS "rightsHolder",
  {dataset_id}                          AS "datasetID",
  'VLIZ'                                AS "institutionCode",
  'ETN'                                 AS "collectionCode",
  {dataset_name}                        AS "datasetName",
  *
FROM (

/* HUMAN OBSERVATIONS */

SELECT
-- RECORD LEVEL
  'HumanObservation'                    AS "basisOfRecord",
  NULL                                  AS "dataGeneralizations",
-- OCCURRENCE
  animal.id_pk || '_' || tag_device.serial_number || '_' || event.protocol AS "occurrenceID", -- Same as EventID
  CASE
    WHEN TRIM(LOWER(animal.sex)) IN ('male', 'm') THEN 'male'
    WHEN TRIM(LOWER(animal.sex)) IN ('female', 'f') THEN 'female'
    WHEN TRIM(LOWER(animal.sex)) IN ('hermaphrodite') THEN 'hermaphrodite'
    WHEN TRIM(LOWER(animal.sex)) IN ('unknown', 'u') THEN 'unknown'
    -- Exclude transitional, na, ...
  END                                   AS "sex",
  CASE
    WHEN event.protocol = 'release' THEN -- Only at release, can change over time
      CASE
        -- Follows http://vocab.nerc.ac.uk/collection/S11/current/, see https://github.com/inbo/etn/issues/262
        WHEN TRIM(LOWER(animal.life_stage)) IN ('juvenile', 'i', 'fii', 'fiii') THEN 'juvenile'
        WHEN TRIM(LOWER(animal.life_stage)) IN ('sub-adult', 'fiv', 'fv', 'mii', 'silver') THEN 'sub-adult'
        WHEN TRIM(LOWER(animal.life_stage)) IN ('adult', 'mature') THEN 'adult'
        WHEN TRIM(LOWER(animal.life_stage)) IN ('immature', 'imature') THEN 'immature'
        WHEN TRIM(LOWER(animal.life_stage)) IN ('smolt') THEN 'smolt'
        -- Exclude unknown, and other values
      END
  END                                   AS "lifeStage",
  'present'                             AS "occurrenceStatus",
  animal.id_pk                          AS "organismID",
  animal.animal_nickname                AS "organismName",
-- EVENT
  animal.id_pk || '_' || tag_device.serial_number || '_' || event.protocol AS "eventID",
  animal.id_pk || '_' || tag_device.serial_number AS "parentEventID",
  TO_CHAR(event.date, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') AS "eventDate",
  event.protocol                        AS "samplingProtocol",
  CASE
    WHEN event.protocol = 'capture' THEN
      'Caugth using ' || TRIM(LOWER(animal.capture_method))
    WHEN event.protocol = 'release' THEN
      manufacturer.project || ' ' || tag_device.model || ' tag ' ||
      CASE
        WHEN LOWER(animal.implant_type) = 'internal' THEN 'implanted in '
        WHEN LOWER(animal.implant_type) = 'external' THEN 'attached to '
        ELSE 'implanted in or attached to ' -- Includes `Acoutic and pit`, ...
      END ||
      CASE
        WHEN TRIM(LOWER(animal.wild_or_hatchery)) IN ('wild', 'w') THEN 'free-ranging animal'
        WHEN TRIM(LOWER(animal.wild_or_hatchery)) IN ('hatchery', 'h') THEN 'hatched animal'
        ELSE 'likely free-ranging animal'
      END
  END                                   AS "eventRemarks",
-- LOCATION
  NULL                                  AS "locationID",
  event.locality                        AS "locality",
  event.latitude                        AS "decimalLatitude",
  event.longitude                       AS "decimalLongitude",
  CASE
    WHEN event.latitude IS NOT NULL THEN 'EPSG:4326'
  END                                   AS "geodeticDatum",
  CASE
     -- Assume coordinate precision of 0.001 degree (157m) and recording by GPS (30m)
    WHEN event.latitude IS NOT NULL THEN 187
  END                                   AS "coordinateUncertaintyInMeters",
-- TAXON
  'urn:lsid:marinespecies.org:taxname:' || animal.aphia_id AS "scientificNameID",
  animal.scientific_name                AS "scientificName",
  'Animalia'                            AS "kingdom"
FROM
  events AS event
  LEFT JOIN animals AS animal
    ON event.animal_id_pk = animal.id_pk
    LEFT JOIN common.animal_release_tag_device AS animal_with_tag
      ON animal.id_pk = animal_with_tag.animal_release_fk
      LEFT JOIN common.tag_device_limited AS tag_device
        ON animal_with_tag.tag_device_fk = tag_device.id_pk
        LEFT JOIN common.tag_device_type AS tag_type
          ON tag_device.tag_device_type_fk = tag_type.id_pk
        LEFT JOIN common.manufacturer AS manufacturer
          ON tag_device.manufacturer_fk = manufacturer.id_pk

UNION

/* DETECTIONS */

SELECT
-- RECORD LEVEL
  'MachineObservation'                  AS "basisOfRecord",
  'subsampled by hour: first of ' || det.det_group_count || ' record(s)' AS "dataGeneralizations",
-- OCCURRENCE
  det.id_pk::text                       AS "occurrenceID", -- Same as EventID
  CASE
    WHEN TRIM(LOWER(animal.sex)) IN ('male', 'm') THEN 'male'
    WHEN TRIM(LOWER(animal.sex)) IN ('female', 'f') THEN 'female'
    WHEN TRIM(LOWER(animal.sex)) IN ('hermaphrodite') THEN 'hermaphrodite'
    WHEN TRIM(LOWER(animal.sex)) IN ('unknown', 'u') THEN 'unknown'
    -- Exclude transitional, na, ...
  END                                   AS "sex",
  NULL                                  AS "lifeStage", -- Value at release might not apply to all records
  'present'                             AS "occurrenceStatus",
  animal.id_pk                          AS "organismID",
  animal.animal_nickname                AS "organismName",
-- EVENT
  det.id_pk::text                       AS "eventID",
  animal.id_pk || '_' || det.tag_serial_number AS "parentEventID",
  TO_CHAR(det.datetime, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') AS "eventDate",
  'acoustic telemetry'                  AS "samplingProtocol",
  'detected on receiver ' || det.receiver AS "eventRemarks",
-- LOCATION
  det.deployment_station_name           AS "locationID",
  dep.location_name                     AS "locality",
  det.deployment_latitude               AS "decimalLatitude",
  det.deployment_longitude              AS "decimalLongitude",
  CASE
    WHEN det.deployment_latitude IS NOT NULL THEN 'EPSG:4326'
  END                                   AS "geodeticDatum",
  CASE
     -- Assume coordinate precision of 0.001 degree (157m), recording by GPS (30m) and detection range of around 800m ≈ 1000m
     -- See https://github.com/inbo/etn/issues/256#issuecomment-1332224935
    WHEN det.deployment_latitude IS NOT NULL THEN 1000
  END                                   AS "coordinateUncertaintyInMeters",
-- TAXON
  'urn:lsid:marinespecies.org:taxname:' || animal.aphia_id AS "scientificNameID",
  animal.scientific_name                AS "scientificName",
  'Animalia'                            AS "kingdom"
FROM
  detections AS det
  LEFT JOIN animals AS animal
    ON det.animal_id_pk = animal.id_pk
  LEFT JOIN acoustic.deployments AS dep
    ON det.deployment_fk = dep.id_pk
) AS occurrences

ORDER BY
  "parentEventID",
  "eventDate",
  "samplingProtocol" -- capture, surgery, release, rerelease
