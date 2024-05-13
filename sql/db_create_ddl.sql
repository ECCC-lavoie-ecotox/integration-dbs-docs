PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS species;

DROP TABLE IF EXISTS sites;

DROP TABLE IF EXISTS project;

DROP TABLE IF EXISTS report;

DROP TABLE IF EXISTS field_sample;

DROP TABLE IF EXISTS lab_sample;

DROP TABLE IF EXISTS lab_measurement;

DROP TABLE IF EXISTS analyte;

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
    id_site TEXT PRIMARY KEY,
    name_en TEXT,
    province TEXT NOT NULL,
    lat FLOAT,
    lon FLOAT,
    srid INTEGER
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

CREATE TABLE report -- Create table which contains project metadata description in association with field and/or lab samples
(
    id_report TEXT NOT NULL PRIMARY KEY,
    id_project TEXT,
    report_date TEXT,
    report_access_path TEXT,
    FOREIGN KEY(id_project) REFERENCES project(id_project)
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

CREATE TABLE field_sample -- Create a new table which document collected field samples
(
    id_field_sample TEXT PRIMARY KEY,
    id_site TEXT NOT NULL,
    id_species TEXT NOT NULL,
    age TEXT,
    tissue TEXT,
    collection_date TEXT,
    FOREIGN KEY(id_site) REFERENCES sites(id_site),
    FOREIGN KEY(id_species) REFERENCES species(id_species)
);

CREATE TABLE lab_sample -- Create a new table which document all lab sample
-- Lab sample could be one or multiple field sample pooled
(
    id_lab_sample TEXT PRIMARY KEY,
    id_field_sample TEXT NOT NULL,
    id_report TEXT,
    note TEXT,
    FOREIGN KEY(id_field_sample) REFERENCES field_sample(id_field_sample),
    FOREIGN KEY(id_report) REFERENCES report(id_report),
);

CREATE TABLE lab_measurement -- Create a new table which contains lab measurements
(
    id_lab_measurement INTEGER PRIMARY KEY,
    id_analyte TEXT NOT NULL,
    id_lab_sample TEXT NOT NULL,
    measure FLOAT NOT NULL,
    is_censored INTEGER NOT NULL DEFAULT 0,
    note TEXT,
    FOREIGN KEY(id_lab_sample) REFERENCES lab_sample(id_lab_sample),
    FOREIGN KEY(id_analyte) REFERENCES analyte(id_analyte)
);
