-- ============================================================
--  IFT2935 - Base de données | Hiver 2025
--  Projet Final — Sujet 1 : Service d'Ambulances
--  Université de Montréal
-- ============================================================


-- ============================================================
--  ÉTAPE 3 — SCHÉMA NORMALISÉ (3NF)
-- ============================================================

DROP TABLE IF EXISTS RepondreAux   CASCADE;
DROP TABLE IF EXISTS Recoit        CASCADE;
DROP TABLE IF EXISTS Conduit       CASCADE;
DROP TABLE IF EXISTS Clinique      CASCADE;
DROP TABLE IF EXISTS EstPositionnea CASCADE;
DROP TABLE IF EXISTS Affectera     CASCADE;
DROP TABLE IF EXISTS AppartientA   CASCADE;
DROP TABLE IF EXISTS AppelUrgence  CASCADE;
DROP TABLE IF EXISTS Hopital       CASCADE;
DROP TABLE IF EXISTS PointDepart   CASCADE;
DROP TABLE IF EXISTS Ambulance     CASCADE;
DROP TABLE IF EXISTS GroupeAmbulances CASCADE;
DROP TABLE IF EXISTS Ambulanciers  CASCADE;

-- Ambulanciers
CREATE TABLE Ambulanciers (
    id_ambulancier  INT PRIMARY KEY,
    nom             VARCHAR(50)  NOT NULL,
    prenom          VARCHAR(50)  NOT NULL,
    adresse         VARCHAR(150),
    heures_jour     NUMERIC(4,1) DEFAULT 0 CHECK (heures_jour  <= 12),
    heures_semaine  NUMERIC(5,1) DEFAULT 0 CHECK (heures_semaine <= 60)
);

-- Groupes d'ambulances
CREATE TABLE GroupeAmbulances (
    id_groupe       INT PRIMARY KEY,
    nb_ambulances   INT NOT NULL CHECK (nb_ambulances > 0),
    nb_ambulanciers INT NOT NULL CHECK (nb_ambulanciers > 0)
);

-- Ambulances
CREATE TABLE Ambulance (
    id_ambulance    INT PRIMARY KEY,
    id_groupe       INT NOT NULL REFERENCES GroupeAmbulances(id_groupe),
    equipement      VARCHAR(100),
    statut          VARCHAR(20)  NOT NULL
                    CHECK (statut IN ('Disponible','En mission','Réparations','Maintenance')),
    kilometrage     INT          NOT NULL CHECK (kilometrage >= 0)
);

-- Points de départ (hôpital ou clinique)
CREATE TABLE PointDepart (
    id_point         INT PRIMARY KEY,
    adresse          VARCHAR(150) NOT NULL,
    rayon_couverture INT          CHECK (rayon_couverture > 0),
    nb_ambulances    INT          CHECK (nb_ambulances >= 0)
);

-- Hôpitaux
CREATE TABLE Hopital (
    id_hopital  INT PRIMARY KEY,
    nb_lits     INT NOT NULL CHECK (nb_lits > 0)
);

-- Appels d'urgence
CREATE TABLE AppelUrgence (
    telephone   VARCHAR(15) PRIMARY KEY,
    nom         VARCHAR(50),
    prenom      VARCHAR(50),
    adresse     VARCHAR(150)
);

-- ── TABLES DE RELATION ──

CREATE TABLE AppartientA (
    id_ambulancier  INT REFERENCES Ambulanciers(id_ambulancier) ON DELETE CASCADE,
    id_groupe       INT REFERENCES GroupeAmbulances(id_groupe)  ON DELETE CASCADE,
    PRIMARY KEY (id_ambulancier, id_groupe)
);

CREATE TABLE Affectera (
    id_ambulance    INT REFERENCES Ambulance(id_ambulance)   ON DELETE CASCADE,
    id_point        INT REFERENCES PointDepart(id_point)     ON DELETE CASCADE,
    PRIMARY KEY (id_ambulance, id_point)
);

CREATE TABLE EstPositionnea (
    id_ambulance    INT REFERENCES Ambulance(id_ambulance)   ON DELETE CASCADE,
    id_point        INT REFERENCES PointDepart(id_point)     ON DELETE CASCADE,
    PRIMARY KEY (id_ambulance, id_point)
);

