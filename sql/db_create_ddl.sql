PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS lab_field_sample;

DROP TABLE IF EXISTS lab_measurement;

DROP TABLE IF EXISTS lab_sample;

DROP TABLE IF EXISTS field_sample;

DROP TABLE IF EXISTS species;

DROP TABLE IF EXISTS sites;

DROP TABLE IF EXISTS report;

DROP TABLE IF EXISTS project;

DROP TABLE IF EXISTS analyte;

DROP TABLE IF EXISTS itgr_measurement_source;

DROP TABLE IF EXISTS itgr_analyte_source;


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

CREATE TABLE field_sample -- Create a new table which document collected field samples
(
    id_field_sample TEXT NOT NULL PRIMARY KEY,
    collection_date TEXT,
    id_site TEXT NOT NULL,
    id_species TEXT NOT NULL,
    age TEXT,
    tissue TEXT,
    FOREIGN KEY(id_site) REFERENCES sites(id_site) ON UPDATE CASCADE,
    FOREIGN KEY(id_species) REFERENCES species(id_species) ON UPDATE CASCADE
);

CREATE TABLE project -- Create table which contains project metadata description in association with field and/or lab samples
(
    id_project TEXT PRIMARY KEY,
    title TEXT,
    organization TEXT,
    investigator TEXT,
    data_manager TEXT,
    email_investigator TEXT,
    email_data_manager TEXT,
    description TEXT
);

CREATE TABLE report -- Create table which contains project metadata description in association with field and/or lab samples
(
    id_report TEXT NOT NULL PRIMARY KEY,
    id_project TEXT,
    report_date TEXT,
    report_access_path TEXT,
    FOREIGN KEY(id_project) REFERENCES project(id_project) ON UPDATE CASCADE
);

CREATE TABLE lab_sample -- Create a new table which document all lab sample
-- Lab sample could be one or multiple field sample pooled
(
    id_lab_sample TEXT NOT NULL PRIMARY KEY,
    note_lab_sample TEXT
);

CREATE TABLE lab_field_sample -- Create a new table which document all lab sample
-- Lab sample could be one or multiple field sample pooled
(
    id_lab_sample TEXT NOT NULL,
    id_field_sample TEXT,
    note_lab_field_sample TEXT,
    UNIQUE(id_lab_sample, id_field_sample) ON CONFLICT ROLLBACK,
    FOREIGN KEY(id_field_sample) REFERENCES field_sample(id_field_sample) ON UPDATE CASCADE,
    FOREIGN KEY(id_lab_sample) REFERENCES lab_sample(id_lab_sample) ON UPDATE CASCADE
);

CREATE TABLE analyte -- Create table which contains analyte description provided by the lab
(
    id_analyte TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    other_name TEXT,
    short_name TEXT, 
    unit TEXT,
    family TEXT,
    casid TEXT,
    pubcid INTEGER,
    note_analyte TEXT,
    is_dry_weight BOOLEAN CHECK (is_dry_weight IN (0, 1)),
    on_isolated_lipid BOOLEAN CHECK (on_isolated_lipid IN (0, 1))
);

CREATE TABLE itgr_analyte_source -- Create a new table which contains lab measurements
(
    id_analyte INTEGER PRIMARY KEY,
    source_file TEXT NOT NULL,
    note_itgr_analyte_source TEXT,
    FOREIGN KEY(id_analyte) REFERENCES analyte(id_analyte)
);

CREATE TABLE lab_measurement -- Create a new table which contains lab measurements
(
    id_lab_sample TEXT NOT NULL,
    id_analyte TEXT NOT NULL,
    value FLOAT NOT NULL,
    is_censored BOOLEAN CHECK (is_censored IN (0, 1)) DEFAULT 0,
    percent_lipid FLOAT,
    percent_moisture FLOAT,
    note_lab_measurement TEXT,
    UNIQUE (id_lab_sample, id_analyte) ON CONFLICT ROLLBACK,
    FOREIGN KEY(id_lab_sample) REFERENCES lab_sample(id_lab_sample) ON UPDATE CASCADE,
    FOREIGN KEY(id_analyte) REFERENCES analyte(id_analyte) ON UPDATE CASCADE
);

CREATE TABLE itgr_measurement_source -- Create a new table which contains lab measurements
(
    id_analyte TEXT NOT NULL,
    id_lab_sample TEXT NOT NULL,
    source_file TEXT NOT NULL,
    note_itgr_measurement_source TEXT,
    PRIMARY KEY (id_lab_sample, id_analyte),
    FOREIGN KEY(id_lab_sample, id_analyte) REFERENCES lab_measurement(id_lab_sample, id_analyte) ON UPDATE CASCADE
);
