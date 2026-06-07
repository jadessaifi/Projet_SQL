-- ============================================================
--  Emergency Ambulance Dispatch System — Analytical Queries
--  Université de Montréal | Bases de données
-- ============================================================

-- 1. Available ambulances with their equipment and location
SELECT a.id_ambulance, a.equipement, a.kilometrage, p.adresse AS point_de_depart
FROM Ambulance a
JOIN EstPositionnea e ON a.id_ambulance = e.id_ambulance
JOIN PointDepart p ON e.id_point = p.id_point
WHERE a.statut = 'Disponible'
ORDER BY a.kilometrage DESC;

-- 2. Number of paramedics assigned per group
SELECT g.id_groupe, g.nb_ambulances, COUNT(ap.id_ambulancier) AS total_ambulanciers
FROM GroupeAmbulances g
LEFT JOIN AppartientA ap ON g.id_groupe = ap.id_groupe
GROUP BY g.id_groupe, g.nb_ambulances
ORDER BY g.id_groupe;

-- 3. Emergency calls with the responding ambulance
SELECT au.telephone, au.nom, au.prenom, au.adresse, r.id_ambulance
FROM AppelUrgence au
JOIN RepondreAux r ON au.telephone = r.telephone
ORDER BY au.nom;

-- 4. Hospitals with high bed capacity (> 100)
SELECT id_hopital, nb_lits
FROM Hopital
WHERE nb_lits > 100
ORDER BY nb_lits DESC;

-- 5. Dispatch points sorted by coverage radius
SELECT adresse, rayon_couverture, nb_ambulances
FROM PointDepart
ORDER BY rayon_couverture DESC;

-- 6. Ambulance shifts with duration in minutes
SELECT c.id_ambulance,
       a.prenom || ' ' || a.nom AS ambulancier,
       c.heure_debut,
       c.heure_fin,
       EXTRACT(EPOCH FROM (c.heure_fin - c.heure_debut)) / 60 AS duree_minutes
FROM Conduit c
JOIN Ambulanciers a ON c.id_ambulancier = a.id_ambulancier
ORDER BY c.heure_debut;

-- 7. Ambulances currently under repair or maintenance
SELECT id_ambulance, equipement, statut, kilometrage
FROM Ambulance
WHERE statut IN ('Réparations', 'Maintenance')
ORDER BY kilometrage ASC;

-- 8. Full dispatch chain: call → point → ambulance → paramedic
SELECT au.telephone, au.nom AS appelant, au.adresse AS adresse_urgence,
       p.adresse AS point_dispatch, amb.id_ambulance,
       ambr.prenom || ' ' || ambr.nom AS ambulancier
FROM AppelUrgence au
JOIN Recoit r ON au.telephone = r.telephone
JOIN PointDepart p ON r.id_point = p.id_point
JOIN RepondreAux ra ON au.telephone = ra.telephone
JOIN Ambulance amb ON ra.id_ambulance = amb.id_ambulance
JOIN Conduit c ON amb.id_ambulance = c.id_ambulance
JOIN Ambulanciers ambr ON c.id_ambulancier = ambr.id_ambulancier;
