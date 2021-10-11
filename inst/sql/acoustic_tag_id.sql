/* Unified acoustic_tag_id and acoustic_tag_id_alternative */
SELECT tag_full_id AS acoustic_tag_id, tag_device_fk
FROM acoustic.tags
UNION
SELECT thelma_converted_code AS acoustic_tag_id, tag_device_fk
FROM acoustic.tags
UNION
SELECT sensor_full_id AS acoustic_tag_id, device_tag_fk AS tag_device_fk
FROM archive.sensor
