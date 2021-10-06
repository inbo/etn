/* Unified tag table with controlled tag_type, tag_subtype */
SELECT
  tag_device.serial_number AS tag_serial_number,
  CASE
    WHEN tag_type.name = 'id-tag' THEN 'acoustic'
    WHEN tag_type.name = 'sensor-tag' AND acoustic_tag_id IS NOT NULL THEN 'acoustic-archival'
    WHEN tag_type.name = 'sensor-tag' THEN 'archival'
  END AS tag_type,
  CASE
    WHEN tag_subtype.name = 'animal' THEN 'animal'
    WHEN tag_subtype.name = 'built-in tag' THEN 'built-in'
    WHEN tag_subtype.name = 'range tag' THEN 'range'
    WHEN tag_subtype.name = 'sentinel tag' THEN 'sentinel'
  END AS tag_subtype,
  tag_union.*
FROM
  common.tag_device AS tag_device
    LEFT JOIN common.tag_device_type AS tag_type
      ON tag_device.tag_device_type_fk = tag_type.id_pk
    LEFT JOIN acoustic.acoustic_tag_subtype AS tag_subtype
      ON tag_device.acoustic_tag_subtype_fk = tag_subtype.id_pk
    LEFT JOIN (
      SELECT
        tag_device_fk,
        sensor_type,
        tag_full_id AS acoustic_tag_id,
        thelma_converted_code,
        frequency,
        slope, intercept, range, sensor_transmit_ratio, accelerometer_algoritm, accelerometer_samples_per_second,
        min_delay, max_delay, power, duration_step1, acceleration_on_sec_step1,
        min_delay_step2, max_delay_step2, power_step2, duration_step2, acceleration_on_sec_step2,
        min_delay_step3, max_delay_step3, power_step3, duration_step3, acceleration_on_sec_step3,
        min_delay_step4, max_delay_step4, power_step4, duration_step4, acceleration_on_sec_step4
        -- id_pk, tag_code_space AS protocol, id_code, file, units, external_id
      FROM
        acoustic.tags
      UNION
      SELECT
        device_tag_fk AS tag_device_fk,
        sensor_type.description AS sensor_type,
        CASE
          WHEN protocol IS NOT NULL AND id_code IS NOT NULL THEN CONCAT(protocol, '-', id_code)
        END AS acoustic_tag_id,
        NULL AS thelma_converted_code,
        frequency,
        slope, intercept, range, sensor_transmit_ratio, accelerometer_algoritm, accelerometer_samples_per_second,
        min_delay, max_delay, power, duration_step1, acceleration_on_sec_step1,
        min_delay_step2, max_delay_step2, power_step2, duration_step2, acceleration_on_sec_step2,
        min_delay_step3, max_delay_step3, power_step3, duration_step3, acceleration_on_sec_step3,
        min_delay_step4, max_delay_step4, power_step4, duration_step4, acceleration_on_sec_step4
        -- id_pk, protocol, id_code, resolution, unit, accurency, range_min, range_max
      FROM
        archive.sensor AS archival_tag
        LEFT JOIN archive.sensor_type AS sensor_type
          ON archival_tag.sensor_type_fk = sensor_type.id_pk
    ) AS tag_union
      ON tag_device.id_pk = tag_union.tag_device_fk
