Emergency Ambulance Dispatch System — Relational Database

**Université de Montréal | IFT2935 - Bases de données**

A relational database modeling a real-time ambulance dispatch system for the city of Montreal. Designed to manage emergency calls, ambulance availability, paramedic assignments, dispatch points, and hospital capacity.

---

##  Database Schema

The system is composed of **7 core entities** and **6 relationship tables**:

| Table | Description |
|---|---|
| `Ambulance` | Ambulances with equipment, status, and mileage |
| `Ambulanciers` | Paramedics with personal info |
| `GroupeAmbulances` | Groups of ambulances and their staffing |
| `PointDepart` | Dispatch stations with coverage radius |
| `Hopital` | Hospitals with available bed count |
| `AppelUrgence` | Emergency calls with caller info |
| `Conduit` | Shift assignments (ambulance ↔ paramedic) |

### Entity-Relationship Overview

```
AppelUrgence ──Recoit──> PointDepart ──Clinique──> Hopital
      │                       │
  RepondreAux            Affectera / EstPositionnea
      │                       │
   Ambulance <──Conduit──> Ambulanciers
      │
  GroupeAmbulances <──AppartientA──> Ambulanciers
```

---

## Project Structure

```
ambulance-db/
├── sql/
│   ├── schema.sql      # Table definitions and constraints
│   └── queries.sql     # Analytical SQL queries
└── data/
    ├── ambulance.csv
    ├── ambulanciers.csv
    ├── appelurgence.csv
    ├── groupeambulances.csv
    ├── hopital.csv
    ├── pointdepart.csv
    ├── conduit.csv
    ├── affectera.csv
    ├── appartienta.csv
    ├── clinique.csv
    ├── estpositionnea.csv
    ├── recoit.csv
    └── repondreaux.csv
```

---

## Sample Queries

**Available ambulances and their location:**
```sql
SELECT a.id_ambulance, a.equipement, a.kilometrage, p.adresse
FROM Ambulance a
JOIN EstPositionnea e ON a.id_ambulance = e.id_ambulance
JOIN PointDepart p ON e.id_point = p.id_point
WHERE a.statut = 'Disponible';
```

**Full dispatch chain (call → ambulance → paramedic):**
```sql
SELECT au.nom AS appelant, p.adresse AS dispatch_point,
       amb.id_ambulance, ambr.prenom || ' ' || ambr.nom AS paramedic
FROM AppelUrgence au
JOIN Recoit r ON au.telephone = r.telephone
JOIN PointDepart p ON r.id_point = p.id_point
JOIN RepondreAux ra ON au.telephone = ra.telephone
JOIN Ambulance amb ON ra.id_ambulance = amb.id_ambulance
JOIN Conduit c ON amb.id_ambulance = c.id_ambulance
JOIN Ambulanciers ambr ON c.id_ambulancier = ambr.id_ambulancier;
```

---

## Technologies

- **SQL** (PostgreSQL-compatible)
- Relational modeling with foreign key constraints
- Data normalization (3NF)

---

## Author

**Jad Essaifi** — B.Sc. Computer Science, Université de Montréal  
[linkedin.com/in/jad-essaifi-28598a315](https://linkedin.com/in/jad-essaifi-28598a315)