CREATE TABLE Clinique (
    id_hopital      INT REFERENCES Hopital(id_hopital)       ON DELETE CASCADE,
    id_point        INT REFERENCES PointDepart(id_point)     ON DELETE CASCADE,
    PRIMARY KEY (id_hopital, id_point)
);

-- Conduit : un ambulancier conduit une ambulance sur un shift
CREATE TABLE Conduit (
    id_ambulance    INT REFERENCES Ambulance(id_ambulance)   ON DELETE CASCADE,
    id_ambulancier  INT REFERENCES Ambulanciers(id_ambulancier) ON DELETE CASCADE,
    heure_debut     TIME NOT NULL,
    heure_fin       TIME NOT NULL,
    date_shift      DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (id_ambulance, id_ambulancier, date_shift)
);

-- Reçoit : un appel est reçu par un point de départ
CREATE TABLE Recoit (
    telephone       VARCHAR(15) REFERENCES AppelUrgence(telephone) ON DELETE CASCADE,
    id_point        INT         REFERENCES PointDepart(id_point)   ON DELETE CASCADE,
    PRIMARY KEY (telephone, id_point)
);

-- Répond à : une ambulance répond à un appel
CREATE TABLE RepondreAux (
    id_ambulance    INT         REFERENCES Ambulance(id_ambulance)     ON DELETE CASCADE,
    telephone       VARCHAR(15) REFERENCES AppelUrgence(telephone)     ON DELETE CASCADE,
    PRIMARY KEY (id_ambulance, telephone)
);


-- ============================================================
--  ÉTAPE 4 — INSERTION DES DONNÉES (10+ tuples par table)
-- ============================================================

INSERT INTO Ambulanciers VALUES
(1,  'Gagnon',     'Alice',   '5737 Boulevard Laurier, Montréal, QC',    7.5, 37.5),
(2,  'Tremblay',   'Louis',   '3439 Rue Ontario, Montréal, QC',          8.0, 40.0),
(3,  'Roy',        'Emma',    '2089 Boulevard Jean-Talon, Montréal, QC', 6.0, 30.0),
(4,  'Bouchard',   'Hugo',    '9467 Boulevard Mont-Royal, Montréal, QC', 9.0, 45.0),
(5,  'Lavoie',     'Léa',     '1310 Rue Inconnue 33, Montréal, QC',      7.0, 35.0),
(6,  'Fortin',     'Nathan',  '6288 Boulevard Guy, Montréal, QC',        8.5, 42.5),
(7,  'Morin',      'Inès',    '1653 Boulevard Hochelaga, Montréal, QC',  6.5, 32.5),
(8,  'Gauthier',   'Noah',    '4878 Rue Inconnue 31, Montréal, QC',      9.5, 47.5),
(9,  'Pelletier',  'Chloé',   '5943 Boulevard Bernard, Montréal, QC',   7.5, 37.5),
(10, 'Côté',       'Lucas',   '2469 Rue Sherbrooke, Montréal, QC',       8.0, 40.0),
(11, 'Desjardins', 'Sarah',   '6497 Rue Rachel, Montréal, QC',           6.0, 30.0),
(12, 'Lefebvre',   'Alice',   '8000 Rue Hochelaga, Montréal, QC',        7.0, 35.0);

INSERT INTO GroupeAmbulances VALUES
(1,  3, 2),
(2,  4, 4),
(3,  5, 3),
(4,  2, 1),
(5,  6, 6),
(6,  3, 2),
(7,  4, 2),
(8,  5, 5),
(9,  2, 2),
(10, 3, 3),
(11, 6, 4);

INSERT INTO Ambulance VALUES
(1,  4, 'Défibrillateur',           'Disponible',  78),
(2,  3, 'Oxygène',                  'En mission',   64),
(3,  5, 'Brancard',                 'Réparations',  49),
(4,  4, 'Défibrillateur, Oxygène',  'Disponible',   88),
(5,  6, 'Défibrillateur, Brancard', 'Maintenance',  52),
(6,  2, 'Brancard, Oxygène',        'En mission',   69),
(7,  4, 'Aspirateur médical',       'Disponible',   80),
(8,  3, 'Oxygène',                  'Réparations',  34),
(9,  5, 'Défibrillateur, Brancard', 'Disponible',   90),
(10, 6, 'Brancard',                 'Maintenance',  58),
(11, 2, 'Défibrillateur',           'Disponible',   72);

