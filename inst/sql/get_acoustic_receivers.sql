SELECT
-- pk
  id_pk AS PK,
-- receiver_id
  receiver AS RECEIVER_ID,
-- application_type
  receiver_type AS APPLICATION_TYPE,
-- telemetry_type: https://github.com/inbo/etn/issues/150
  'acoustic' AS TELEMETRY_TYPE,
-- manufacturer
  manufacturer_fk AS MANUFACTURER,
-- receiver_id_model
  model_number AS RECEIVER_ID_MODEL,
-- receiver_id_serial_number
  serial_number AS RECEIVER_ID_SERIAL_NUMBER,
-- modem_address
  modem_address AS MODEM_ADDRESS,
-- status
  status AS STATUS,
-- battery_estimated_life
  expected_battery_life AS BATTERY_ESTIMATED_LIFE,
-- owner_organization (see https://github.com/inbo/etn/issues/166)
  owner_group_fk AS OWNER_ORGANISATION,
-- financing_project
  financing_project_fk AS FINANCING_PROJECT,
-- built_in_tag_id
  built_in_tag_device_fk AS BUILT_IN_TAG_ID,
-- ar_model_number
  ar_model_number AS AR_MODEL_NUMBER,
-- ar_serial_number
  ar_serial_number AS AR_SERIAL_NUMBER,
-- ar_battery_estimated_life
  ar_expected_battery_life AS AR_BATTERY_ESTIMATED_LIFE,
-- ar_voltage_at_deploy
  ar_voltage_at_deploy AS AR_VOLTAGE_AT_DEPLOY,
-- ar_interrogate_code
  ar_interrogate_code AS AR_INTERROGATE_CODE,
-- ar_receive_frequency
  ar_receive_frequency AS AR_RECEIVE_FREQUENCY,
-- ar_reply_frequency
  ar_reply_frequency AS AR_REPLY_FREQUENCY,
-- ar_ping_rate
  ar_ping_rate AS AR_PING_RATE,
-- ar_enable_code_address
  ar_enable_code_address AS AR_ENABLE_CODE_ADDRESS,
-- ar_release_code
  ar_release_code AS AR_RELEASE_CODE,
-- ar_disable_code
  ar_disable_code AS AR_DISABLE_CODE,
-- ar_tilt_code
  ar_tilt_code AS AR_TILT_CODE,
-- ar_tilt_after_deploy
  ar_tilt_after_deploy AS AR_TILT_AFTER_DEPLOY

FROM acoustic.receivers
