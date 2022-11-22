/*
Schema: https://rs.gbif.org/core/dwc_occurrence_2022-02-02.xml
*/

-- The animals table contains multiple (human observation) events (capture, release, surgery, recapture) as columns.
-- Here they are transposed to rows. Events without date information are excluded.
WITH animal_events AS (
  SELECT *
  FROM
    (
      SELECT
        animal.id_pk                    AS id_pk,
        'capture'                       AS protocol,
        animal.catched_date_time        AS date,
        animal.capture_location         AS location,
        animal.capture_latitude         AS latitude,
        animal.capture_longitude        AS longitude
      FROM common.animal_release_limited AS animal
      WHERE animal.project_fk = {animal_project_id}

      UNION

      SELECT
        animal.id_pk                    AS id_pk,
        'surgery'                       AS protocol,
        animal.date_of_surgery          AS date,
        animal.surgery_location         AS location,
        animal.surgery_latitude         AS latitude,
        animal.surgery_longitude        AS longitude
      FROM common.animal_release_limited AS animal
      WHERE animal.project_fk = {animal_project_id}

      UNION

      SELECT
        animal.id_pk                    AS id_pk,
        'release'                       AS protocol,
        animal.utc_release_date_time    AS date,
        animal.release_location         AS location,
        animal.release_latitude         AS latitude,
        animal.release_longitude        AS longitude
      FROM common.animal_release_limited AS animal
      WHERE animal.project_fk = {animal_project_id}

      UNION

      SELECT
        animal.id_pk                    AS id_pk,
        'recapture'                     AS protocol,
        animal.recapture_date           AS date,
        NULL                            AS location,
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

SELECT
  *
FROM
  animal_events
