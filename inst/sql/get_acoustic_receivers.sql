SELECT
-- pk
  receiver.id_pk AS PK,
-- receiver_id
  receiver.receiver AS RECEIVER_ID,
-- application_type
  receiver.receiver_type AS APPLICATION_TYPE,
-- telemetry_type: https://github.com/inbo/etn/issues/150
  'acoustic' AS TELEMETRY_TYPE,
-- manufacturer
  manufacturer.project AS MANUFACTURER,
-- receiver_id_model
  receiver.model_number AS RECEIVER_ID_MODEL,
-- receiver_id_serial_number
  receiver.serial_number AS RECEIVER_ID_SERIAL_NUMBER,
-- modem_address
  receiver.modem_address AS MODEM_ADDRESS,
-- status
  receiver.status AS STATUS,
-- battery_estimated_life
  receiver.expected_battery_life AS BATTERY_ESTIMATED_LIFE,
-- owner_organization
  owner_organization.name AS OWNER_ORGANIZATION,
-- financing_project
  financing_project.projectcode AS FINANCING_PROJECT,
-- built_in_tag_id
  receiver.built_in_tag_device_fk AS BUILT_IN_TAG_ID, -- This fk can remain
-- ar_model_number
  receiver.ar_model_number AS AR_MODEL_NUMBER,
-- ar_serial_number
  receiver.ar_serial_number AS AR_SERIAL_NUMBER,
-- ar_battery_estimated_life
  receiver.ar_expected_battery_life AS AR_BATTERY_ESTIMATED_LIFE,
-- ar_voltage_at_deploy
  receiver.ar_voltage_at_deploy AS AR_VOLTAGE_AT_DEPLOY,
-- ar_interrogate_code
  receiver.ar_interrogate_code AS AR_INTERROGATE_CODE,
-- ar_receive_frequency
  receiver.ar_receive_frequency AS AR_RECEIVE_FREQUENCY,
-- ar_reply_frequency
  receiver.ar_reply_frequency AS AR_REPLY_FREQUENCY,
-- ar_ping_rate
  receiver.ar_ping_rate AS AR_PING_RATE,
-- ar_enable_code_address
  receiver.ar_enable_code_address AS AR_ENABLE_CODE_ADDRESS,
-- ar_release_code
  receiver.ar_release_code AS AR_RELEASE_CODE,
-- ar_disable_code
  receiver.ar_disable_code AS AR_DISABLE_CODE,
-- ar_tilt_code
  receiver.ar_tilt_code AS AR_TILT_CODE,
-- ar_tilt_after_deploy
  receiver.ar_tilt_after_deploy AS AR_TILT_AFTER_DEPLOY

FROM acoustic.receivers AS receiver
  LEFT JOIN common.manufacturer AS manufacturer
    ON receiver.manufacturer_fk = manufacturer.id_pk
  LEFT JOIN common.etn_group AS owner_organization
    ON receiver.owner_group_fk = owner_organization.id_pk
  LEFT JOIN common.projects AS financing_project
    ON receiver.financing_project_fk = financing_project.id
