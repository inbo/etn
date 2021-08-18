SELECT
-- pk
  tag.id_pk AS PK, -- This is the one in animals, not acoustic_tag.id_pk
-- tag_id
  acoustic_tag.tag_full_id AS TAG_ID,
-- tag_id_alternative
  acoustic_tag.thelma_converted_code AS TAG_ID_ALTERNATIVE,
-- telemetry_type
  'acoustic' AS TELEMETRY_TYPE, -- Not acoustic_tag.type_tbd
-- manufacturer
  manufacturer.project AS MANUFACTURER, -- Not acoustic_tag.manufacturer_fk_tbd
-- model
  tag.model AS MODEL, -- Not acoustic_tag.model_tbd
-- frequency
  acoustic_tag.frequency AS FREQUENCY,
-- type
  tag_type.name AS TYPE, -- Actual type, not acoustic_tag.acoustic_tag_type_tbd
-- serial_number
  tag.serial_number AS SERIAL_NUMBER, -- Not acoustic_tag.serial_number_tbd
-- tag_id_protocol
  acoustic_tag.tag_code_space AS TAG_ID_PROTOCOL,
-- tag_id_code
  acoustic_tag.id_code AS TAG_ID_CODE,
-- status
  tag_status.name AS STATUS, -- Not acoustic_tag.status_tbd
-- activation_date
  tag.activation_date AS ACTIVATION_DATE, -- Not acoustic_tag.activation_date_tbd
-- battery_estimated_life
  tag.battery_estimated_lifetime AS BATTERY_ESTIMATED_LIFE, -- Not acoustic_tag.estimated_lifetime_tbd
-- battery_estimated_end_date
  tag.battery_estimated_end_date AS BATTERY_ESTIMATED_END_DATE, -- Not acoustic_tag.end_date_tbd
-- sensor_type
  acoustic_tag.sensor_type AS SENSOR_TYPE,
-- sensor_slope
  acoustic_tag.slope AS SENSOR_SLOPE,
-- sensor_intercept
  acoustic_tag.intercept AS SENSOR_INTERCEPT,
-- sensor_range
  acoustic_tag.range AS SENSOR_RANGE,
-- sensor_transmit_ratio
  acoustic_tag.sensor_transmit_ratio AS SENSOR_TRANSMIT_RATIO,
-- accelerometer_algorithm
  acoustic_tag.accelerometer_algoritm AS ACCELEROMETER_ALGORITHM,
-- accelerometer_samples_per_second
  acoustic_tag.accelerometer_samples_per_second AS ACCELEROMETER_SAMPLES_PER_SECOND,
-- owner_organization
  owner_organization.name AS OWNER_ORGANIZATION, -- Not acoustic_tag.owner_group_fk_tbd
-- owner_pi
  tag.owner_pi AS OWNER_PI, -- Not acoustic_tag.owner_pi_tbd
-- financing_project
  financing_project.projectcode AS FINANCING_PROJECT, -- Not acoustic_tag.financing_project_fk_tbd
-- step1_min_delay
  acoustic_tag.min_delay AS STEP1_MIN_DELAY,
-- step1_max_delay
  acoustic_tag.max_delay AS STEP1_MAX_DELAY,
-- step1_power
  acoustic_tag.power AS STEP1_POWER,
-- step1_duration
  acoustic_tag.duration_step1 AS STEP1_DURATION,
-- step1_acceleration_duration
  acoustic_tag.acceleration_on_sec_step1 AS STEP1_ACCELERATION_DURATION,
-- step2_min_delay
  acoustic_tag.min_delay_step2 AS STEP2_MIN_DELAY,
-- step2_max_delay
  acoustic_tag.max_delay_step2 AS STEP2_MAX_DELAY,
-- step2_power
  acoustic_tag.power_step2 AS STEP2_POWER,
-- step2_duration
  acoustic_tag.duration_step2 AS STEP2_DURATION,
-- step2_acceleration_duration
  acoustic_tag.acceleration_on_sec_step2 AS STEP2_ACCELERATION_DURATION,
-- step3_min_delay
  acoustic_tag.min_delay_step3 AS STEP3_MIN_DELAY,
-- step3_max_delay
  acoustic_tag.max_delay_step3 AS STEP3_MAX_DELAY,
-- step3_power
  acoustic_tag.power_step3 AS STEP3_POWER,
-- step3_duration
  acoustic_tag.duration_step3 AS STEP3_DURATION,
-- step3_acceleration_duration
  acoustic_tag.acceleration_on_sec_step3 AS STEP3_ACCELERATION_DURATION,
-- step4_min_delay
  acoustic_tag.min_delay_step4 AS STEP4_MIN_DELAY,
-- step4_max_delay
  acoustic_tag.max_delay_step4 AS STEP4_MAX_DELAY,
-- step4_power
  acoustic_tag.power_step4 AS STEP4_POWER,
-- step4_duration
  acoustic_tag.duration_step4 AS STEP4_DURATION,
-- step4_acceleration_duration
  acoustic_tag.acceleration_on_sec_step4 AS STEP4_ACCELERATION_DURATION

FROM common.tag_device AS tag
  LEFT JOIN acoustic.tags AS acoustic_tag
    ON tag.id_pk = acoustic_tag.tag_device_fk
  LEFT JOIN common.manufacturer AS manufacturer
    ON tag.manufacturer_fk = manufacturer.id_pk
  LEFT JOIN common.tag_device_type AS tag_type
    ON tag.tag_device_type_fk = tag_type.id_pk
  LEFT JOIN common.tag_device_status AS tag_status
    ON tag.tag_device_status_fk = tag_status.id_pk
  LEFT JOIN common.etn_group AS owner_organization
    ON tag.owner_group_fk = owner_organization.id_pk
  LEFT JOIN common.projects AS financing_project
    ON tag.financing_project_fk = financing_project.id