INSERT INTO PointDepart VALUES
(1,  '7111 Rue Saint-Paul, Montréal, QC',             30, 11),
(2,  '5160 Avenue Sainte-Catherine, Montréal, QC',    39, 13),
(3,  '9643 Avenue Papineau, Montréal, QC',            26, 12),
(4,  '4670 Avenue Jarry, Montréal, QC',               24, 20),
(5,  '4268 Boulevard Berri, Montréal, QC',            38, 14),
(6,  '4585 Rue Saint-Laurent, Montréal, QC',          39, 19),
(7,  '8120 Boulevard Côte-des-Neiges, Montréal, QC',  27, 17),
(8,  '1125 Avenue Saint-Zotique, Montréal, QC',       28, 12),
(9,  '5407 Avenue Clark, Montréal, QC',               37, 14),
(10, '7143 Boulevard Cherrier, Montréal, QC',         38, 13),
(11, '9991 Rue Masson, Montréal, QC',                 28, 13);

INSERT INTO Hopital VALUES
(1,  85),
(2,  90),
(3,  75),
(4, 110),
(5,  95),
(6, 105),
(7,  88),
(8, 102),
(9,  97),
(10,120),
(11, 93);

INSERT INTO AppelUrgence VALUES
('5141234567', 'Gagnon',    'Alice',   '1901 Rue Rosemont, Montréal, QC'),
('5142345678', 'Tremblay',  'Louis',   '1857 Boulevard Saint-Hubert, Montréal, QC'),
('5143456789', 'Roy',       'Emma',    '6844 Avenue Beaubien, Montréal, QC'),
('5144567890', 'Bouchard',  'Hugo',    '6169 Avenue Saint-Joseph, Montréal, QC'),
('5145678901', 'Lavoie',    'Léa',     '1330 Avenue De Lorimier, Montréal, QC'),
('5146789012', 'Fortin',    'Nathan',  '8001 Boulevard Duluth, Montréal, QC'),
('5147890123', 'Morin',     'Inès',    '3359 Boulevard Saint-Denis, Montréal, QC'),
('5148901234', 'Gauthier',  'Noah',    '4205 Boulevard Viau, Montréal, QC'),
('5149012345', 'Pelletier', 'Chloé',   '3913 Avenue Pie-IX, Montréal, QC'),
('5140123456', 'Côté',      'Lucas',   '8123 Boulevard Rue Inconnue 32, Montréal, QC'),
('5141122334', 'Desjardins','Sarah',   '4758 Rue Notre-Dame, Montréal, QC');

INSERT INTO AppartientA VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,11),(12,1);

INSERT INTO Affectera VALUES
(1,2),(2,3),(3,4),(4,5),(5,6),(6,7),(7,8),(8,9),(9,10),(10,11),(11,1);

INSERT INTO EstPositionnea VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,11);

INSERT INTO Clinique VALUES
(1,4),(2,6),(3,5),(4,7),(5,8),(6,9),(7,10),(8,11),(9,1),(10,2),(11,3);

INSERT INTO Conduit VALUES
(1,  12, '08:00', '08:30', '2025-01-15'),
(2,  13, '09:00', '09:45', '2025-01-15'),
(3,  14, '07:30', '08:15', '2025-01-15'),
(4,  15, '10:00', '10:40', '2025-01-15'),
(5,  16, '11:00', '11:30', '2025-01-15'),
(6,  17, '12:00', '12:45', '2025-01-15'),
(7,  18, '13:00', '13:30', '2025-01-15'),
(8,  19, '14:00', '14:30', '2025-01-15'),
(9,  20, '15:00', '15:30', '2025-01-15'),
(10, 21, '16:00', '16:40', '2025-01-15'),
(11, 22, '17:00', '17:30', '2025-01-15');

INSERT INTO Recoit VALUES
('5141234567',1),('5142345678',2),('5143456789',3),('5144567890',4),
('5145678901',5),('5146789012',6),('5147890123',7),('5148901234',8),
('5149012345',9),('5140123456',10),('5141122334',11);

INSERT INTO RepondreAux VALUES
(1,'5141234567'),(2,'5142345678'),(3,'5143456789'),(4,'5144567890'),
(5,'5145678901'),(6,'5146789012'),(7,'5147890123'),(8,'5148901234'),
(9,'5149012345'),(10,'5140123456'),(11,'5141122334');


