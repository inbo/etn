/* Projects with controlled type */
SELECT
  project.id AS project_id,
  project.projectcode AS project_code,
  CASE
    WHEN project.type = 'animal' THEN 'animal'
    WHEN project.type = 'network' AND project.context_type = 'acoustic_telemetry' THEN 'acoustic'
    WHEN project.type = 'network' AND project.context_type = 'cpod' THEN 'cpod'
  END AS project_type,
  project.telemtry_type AS telemetry_type,
  project.name AS project_name,
  -- ADD coordinating_organization
  -- ADD principal_investigator
  -- ADD principal_investigator_email
  project.startdate AS start_date,
  project.enddate AS end_date,
  project.latitude AS latitude,
  project.longitude AS longitude,
  project.moratorium AS moratorium,
  project.imis_dataset_id AS imis_dataset_id
  -- project.mrgid
  -- project.mda_folder_id
FROM
  common.projects AS project
