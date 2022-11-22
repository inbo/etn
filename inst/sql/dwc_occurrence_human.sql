/*
Schema: https://rs.gbif.org/core/dwc_occurrence_2022-02-02.xml
*/

/* HELPER TABLE FOR HUMAN OBSERVATION EVENTS
The animals table contains multiple events (capture, release, surgery, recapture) as columns.
Here they are transposed to rows. Events without date information are excluded.
*/
WITH event AS (
  SELECT *
  FROM
    (
      SELECT
        animal.id_pk                    AS id_pk,
        'capture'                       AS protocol,
        animal.catched_date_time        AS date,
        animal.capture_location         AS locality,
        animal.capture_latitude         AS latitude,
        animal.capture_longitude        AS longitude
      FROM common.animal_release_limited AS animal
      WHERE animal.project_fk = {animal_project_id}

      UNION

      SELECT
        animal.id_pk                    AS id_pk,
        'surgery'                       AS protocol,
        animal.date_of_surgery          AS date,
        animal.surgery_location         AS locality,
        animal.surgery_latitude         AS latitude,
        animal.surgery_longitude        AS longitude
      FROM common.animal_release_limited AS animal
      WHERE animal.project_fk = {animal_project_id}

      UNION

      SELECT
        animal.id_pk                    AS id_pk,
        'release'                       AS protocol,
        animal.utc_release_date_time    AS date,
        animal.release_location         AS locality,
        animal.release_latitude         AS latitude,
        animal.release_longitude        AS longitude
      FROM common.animal_release_limited AS animal
      WHERE animal.project_fk = {animal_project_id}

      UNION

      SELECT
        animal.id_pk                    AS id_pk,
        'recapture'                     AS protocol,
        animal.recapture_date           AS date,
        NULL                            AS locality,
        NULL                            AS latitude,
        NULL                            AS longitude
      FROM common.animal_release_limited AS animal
      WHERE animal.project_fk = {animal_project_id}
    ) AS events
  WHERE
    date IS NOT NULL
  ORDER BY
    id_pk,
    date
)

/* DATASET-LEVEL */

SELECT
  'Event'                               AS type,
  {license}                             AS license,
  {rights_holder}                       AS rightsHolder,
  {dataset_id}                          AS datasetID,
  'VLIZ'                                AS institutionCode,
  'ETN'                                 AS collectionCode,
-- datasetName
  *
FROM (

/* HUMAN OBSERVATIONS */

SELECT
-- RECORD LEVEL
  'HumanObservation'                    AS basisOfRecord,
  NULL                                  AS dataGeneralizations,
-- OCCURRENCE
  animal.id_pk || '_' || tag_device.serial_number || '_' || event.protocol AS occurrenceID, -- Same as EventID
  CASE
    WHEN TRIM(LOWER(animal.sex)) IN ('male', 'm') THEN 'male'
    WHEN TRIM(LOWER(animal.sex)) IN ('female', 'f') THEN 'female'
    WHEN TRIM(LOWER(animal.sex)) IN ('hermaphrodite') THEN 'hermaphrodite'
    WHEN TRIM(LOWER(animal.sex)) IN ('unknown', 'u') THEN 'unknown'
    ELSE NULL -- Includes transitional, na, ...
  END                                   AS sex,
  TRIM(LOWER(animal.life_stage))        AS lifeStage,
  'present'                             AS occurrenceStatus,
  animal.id_pk                          AS organismID,
  animal.animal_nickname                AS organismName,
-- EVENT
  animal.id_pk || '_' || tag_device.serial_number || '_' || event.protocol AS EventID,
  animal.id_pk || '_' || tag_device.serial_number AS parentEventID,
  to_char(event.date, 'YYYY-MM-DD"T"HH:MI:SS"Z"') AS eventDate,
  event.protocol                        AS samplingProtocol,
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
    ELSE NULL
  END                                   AS eventRemarks,
-- LOCATION
  NULL                                  AS locationID,
  event.locality                        AS locality,
  event.latitude                        AS decimalLatitude,
  event.longitude                       AS decimalLongitude,
  CASE
    WHEN event.latitude IS NOT NULL THEN 'WGS84'
    ELSE NULL
  END                                   AS geodeticDatum,
  CASE
    WHEN event.latitude IS NOT NULL THEN 30
    ELSE NULL
  END                                   AS coordinateUncertaintyInMeters,
-- TAXON
  'urn:lsid:marinespecies.org:taxname:' || animal.aphia_id AS scientificNameID,
  animal.scientific_name                AS scientificName,
  'Animalia'                            AS kingdom
FROM
  event
  LEFT JOIN common.animal_release_limited AS animal
    ON event.id_pk = animal.id_pk
    LEFT JOIN common.animal_release_tag_device AS animal_with_tag
      ON animal.id_pk = animal_with_tag.animal_release_fk
      LEFT JOIN common.tag_device_limited AS tag_device
        ON animal_with_tag.tag_device_fk = tag_device.id_pk
        LEFT JOIN common.tag_device_type AS tag_type
          ON tag_device.tag_device_type_fk = tag_type.id_pk
        LEFT JOIN common.manufacturer AS manufacturer
          ON tag_device.manufacturer_fk = manufacturer.id_pk
WHERE
  animal.project_fk = {animal_project_id}
) AS occurrences

ORDER BY
  parentEventID,
  eventDate,
  samplingProtocol -- capture, surgery, release, rerelease
