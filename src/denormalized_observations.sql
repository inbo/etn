SELECT
    detections.receiver AS detections_receiver,
    detections.transmitter AS detections_transmitter,
    detections.transmitter_name AS detections_transmitter_name,
    detections.transmitter_serial AS detections_transmitter_serial,
    detections.sensor_value AS detections_sensor_value,
    detections.sensor_unit AS detections_sensor_unit,
    detections.sensor2_value AS detections_sensor2_value,
    detections.sensor2_unit AS detections_sensor2_unit,
    detections.station_name AS detections_station_name,
    detections.datetime AS detections_datetime,
    detections.id_pk AS detections_id_pk,
    detections.qc_flag AS detections_qc_flag,
    detections.file AS detections_file,
    detections.latitude AS detections_latitude,
    detections.longitude AS detections_longitude,
    detections.deployment_fk AS detections_deployment_fk,
    detections.signal_to_noise_ratio AS detections_signal_to_noise_ratio,
    detections.detection_file_id AS detections_detection_file_id,
    tags.type AS tags_type,
    tags.model AS tags_model,
    tags.tag_code_space AS tags_tag_code_space,
    tags.owner_pi AS tags_owner_pi,
    tags.owner_organization AS tags_owner_organization,
    tags.min_delay AS tags_min_delay,
    tags.max_delay AS tags_max_delay,
    tags.frequency AS tags_frequency,
    tags.acoustic_tag_type AS tags_acoustic_tag_type,
    tags.sensor_type AS tags_sensor_type,
    tags.intercept AS tags_intercept,
    tags.slope AS tags_slope,
    animals.person_id AS animals_person_id,
    animals.animal_id AS animals_animal_id,
    animals.scientific_name AS animals_scientific_name,
    animals.common_name AS animals_common_name,
    animals.length AS animals_length,
    animals.length_type AS animals_length_type,
    animals.length_units AS animals_length_units,
    animals.length2 AS animals_length2,
    animals.length2_type AS animals_length2_type,
    animals.length2_units AS animals.length2_units,
    animals.weight_units AS animals_weight_units,
    animals.age AS animals_age,
    animals.age_units AS animals_age_units,
    animals.sex AS animals_sex,
    animals.life_stage AS animals_life_stage,
    animals.capture_location AS animals_capture_location,
    animals.capture_depth AS animals_capture_depth,
    animals.utc_release_date_time AS animals_utc_release_date_time,
    animals.comments AS animals_comments,
    animals.est_tag_life AS animals_est_tag_life,
    animals.wild_or_hatchery AS animals_wild_or_hatchery,
    animals.stock AS animals_stock,
    animals.dna_sample_taken AS animals_dna_sample_taken,
    animals.treatment_type AS animals_treatment_type,
    animals.dissolved_oxygen AS animals_dissolved_oxygen,
    animals.sedative AS animals_sedative,
    animals.sedative_concentration AS animals_sedative_concentration,
    animals.temperature_change AS animals_temperature_change,
    animals.holding_temperature AS animals_holding_temperature,
    animals.preop_holding_period AS animals_preop_holding_period,
    animals.post_op_holding_period AS animals_post_op_holding_period,
    animals.surgery_location AS animals_surgery_location,
    animals.date_of_surgery AS animals_date_of_surgery,
    animals.anaesthetic AS animals_anaesthetic,
    animals.buffer AS animals_buffer,
    animals.anaesthetic_concentration AS animals_anaesthetic_concentration,
    animals.buffer_concentration_in_anaesthetic AS animals_buffer_concentration_in_anaesthetic,
    animals.anesthetic_concentration_in_recirculation AS animals_anesthetic_concentration_in_recirculation,
    animals.buffer_concentration_in_recirculation AS animals_buffer_concentration_in_recirculation,
    animals.id_pk AS animals_id_pk,
    animals.catched_date_time AS animals_catched_date_time,
    animals.tag_fk AS animals_tag_fk,
    animals.capture_latitude AS animals_capture_latitude,
    animals.capture_longitude AS animals_capture_longitude,
    animals.release_latitude AS animals_release_latitude,
    animals.release_longitude AS animals_release_longitude,
    animals.surgery_latitude AS animals_surgery_latitude,
    animals.surgery_longitude AS animals_surgery_longitude,
    animals.recapture_date AS animals_recapture_date,
    animals.implant_type AS animals_implant_type,
    animals.implant_method AS animals_implant_method,
    animals.date_modified AS animals_date_modified,
    animals.date_created AS animals_date_created,
    animals.release_location AS animals_release_location,
    animals.length3 AS animals_length3,
    animals.length3_type AS animals_length3_type,
    animals.length3_units AS animals_length3_units,
    animals.length4 AS animals_length4,
    animals.length4_type AS animals_length4_type,
    animals.length4_units AS animals_length4_units,
    animals.weight AS animals_weight,
    animals.end_date_tag AS animals_end_date_tag,
    animals.capture_method AS animals_capture_method,
    animals.project_fk AS animals_project_fk,
    animal_project.project AS animal_project_project,
    animal_project.name AS animal_project_name,
    animal_project.projectcode AS animal_project_projectcode,
    animal_project.moratorium AS animal_project_moratorium,
    network_project.project AS network_project_project,
    network_project.name AS network_project_name,
    network_project.projectcode AS network_project_projectcode,
    network_project.moratorium AS network_project_moratorium,
    deployments.station_name AS deployments_station_name,
    deployments.deploy_date_time AS deployments_deploy_date_time,
    deployments.location_name AS deployments_location_name,
    deployments.location_manager AS deployments_location_manager, 
    deployments.location_description AS deployments_location_description,
    deployments.deploy_lat AS deployments_deploy_lat,
    deployments.deploy_long AS deployments_deploy_long,
    deployments.recover_lat AS deployments_recover_lat,
    deployments.recover_long AS deployments_recover_long,
    deployments.intended_lat AS deployments_intended_lat,
    deployments.intended_long AS deployments_intended_long,
    deployments.bottom_depth AS deployments_bottom_depth,
    deployments.riser_length AS deployments_riser_length,
    deployments.instrument_depth AS deployments_instrument_depth,
    receivers.serial_number AS receivers_serial_number,
    receivers.model_number AS receivers_model_number,
    receivers.owner_organization AS receivers_owner_organization,
    receivers.status AS receivers_status,
    receivers.receiver_type AS receivers_receiver_type,
    receivers.manufacturer_fk AS receivers_manufacturer_fk
  FROM vliz.detections_view AS detections
    JOIN vliz.tags ON ((detections.transmitter)::text = (tags.tag_code_space)::text)
    JOIN vliz.animal_tag_release ON (animal_tag_release.tag_fk = tags.id_pk)
    JOIN vliz.animals_view animals ON (animals.id_pk = animal_tag_release.animal_fk)
    JOIN vliz.projects animal_project ON (animal_project.id = animals.project_fk)
    JOIN vliz.deployments_view as deployments ON (deployments.id_pk = detections.deployment_fk)
    JOIN vliz.projects network_project ON (network_project.id = deployments.project_fk)
    JOIN vliz.receivers ON (receivers.id_pk = deployments.receiver_fk);
