SELECT
-- pk
  animal.id_pk AS PK,
-- animal_id
  animal.id_pk AS ANIMAL_ID,
-- animal_project_code
  project.projectcode AS ANIMAL_PROJECT_CODE,
-- tag_id
  acoustic_tag.tag_full_id AS TAG_ID,
-- tag_fk
  tag.id_pk AS TAG_FK,
-- scientific_name
  scientific_name AS SCIENTIFIC_NAME,
-- common_name
  common_name AS COMMON_NAME,
-- aphia_id
  aphia_id AS APHIA_ID,
-- animal_label
  animal_id AS ANIMAL_LABEL,
-- animal_nickname
  animal_nickname AS ANIMAL_NICKNAME,
-- tagger
  tagger AS TAGGER,
-- capture_date_time
  catched_date_time AS CAPTURE_DATE_TIME,
-- capture_location
  capture_location AS CAPTURE_LOCATION,
-- capture_latitude
  capture_latitude AS CAPTURE_LATITUDE,
-- capture_longitude
  capture_longitude AS CAPTURE_LONGITUDE,
-- capture_method
  capture_method AS CAPTURE_METHOD,
-- capture_depth
  capture_depth AS CAPTURE_DEPTH,
-- capture_temperature_change
  temperature_change AS CAPTURE_TEMPERATURE_CHANGE,
-- release_date_time
  utc_release_date_time AS RELEASE_DATE_TIME,
-- release_location
  release_location AS RELEASE_LOCATION,
-- release_latitude
  release_latitude AS RELEASE_LATITUDE,
-- release_longitude
  release_longitude AS RELEASE_LONGITUDE,
-- recapture_date_time
  recapture_date AS RECAPTURE_DATE_TIME,
-- length1_type
  length_type AS LENGTH1_TYPE,
-- length1
  length AS LENGTH1,
-- length1_unit
  length_units AS LENGTH1_UNIT,
-- length2_type
  length2_type AS LENGTH2_TYPE,
-- length2
  length2 AS LENGTH2,
-- length2_unit
  length2_units AS LENGTH2_UNIT,
-- length3_type
  length3_type AS LENGTH3_TYPE,
-- length3
  length3 AS LENGTH3,
-- length3_unit
  length3_units AS LENGTH3_UNIT,
-- length4_type
  length4_type AS LENGTH4_TYPE,
-- length4
  length4 AS LENGTH4,
-- length4_unit
  length4_units AS LENGTH4_UNIT,
-- weight
  weight AS WEIGHT,
-- weight_unit
  weight_units AS WEIGHT_UNIT,
-- age
  age AS AGE,
-- age_unit
  age_units AS AGE_UNIT,
-- sex
  sex AS SEX,
-- life_stage
  life_stage AS LIFE_STAGE,
-- wild_or_hatchery
  wild_or_hatchery AS WILD_OR_HATCHERY,
-- stock
  stock AS STOCK,
-- surgery_date_time
  date_of_surgery AS SURGERY_DATE_TIME,
-- surgery_location
  surgery_Location AS SURGERY_LOCATION,
-- surgery_latitude
  surgery_latitude AS SURGERY_LATITUDE,
-- surgery_longitude
  surgery_longitude AS SURGERY_LONGITUDE,
-- treatment_type
  treatment_type AS TREATMENT_TYPE,
-- tagging_type
  implant_type AS TAGGING_TYPE,
-- tagging_methodology
  implant_method AS TAGGING_METHODOLOGY,
-- dna_sample
  dna_sample_taken AS DNA_SAMPLE,
-- sedative
  sedative AS SEDATIVE,
-- sedative_concentration
  sedative_concentration AS SEDATIVE_CONCENTRATION,
-- anaesthetic
  anaesthetic AS ANAESTHETIC,
-- buffer
  buffer AS BUFFER,
-- anaesthetic_concentration
  anaesthetic_concentration AS ANAESTHETIC_CONCENTRATION,
-- buffer_concentration_in_anaesthetic
  buffer_concentration_in_anaesthetic AS BUFFER_CONCENTRATION_IN_ANAESTHETIC,
-- anaesthetic_concentration_in_recirculation
  anesthetic_concentration_In_recirculation AS ANAESTHETIC_CONCENTRATION_IN_RECIRCULATION,
-- buffer_concentration_in_recirculation
  buffer_concentration_in_recirculation AS BUFFER_CONCENTRATION_IN_RECIRCULATION,
-- dissolved_oxygen
  dissolved_oxygen AS DISSOLVED_OXYGEN,
-- pre_surgery_holding_period
  preop_holding_period AS PRE_SURGERY_HOLDING_PERIOD,
-- post_surgery_holding_period
  post_op_holding_period AS POST_SURGERY_HOLDING_PERIOD,
-- holding_temperature
  holding_temperature AS HOLDING_TEMPERATURE,
-- comments
  comments AS COMMENTS

FROM common.animal_release AS animal
  LEFT JOIN common.animal_release_tag_device AS animal_with_tag
    ON animal.id_pk = animal_with_tag.animal_release_fk
  LEFT JOIN common.tag_device AS tag
    ON animal_with_tag.tag_device_fk = tag.id_pk
  LEFT JOIN acoustic.tags AS acoustic_tag
    ON tag.id_pk = acoustic_tag.tag_device_fk

  LEFT JOIN common.projects AS project
    ON animal.project_fk = project.id