-- ============================================================
--  ÉTAPE 5 — QUESTIONS / RÉPONSES EN SQL
-- ============================================================

-- ── Question 1 ──────────────────────────────────────────────
-- Quelles ambulances sont disponibles, quel est leur équipement
-- et depuis quel point de départ opèrent-elles ?
-- (Jointure triple + filtre sur statut)

SELECT
    a.id_ambulance,
    a.equipement,
    a.kilometrage,
    p.adresse       AS point_de_depart,
    p.rayon_couverture
FROM Ambulance a
JOIN EstPositionnea ep ON a.id_ambulance = ep.id_ambulance
JOIN PointDepart p     ON ep.id_point    = p.id_point
WHERE a.statut = 'Disponible'
ORDER BY a.kilometrage DESC;


-- ── Question 2 ──────────────────────────────────────────────
-- Quel est le nombre d'ambulanciers affectés à chaque groupe,
-- et ce groupe est-il sous-effectif par rapport à sa taille déclarée ?
-- (Agrégation + comparaison avec valeur déclarée)

SELECT
    g.id_groupe,
    g.nb_ambulances,
    g.nb_ambulanciers                    AS effectif_prevu,
    COUNT(ap.id_ambulancier)             AS effectif_reel,
    CASE
        WHEN COUNT(ap.id_ambulancier) < g.nb_ambulanciers
        THEN 'Sous-effectif'
        ELSE 'Complet'
    END                                  AS statut_effectif
FROM GroupeAmbulances g
LEFT JOIN AppartientA ap ON g.id_groupe = ap.id_groupe
GROUP BY g.id_groupe, g.nb_ambulances, g.nb_ambulanciers
ORDER BY g.id_groupe;


-- ── Question 3 ──────────────────────────────────────────────
-- Pour chaque appel d'urgence, afficher la chaîne complète :
-- appelant → point de dispatch → ambulance assignée → ambulancier
-- (Jointure multiple sur 6 tables)

SELECT
    au.telephone,
    au.nom || ' ' || au.prenom           AS appelant,
    au.adresse                           AS adresse_urgence,
    p.adresse                            AS point_dispatch,
    amb.id_ambulance,
    amb.equipement,
    ambr.prenom || ' ' || ambr.nom       AS ambulancier,
    c.heure_debut,
    c.heure_fin
FROM AppelUrgence au
JOIN Recoit      r   ON au.telephone     = r.telephone
JOIN PointDepart p   ON r.id_point       = p.id_point
JOIN RepondreAux ra  ON au.telephone     = ra.telephone
JOIN Ambulance   amb ON ra.id_ambulance  = amb.id_ambulance
JOIN Conduit     c   ON amb.id_ambulance = c.id_ambulance
JOIN Ambulanciers ambr ON c.id_ambulancier = ambr.id_ambulancier
ORDER BY au.nom;


-- ── Question 4 ──────────────────────────────────────────────
-- Quels ambulanciers dépassent 8h de travail par jour
-- ou 40h par semaine, et quel est leur point de départ ?
-- (Filtre sur contraintes horaires + jointure)

SELECT
    amb.id_ambulancier,
    amb.prenom || ' ' || amb.nom         AS ambulancier,
    amb.heures_jour,
    amb.heures_semaine,
    p.adresse                            AS point_de_depart,
    CASE
        WHEN amb.heures_jour > 8  AND amb.heures_semaine > 40
        THEN 'Dépassement jour ET semaine'
        WHEN amb.heures_jour > 8
        THEN 'Dépassement journalier'
        ELSE 'Dépassement hebdomadaire'
    END                                  AS type_depassement
FROM Ambulanciers amb
JOIN AppartientA  ap ON amb.id_ambulancier = ap.id_ambulancier
JOIN GroupeAmbulances g ON ap.id_groupe    = g.id_groupe
JOIN Affectera    af ON af.id_ambulance IN (
    SELECT id_ambulance FROM Ambulance WHERE id_groupe = g.id_groupe LIMIT 1
)
JOIN PointDepart  p  ON af.id_point        = p.id_point
WHERE amb.heures_jour > 8 OR amb.heures_semaine > 40
ORDER BY amb.heures_semaine DESC;
