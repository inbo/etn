/* Unified acoustic_tag_id and acoustic_tag_id_alternative */
  SELECT
    tag_device_fk,
    tag_full_id AS acoustic_tag_id
  FROM acoustic.tags
  WHERE tag_full_id IS NOT NULL
UNION
  SELECT
    tag_device_fk,
    thelma_converted_code AS acoustic_tag_id
  FROM acoustic.tags
  WHERE thelma_converted_code IS NOT NULL
UNION
  SELECT
    device_tag_fk AS tag_device_fk,
    sensor_full_id AS acoustic_tag_id
  FROM archive.sensor
  WHERE sensor_full_id IS NOT NULL
