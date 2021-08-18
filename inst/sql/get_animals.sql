SELECT
-- pk
  animal.id_pk AS PK,
-- animal_id
  animal.id_pk AS ANIMAL_ID,
-- animal_project_code
  animal_project.projectcode AS ANIMAL_PROJECT_CODE,
-- tag_id
  acoustic_tag.tag_full_id AS TAG_ID,
-- tag_fk
  tag.id_pk AS TAG_FK, -- This fk can remain
-- scientific_name
  animal.scientific_name AS SCIENTIFIC_NAME,
-- common_name
  animal.common_name AS COMMON_NAME,
-- aphia_id
  animal.aphia_id AS APHIA_ID,
-- animal_label
  animal.animal_id AS ANIMAL_LABEL,
-- animal_nickname
  animal.animal_nickname AS ANIMAL_NICKNAME,
-- tagger
  animal.tagger AS TAGGER,
-- capture_date_time
  animal.catched_date_time AS CAPTURE_DATE_TIME,
-- capture_location
  animal.capture_location AS CAPTURE_LOCATION,
-- capture_latitude
  animal.capture_latitude AS CAPTURE_LATITUDE,
-- capture_longitude
  animal.capture_longitude AS CAPTURE_LONGITUDE,
-- capture_method
  animal.capture_method AS CAPTURE_METHOD,
-- capture_depth
  animal.capture_depth AS CAPTURE_DEPTH,
-- capture_temperature_change
  animal.temperature_change AS CAPTURE_TEMPERATURE_CHANGE,
-- release_date_time
  animal.utc_release_date_time AS RELEASE_DATE_TIME,
-- release_location
  animal.release_location AS RELEASE_LOCATION,
-- release_latitude
  animal.release_latitude AS RELEASE_LATITUDE,
-- release_longitude
  animal.release_longitude AS RELEASE_LONGITUDE,
-- recapture_date_time
  animal.recapture_date AS RECAPTURE_DATE_TIME,
-- length1_type
  animal.length_type AS LENGTH1_TYPE,
-- length1
  animal.length AS LENGTH1,
-- length1_unit
  animal.length_units AS LENGTH1_UNIT,
-- length2_type
  animal.length2_type AS LENGTH2_TYPE,
-- length2
  animal.length2 AS LENGTH2,
-- length2_unit
  animal.length2_units AS LENGTH2_UNIT,
-- length3_type
  animal.length3_type AS LENGTH3_TYPE,
-- length3
  animal.length3 AS LENGTH3,
-- length3_unit
  animal.length3_units AS LENGTH3_UNIT,
-- length4_type
  animal.length4_type AS LENGTH4_TYPE,
-- length4
  animal.length4 AS LENGTH4,
-- length4_unit
  animal.length4_units AS LENGTH4_UNIT,
-- weight
  animal.weight AS WEIGHT,
-- weight_unit
  animal.weight_units AS WEIGHT_UNIT,
-- age
  animal.age AS AGE,
-- age_unit
  animal.age_units AS AGE_UNIT,
-- sex
  animal.sex AS SEX,
-- life_stage
  animal.life_stage AS LIFE_STAGE,
-- wild_or_hatchery
  animal.wild_or_hatchery AS WILD_OR_HATCHERY,
-- stock
  animal.stock AS STOCK,
-- surgery_date_time
  animal.date_of_surgery AS SURGERY_DATE_TIME,
-- surgery_location
  animal.surgery_Location AS SURGERY_LOCATION,
-- surgery_latitude
  animal.surgery_latitude AS SURGERY_LATITUDE,
-- surgery_longitude
  animal.surgery_longitude AS SURGERY_LONGITUDE,
-- treatment_type
  animal.treatment_type AS TREATMENT_TYPE,
-- tagging_type
  animal.implant_type AS TAGGING_TYPE,
-- tagging_methodology
  animal.implant_method AS TAGGING_METHODOLOGY,
-- dna_sample
  animal.dna_sample_taken AS DNA_SAMPLE,
-- sedative
  animal.sedative AS SEDATIVE,
-- sedative_concentration
  animal.sedative_concentration AS SEDATIVE_CONCENTRATION,
-- anaesthetic
  animal.anaesthetic AS ANAESTHETIC,
-- buffer
  animal.buffer AS BUFFER,
-- anaesthetic_concentration
  animal.anaesthetic_concentration AS ANAESTHETIC_CONCENTRATION,
-- buffer_concentration_in_anaesthetic
  animal.buffer_concentration_in_anaesthetic AS BUFFER_CONCENTRATION_IN_ANAESTHETIC,
-- anaesthetic_concentration_in_recirculation
  animal.anesthetic_concentration_In_recirculation AS ANAESTHETIC_CONCENTRATION_IN_RECIRCULATION,
-- buffer_concentration_in_recirculation
  animal.buffer_concentration_in_recirculation AS BUFFER_CONCENTRATION_IN_RECIRCULATION,
-- dissolved_oxygen
  animal.dissolved_oxygen AS DISSOLVED_OXYGEN,
-- pre_surgery_holding_period
  animal.preop_holding_period AS PRE_SURGERY_HOLDING_PERIOD,
-- post_surgery_holding_period
  animal.post_op_holding_period AS POST_SURGERY_HOLDING_PERIOD,
-- holding_temperature
  animal.holding_temperature AS HOLDING_TEMPERATURE,
-- comments
  animal.comments AS COMMENTS

FROM common.animal_release AS animal
  LEFT JOIN common.animal_release_tag_device AS animal_with_tag
    ON animal.id_pk = animal_with_tag.animal_release_fk
  LEFT JOIN common.tag_device AS tag
    ON animal_with_tag.tag_device_fk = tag.id_pk
  LEFT JOIN acoustic.tags AS acoustic_tag
    ON tag.id_pk = acoustic_tag.tag_device_fk
  LEFT JOIN common.projects AS animal_project
    ON animal.project_fk = animal_project.id
