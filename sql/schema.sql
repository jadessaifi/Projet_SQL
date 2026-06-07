-- ============================================================
--  Emergency Ambulance Dispatch System — Database Schema
--  Université de Montréal | Bases de données
-- ============================================================

CREATE TABLE Ambulanciers (
    id_ambulancier  INT PRIMARY KEY,
    nom             VARCHAR(50) NOT NULL,
    prenom          VARCHAR(50) NOT NULL,
    adresse         VARCHAR(150)
);

CREATE TABLE GroupeAmbulances (
    id_groupe       INT PRIMARY KEY,
    nb_ambulances   INT NOT NULL,
    nb_ambulanciers INT NOT NULL
);

CREATE TABLE Ambulance (
    id_ambulance    INT PRIMARY KEY,
    id_groupe       INT NOT NULL REFERENCES GroupeAmbulances(id_groupe),
    equipement      VARCHAR(100),
    statut          VARCHAR(30) CHECK (statut IN ('Disponible', 'En mission', 'Réparations', 'Maintenance')),
    kilometrage     INT,
    CONSTRAINT chk_km CHECK (kilometrage >= 0)
);

CREATE TABLE PointDepart (
    id_point        INT PRIMARY KEY,
    adresse         VARCHAR(150) NOT NULL,
    rayon_couverture INT,
    nb_ambulances   INT
);

CREATE TABLE Hopital (
    id_hopital      INT PRIMARY KEY,
    nb_lits         INT CHECK (nb_lits > 0)
);

CREATE TABLE AppelUrgence (
    telephone       VARCHAR(15) PRIMARY KEY,
    nom             VARCHAR(50),
    prenom          VARCHAR(50),
    adresse         VARCHAR(150)
);

-- Relations

CREATE TABLE AppartientA (
    id_ambulancier  INT REFERENCES Ambulanciers(id_ambulancier),
    id_groupe       INT REFERENCES GroupeAmbulances(id_groupe),
    PRIMARY KEY (id_ambulancier, id_groupe)
);

CREATE TABLE Affectera (
    id_ambulance    INT REFERENCES Ambulance(id_ambulance),
    id_point        INT REFERENCES PointDepart(id_point),
    PRIMARY KEY (id_ambulance, id_point)
);

CREATE TABLE EstPositionnea (
    id_ambulance    INT REFERENCES Ambulance(id_ambulance),
    id_point        INT REFERENCES PointDepart(id_point),
    PRIMARY KEY (id_ambulance, id_point)
);

CREATE TABLE Clinique (
    id_hopital      INT REFERENCES Hopital(id_hopital),
    id_point        INT REFERENCES PointDepart(id_point),
    PRIMARY KEY (id_hopital, id_point)
);

CREATE TABLE Conduit (
    id_ambulance    INT REFERENCES Ambulance(id_ambulance),
    id_ambulancier  INT REFERENCES Ambulanciers(id_ambulancier),
    heure_debut     TIME,
    heure_fin       TIME,
    PRIMARY KEY (id_ambulance, id_ambulancier)
);

CREATE TABLE Recoit (
    telephone       VARCHAR(15) REFERENCES AppelUrgence(telephone),
    id_point        INT REFERENCES PointDepart(id_point),
    PRIMARY KEY (telephone, id_point)
);

CREATE TABLE RepondreAux (
    id_ambulance    INT REFERENCES Ambulance(id_ambulance),
    telephone       VARCHAR(15) REFERENCES AppelUrgence(telephone),
    PRIMARY KEY (id_ambulance, telephone)
);
