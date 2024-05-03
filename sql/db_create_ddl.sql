PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS species;

DROP TABLE IF EXISTS sites;

DROP TABLE IF EXISTS field_sample;

DROP TABLE IF EXISTS lab_sample;

DROP TABLE IF EXISTS lab_measurement;

DROP TABLE IF EXISTS analyte;

DROP TABLE IF EXISTS project;

CREATE TABLE species -- Create a reference table for each species involved in study
(
    id_species TEXT PRIMARY KEY,
    organism TEXT NOT NULL,
    genus TEXT NOT NULL,
    species TEXT NOT NULL,
    vernacular_fr TEXT NOT NULL,
    vernacular_en TEXT NOT NULL
);

CREATE TABLE sites -- Create reference table for each site location
(
    id_name_site TEXT PRIMARY KEY,
    name_en TEXT,
    province TEXT NOT NULL,
    lat FLOAT,
    lon FLOAT,
    srid INTEGER
);

CREATE TABLE field_sample -- Create a new table which document collected field samples
(
    id_field_sample TEXT PRIMARY KEY,
    id_site TEXT NOT NULL,
    id_species TEXT NOT NULL,
    id_project TEXT,
    age TEXT,
    tissue TEXT,
    collection_date TEXT,
    FOREIGN KEY(id_site) REFERENCES sites(id_site),
    FOREIGN KEY(id_species) REFERENCES species(id_species),
    FOREIGN KEY(id_project) REFERENCES project(id_project)
);

CREATE TABLE lab_sample -- Create a new table which document all lab sample
-- Lab sample could be one or multiple field sample pooled
(
    id_lab_sample TEXT PRIMARY KEY,
    id_field_sample TEXT NOT NULL,
    id_project TEXT,
    analyze_date TEXT NOT NULL,
    id_source_report TEXT,
    path_source_report TEXT,
    note TEXT,
    FOREIGN KEY(id_field_sample) REFERENCES field_sample(id_field_sample),
    FOREIGN KEY(id_project) REFERENCES project(id_project)
);

CREATE TABLE lab_measurement -- Create a new table which contains lab measurements
(
    id_lab_measurement INTEGER PRIMARY KEY,
    id_analyte TEXT NOT NULL,
    measure FLOAT NOT NULL,
    is_censored INTEGER NOT NULL DEFAULT 0,
    id_lab_sample TEXT NOT NULL,
    performed_on_dry_weight INTEGER NOT NULL DEFAULT 1,
    performed_on_isolated_lipid INTEGER NOT NULL DEFAULT 0,
    note TEXT,
    FOREIGN KEY(id_lab_sample) REFERENCES lab_sample(id_lab_sample),
    FOREIGN KEY(id_analyte) REFERENCES analyte(id_analyte)
);

CREATE TABLE analyte -- Create table which contains analyte description provided by the lab
(
    id_analyte TEXT PRIMARY KEY,
    unit TEXT NOT NULL,
    family TEXT NOT NULL,
    cas_number TEXT,
    alias TEXT,
    note TEXT
);

CREATE TABLE project -- Create table which contains project metadata description in association with field and/or lab samples
(
    id_project TEXT PRIMARY KEY,
    title TEXT,
    organization TEXT,
    investigator TEXT NOT NULL,
    data_manager TEXT NOT NULL,
    email_investigator TEXT NOT NULL,
    email_data_manager TEXT NOT NULL,
    description TEXT
);
