# Base de Données MedicApp - SQLite V19

## Vue d'ensemble

MedicApp utilise SQLite V19 comme système de gestion de base de données local. L'architecture est conçue pour supporter plusieurs personnes (utilisateurs) qui peuvent partager des médicaments mais maintenir des configurations et posologies individuelles.

### Caractéristiques Principales

- **Version Actuelle** : V19 (dernière version stable)
- **Moteur** : SQLite avec `sqflite` (Flutter)
- **Architecture** : Multi-personne avec données partagées et configurations individuelles
- **Emplacement** : `medications.db` dans le répertoire de base de données de l'application
- **Migrations** : Système automatique de migrations progressives (V1 → V19)
- **Intégrité** : Clés étrangères activées avec cascades de suppression
- **Index** : Optimisés pour les requêtes fréquentes

### Philosophie de Conception

La base de données V19 implémente une **séparation claire entre données partagées et données individuelles** :

- **Données Partagées** (table `medications`) : Stock de médicaments pouvant être utilisé par n'importe quelle personne
- **Données Individuelles** (table `person_medications`) : Posologies, horaires et configurations spécifiques à chaque personne
- **Relation N:N** : Une personne peut avoir plusieurs médicaments, et un médicament peut être assigné à plusieurs personnes

---

## Schéma de Tables

### Table : `persons`

Stocke les personnes qui utilisent l'application (utilisateurs, membres de la famille, patients).

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER NOT NULL DEFAULT 0
)
```

#### Champs

| Champ | Type | Description |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identifiant unique de la personne (UUID en format string) |
| `name` | TEXT NOT NULL | Nom de la personne |
| `isDefault` | INTEGER NOT NULL | 1 si c'est la personne par défaut (utilisateur principal), 0 sinon |

#### Règles

- Il doit exister au moins une personne avec `isDefault = 1`
- Les IDs sont générés comme timestamps en millisecondes
- Le nom ne peut pas être vide

---

### Table : `medications`

Stocke les **données partagées** des médicaments (nom, type, stock).

```sql
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
)
```

#### Champs

| Champ | Type | Description |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identifiant unique du médicament (UUID en format string) |
| `name` | TEXT NOT NULL | Nom du médicament (ex : "Ibuprofène 600mg") |
| `type` | TEXT NOT NULL | Type de médicament : `pill`, `syrup`, `drops`, `injection`, `capsule`, `tablet`, `cream`, `patch`, `inhaler`, `other` |
| `stockQuantity` | REAL NOT NULL | Quantité actuelle en stock (partagée entre toutes les personnes) |
| `lastRefillAmount` | REAL | Dernière quantité ajoutée au stock (suggestion pour futurs réapprovisionnements) |
| `lowStockThresholdDays` | INTEGER NOT NULL | Jours de seuil pour afficher l'alerte de stock bas (défaut : 3) |
| `lastDailyConsumption` | REAL | Dernière quantité consommée en un jour (pour médicaments "si nécessaire") |

#### Notes

- **Stock Partagé** : Le `stockQuantity` est unique et partagé entre toutes les personnes qui utilisent le médicament
- **Déduplication** : Si deux personnes ajoutent le même médicament (nom correspondant, insensible à la casse), l'enregistrement existant est réutilisé
- **Types** : Le champ `type` détermine l'unité de mesure (pilules, ml, gouttes, etc.)

---

### Table : `person_medications`

Table de relation N:N qui stocke la **posologie individuelle** de chaque personne pour un médicament spécifique.

```sql
CREATE TABLE person_medications (
  id TEXT PRIMARY KEY,
  personId TEXT NOT NULL,
  medicationId TEXT NOT NULL,
  assignedDate TEXT NOT NULL,
  durationType TEXT NOT NULL,
  dosageIntervalHours INTEGER NOT NULL DEFAULT 0,
  doseSchedule TEXT NOT NULL,
  takenDosesToday TEXT NOT NULL,
  skippedDosesToday TEXT NOT NULL,
  takenDosesDate TEXT,
  selectedDates TEXT,
  weeklyDays TEXT,
  dayInterval INTEGER,
  startDate TEXT,
  endDate TEXT,
  requiresFasting INTEGER NOT NULL DEFAULT 0,
  fastingType TEXT,
  fastingDurationMinutes INTEGER,
  notifyFasting INTEGER NOT NULL DEFAULT 0,
  isSuspended INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE,
  FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE,
  UNIQUE(personId, medicationId)
)
```

#### Champs

| Champ | Type | Description |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identifiant unique de la relation personne-médicament |
| `personId` | TEXT NOT NULL | FK vers `persons.id` |
| `medicationId` | TEXT NOT NULL | FK vers `medications.id` |
| `assignedDate` | TEXT NOT NULL | Date ISO8601 d'assignation du médicament à la personne |
| `durationType` | TEXT NOT NULL | Type de durée : `everyday`, `untilFinished`, `specificDates`, `weeklyPattern`, `intervalDays`, `asNeeded` |
| `dosageIntervalHours` | INTEGER NOT NULL | Intervalle d'heures entre doses (0 si non applicable) |
| `doseSchedule` | TEXT NOT NULL | JSON avec mappage heure → quantité (ex : `{"08:00": 1.0, "20:00": 0.5}`) |
| `takenDosesToday` | TEXT NOT NULL | Liste CSV des heures prises aujourd'hui (ex : `"08:00,20:00"`) |
| `skippedDosesToday` | TEXT NOT NULL | Liste CSV des heures omises aujourd'hui (ex : `"14:00"`) |
| `takenDosesDate` | TEXT | Date ISO8601 des doses prises/omises (ex : `"2025-11-14"`) |
| `selectedDates` | TEXT | Liste CSV de dates spécifiques pour `durationType = specificDates` |
| `weeklyDays` | TEXT | Liste CSV de jours de la semaine (1=Lundi, 7=Dimanche) pour `weeklyPattern` |
| `dayInterval` | INTEGER | Intervalle de jours pour `durationType = intervalDays` (ex : 2 = tous les 2 jours) |
| `startDate` | TEXT | Date ISO8601 de début du traitement |
| `endDate` | TEXT | Date ISO8601 de fin du traitement |
| `requiresFasting` | INTEGER NOT NULL | 1 si jeûne requis, 0 sinon |
| `fastingType` | TEXT | Type de jeûne : `before` ou `after` |
| `fastingDurationMinutes` | INTEGER | Durée du jeûne en minutes (ex : 30, 60, 120) |
| `notifyFasting` | INTEGER NOT NULL | 1 si doit notifier les périodes de jeûne, 0 sinon |
| `isSuspended` | INTEGER NOT NULL | 1 si le médicament est suspendu (sans notifications), 0 sinon |

#### Notes

- **Relation Unique** : Une personne ne peut pas avoir le même médicament assigné deux fois (`UNIQUE(personId, medicationId)`)
- **Cascades** : Si une personne ou un médicament est supprimé, les relations sont automatiquement supprimées
- **doseSchedule** : Stocké en JSON pour flexibilité (ex : différentes quantités à différentes heures)
- **Types de Durée** :
  - `everyday` : Tous les jours
  - `untilFinished` : Jusqu'à épuisement du stock
  - `specificDates` : Seulement à dates spécifiques (stockées dans `selectedDates`)
  - `weeklyPattern` : Jours spécifiques de la semaine (stockés dans `weeklyDays`)
  - `intervalDays` : Tous les N jours (spécifié dans `dayInterval`)
  - `asNeeded` : Si nécessaire (sans horaire fixe)

---

### Table : `dose_history`

Enregistrement historique de toutes les doses prises ou omises.

```sql
CREATE TABLE dose_history (
  id TEXT PRIMARY KEY,
  medicationId TEXT NOT NULL,
  medicationName TEXT NOT NULL,
  medicationType TEXT NOT NULL,
  personId TEXT NOT NULL,
  scheduledDateTime TEXT NOT NULL,
  registeredDateTime TEXT NOT NULL,
  status TEXT NOT NULL,
  quantity REAL NOT NULL,
  isExtraDose INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
)
```

#### Champs

| Champ | Type | Description |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identifiant unique de l'entrée d'historique |
| `medicationId` | TEXT NOT NULL | ID du médicament (dénormalisé pour performance) |
| `medicationName` | TEXT NOT NULL | Nom du médicament (dénormalisé) |
| `medicationType` | TEXT NOT NULL | Type du médicament (dénormalisé) |
| `personId` | TEXT NOT NULL | FK vers `persons.id` - personne qui a pris/omis la dose |
| `scheduledDateTime` | TEXT NOT NULL | Date et heure ISO8601 programmées pour la dose |
| `registeredDateTime` | TEXT NOT NULL | Date et heure ISO8601 réelles d'enregistrement de la prise/omission |
| `status` | TEXT NOT NULL | État de la dose : `taken` ou `skipped` |
| `quantity` | REAL NOT NULL | Quantité prise (en unités du type de médicament) |
| `isExtraDose` | INTEGER NOT NULL | 1 si dose extra (hors horaire), 0 si programmée |
| `notes` | TEXT | Notes optionnelles sur la dose |

#### Notes

- **Dénormalisation** : `medicationName` et `medicationType` sont stockés ici pour éviter les JOINs dans les requêtes d'historique
- **Cascade** : Si une personne est supprimée, ses enregistrements d'historique sont supprimés
- **Pas de FK vers medications** : L'historique est maintenu même si le médicament est supprimé
- **Retard** : La différence entre `scheduledDateTime` et `registeredDateTime` indique si la dose était ponctuelle

---

## Relations entre Tables

```
┌──────────────┐
│   persons    │
│──────────────│
│ id (PK)      │───┐
│ name         │   │
│ isDefault    │   │
└──────────────┘   │
                   │
                   │ 1:N
                   │
                   ↓
         ┌──────────────────────┐
         │ person_medications   │
         │──────────────────────│
         │ id (PK)              │
         │ personId (FK)        │──→ persons.id
         │ medicationId (FK)    │──→ medications.id
         │ [posologie individuelle]   │
         └──────────────────────┘
                   │
                   │ N:1
                   │
                   ↓
         ┌──────────────────┐
         │  medications     │
         │──────────────────│
         │ id (PK)          │
         │ name             │
         │ type             │
         │ stockQuantity    │
         │ [stock data]     │
         └──────────────────┘


┌──────────────┐
│   persons    │
│──────────────│
│ id (PK)      │───┐
└──────────────┘   │
                   │ 1:N
                   │
                   ↓
         ┌──────────────────┐
         │  dose_history    │
         │──────────────────│
         │ id (PK)          │
         │ personId (FK)    │──→ persons.id
         │ medicationId     │ (pas FK, dénormalisé)
         │ scheduledDateTime│
         │ registeredDateTime│
         │ status           │
         └──────────────────┘
```

### Clés Étrangères

| Table | Colonne | Référence | On Delete |
|-------|---------|-----------|-----------|
| `person_medications` | `personId` | `persons.id` | CASCADE |
| `person_medications` | `medicationId` | `medications.id` | CASCADE |
| `dose_history` | `personId` | `persons.id` | CASCADE |

---

## Index

Les index suivants sont créés pour optimiser les requêtes fréquentes :

```sql
-- Index pour rechercher doses par médicament
CREATE INDEX idx_dose_history_medication
ON dose_history(medicationId);

-- Index pour rechercher doses par date programmée
CREATE INDEX idx_dose_history_date
ON dose_history(scheduledDateTime);

-- Index pour rechercher médicaments d'une personne
CREATE INDEX idx_person_medications_person
ON person_medications(personId);

-- Index pour rechercher personnes assignées à un médicament
CREATE INDEX idx_person_medications_medication
ON person_medications(medicationId);
```

### Objectif de Chaque Index

- **`idx_dose_history_medication`** : Accélère les requêtes d'historique filtrées par médicament (ex : voir toutes les prises d'Ibuprofène)
- **`idx_dose_history_date`** : Optimise les requêtes par plage de dates (ex : historique des 7 derniers jours)
- **`idx_person_medications_person`** : Améliore le chargement des médicaments d'une personne spécifique (requête la plus fréquente)
- **`idx_person_medications_medication`** : Facilite la recherche de personnes utilisant un médicament

---

## Triggers

Actuellement, aucun trigger n'est implémenté dans la base de données. La logique métier est gérée dans la couche applicative (Dart).

**Triggers Futurs Possibles :**

```sql
-- Exemple : Mettre à jour automatiquement le stock lors de l'enregistrement d'une dose prise
CREATE TRIGGER update_stock_on_dose_taken
AFTER INSERT ON dose_history
WHEN NEW.status = 'taken' AND NEW.isExtraDose = 0
BEGIN
  UPDATE medications
  SET stockQuantity = stockQuantity - NEW.quantity
  WHERE id = NEW.medicationId;
END;
```

**Note** : Ce trigger n'est pas implémenté car le contrôle du stock est géré explicitement dans le code de l'application pour plus de flexibilité.

---

## Migrations

### Historique des Versions (V1 → V19)

| Version | Changements Principaux |
|---------|------------------------|
| **V1** | Schéma initial : table `medications` basique |
| **V2** | Ajout de `doseTimes` (horaires de dose) |
| **V3** | Ajout de `stockQuantity` (gestion d'inventaire) |
| **V4** | Ajout de `takenDosesToday`, `takenDosesDate` (suivi des prises quotidiennes) |
| **V5** | Ajout de `doseSchedule` (quantités variables par horaire) |
| **V6** | Ajout de `skippedDosesToday` (suivi des doses omises) |
| **V7** | Ajout de `lastRefillAmount` (suggestions de réapprovisionnement) |
| **V8** | Ajout de `lowStockThresholdDays` (seuil configurable) |
| **V9** | Ajout de `selectedDates`, `weeklyDays` (schémas de traitement) |
| **V10** | Ajout de `startDate`, `endDate` (plage de traitement) |
| **V11** | Création de table `dose_history` (historique complet de doses) |
| **V12** | Ajout de `dayInterval` (traitements tous les N jours) |
| **V13** | Ajout de champs de jeûne : `requiresFasting`, `fastingType`, `fastingDurationMinutes`, `notifyFasting` |
| **V14** | Ajout de `isSuspended` (suspension temporaire de médicaments) |
| **V15** | Ajout de `lastDailyConsumption` (suivi pour médicaments "si nécessaire") |
| **V16** | Ajout de `extraDosesToday` et `isExtraDose` (doses hors horaire) |
| **V17** | Création de table `persons` (support multi-personne) |
| **V18** | Création de table `person_medications` (relation N:N), ajout de `personId` à `dose_history` |
| **V19** | **Restructuration majeure** : Séparation de données partagées (medications) et posologies individuelles (person_medications) |

### Migration V18 → V19 (Restructuration Majeure)

La migration V19 est la plus complexe et importante. Elle sépare les données de médicaments en deux tables :

#### Processus de Migration

1. **Backup** : Les tables existantes sont renommées en `_old`
2. **Nouvelles Tables** : Création de `medications` et `person_medications` avec le nouveau schéma
3. **Migration de Données Partagées** : Copie de `id`, `name`, `type`, `stockQuantity`, etc. vers `medications`
4. **Migration de Posologies Individuelles** : Copie des horaires, durée, jeûne, etc. vers `person_medications`
5. **Recréation des Index** : Création des index optimisés
6. **Nettoyage** : Suppression des tables `_old`

```sql
-- Étape 1 : Backup
ALTER TABLE person_medications RENAME TO person_medications_old;
ALTER TABLE medications RENAME TO medications_old;

-- Étape 2 : Créer nouvelle table medications (seulement données partagées)
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
);

-- Étape 3 : Copier données partagées
INSERT INTO medications (id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption)
SELECT id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption
FROM medications_old;

-- Étape 4 : Créer nouvelle table person_medications (posologies individuelles)
CREATE TABLE person_medications (
  id TEXT PRIMARY KEY,
  personId TEXT NOT NULL,
  medicationId TEXT NOT NULL,
  assignedDate TEXT NOT NULL,
  durationType TEXT NOT NULL,
  dosageIntervalHours INTEGER NOT NULL DEFAULT 0,
  doseSchedule TEXT NOT NULL,
  takenDosesToday TEXT NOT NULL,
  skippedDosesToday TEXT NOT NULL,
  takenDosesDate TEXT,
  selectedDates TEXT,
  weeklyDays TEXT,
  dayInterval INTEGER,
  startDate TEXT,
  endDate TEXT,
  requiresFasting INTEGER NOT NULL DEFAULT 0,
  fastingType TEXT,
  fastingDurationMinutes INTEGER,
  notifyFasting INTEGER NOT NULL DEFAULT 0,
  isSuspended INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE,
  FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE,
  UNIQUE(personId, medicationId)
);

-- Étape 5 : Migrer posologies individuelles
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate,
  durationType, dosageIntervalHours, doseSchedule,
  takenDosesToday, skippedDosesToday, takenDosesDate,
  selectedDates, weeklyDays, dayInterval,
  startDate, endDate,
  requiresFasting, fastingType, fastingDurationMinutes, notifyFasting,
  isSuspended
)
SELECT
  pm.id, pm.personId, pm.medicationId, pm.assignedDate,
  m.durationType, m.dosageIntervalHours, m.doseSchedule,
  m.takenDosesToday, m.skippedDosesToday, m.takenDosesDate,
  m.selectedDates, m.weeklyDays, m.dayInterval,
  m.startDate, m.endDate,
  m.requiresFasting, m.fastingType, m.fastingDurationMinutes, m.notifyFasting,
  m.isSuspended
FROM person_medications_old pm
INNER JOIN medications_old m ON pm.medicationId = m.id;

-- Étape 6 : Recréer index
CREATE INDEX idx_person_medications_person ON person_medications(personId);
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);

-- Étape 7 : Nettoyage
DROP TABLE person_medications_old;
DROP TABLE medications_old;
```

### Système de Migration Automatique

Le système détecte automatiquement la version actuelle de la base de données et applique les migrations progressives :

```dart
// Dans database_helper.dart
Future<Database> _initDB(String filePath) async {
  return await openDatabase(
    path,
    version: 19,  // Version cible
    onCreate: _createDB,  // Pour nouvelles bases de données
    onUpgrade: _upgradeDB,  // Pour migrer depuis versions antérieures
  );
}

Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  // Applique migrations progressives depuis oldVersion jusqu'à newVersion
  if (oldVersion < 2) { /* Migration V1→V2 */ }
  if (oldVersion < 3) { /* Migration V2→V3 */ }
  // ... jusqu'à V19
}
```

**Avantages** :
- **Progressif** : Un utilisateur avec V1 se met à jour automatiquement jusqu'à V19
- **Sans perte de données** : Chaque migration préserve les données existantes
- **Tolérant aux erreurs** : Si une migration échoue, la base de données reste dans l'état antérieur

---

## Règles Métier

### 1. Stock Partagé entre Personnes

- Le `stockQuantity` dans la table `medications` est **unique et partagé**
- Quand n'importe quelle personne enregistre une dose prise, le stock décrémente pour tous
- **Exemple** : S'il y a 20 comprimés d'Ibuprofène et Ana en prend 1, il en reste 19 pour tous (y compris Carlos)

### 2. Configurations Individuelles par Personne

- Chaque personne peut avoir **des horaires différents** pour le même médicament
- **Exemple** :
  - Ana prend Ibuprofène à 08:00 et 20:00
  - Carlos prend le même Ibuprofène seulement à 14:00

### 3. Validations d'Intégrité

```sql
-- Une personne ne peut pas avoir le même médicament deux fois
UNIQUE(personId, medicationId) dans person_medications

-- Il doit exister au moins une personne par défaut
-- (Validé dans la couche applicative)
```

### 4. Cascades de Suppression

- **Supprimer personne** → Supprime toutes ses relations dans `person_medications` et son historique dans `dose_history`
- **Supprimer médicament** → Supprime toutes les relations dans `person_medications`, mais **PAS** l'historique (pour audit)

### 5. Déduplication de Médicaments

Lors de la création d'un médicament, le système vérifie si un médicament avec le même nom existe déjà (insensible à la casse) :

```dart
// Pseudocode
if (exists medication with same name) {
  réutiliser médicament existant
  créer seulement nouvelle entrée dans person_medications
} else {
  créer nouveau médicament
  créer entrée dans person_medications
}
```

---

## Requêtes SQL Courantes

### 1. Obtenir Médicaments d'une Personne

```sql
SELECT
  m.id,
  m.name,
  m.type,
  m.stockQuantity,
  m.lastRefillAmount,
  m.lowStockThresholdDays,
  m.lastDailyConsumption,
  pm.durationType,
  pm.dosageIntervalHours,
  pm.doseSchedule,
  pm.takenDosesToday,
  pm.skippedDosesToday,
  pm.takenDosesDate,
  pm.selectedDates,
  pm.weeklyDays,
  pm.dayInterval,
  pm.startDate,
  pm.endDate,
  pm.requiresFasting,
  pm.fastingType,
  pm.fastingDurationMinutes,
  pm.notifyFasting,
  pm.isSuspended
FROM medications m
INNER JOIN person_medications pm ON m.id = pm.medicationId
WHERE pm.personId = ?
```

### 2. Enregistrer une Prise de Médicament

```sql
-- Étape 1 : Insérer dans historique
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose, notes
) VALUES (?, ?, ?, ?, ?, ?, ?, 'taken', ?, 0, ?);

-- Étape 2 : Mettre à jour stock (seulement si dose programmée, pas extra)
UPDATE medications
SET stockQuantity = stockQuantity - ?
WHERE id = ?;

-- Étape 3 : Mettre à jour takenDosesToday dans person_medications
UPDATE person_medications
SET
  takenDosesToday = ?,  -- Ajouter heure prise
  takenDosesDate = ?     -- Mettre à jour date
WHERE personId = ? AND medicationId = ?;
```

### 3. Calculer Stock Disponible et Alertes

```sql
-- Obtenir médicaments avec stock bas pour une personne
SELECT
  m.id,
  m.name,
  m.stockQuantity,
  m.lowStockThresholdDays,
  pm.doseSchedule
FROM medications m
INNER JOIN person_medications pm ON m.id = pm.medicationId
WHERE pm.personId = ?
  AND m.stockQuantity > 0
  AND m.stockQuantity < (
    -- Calculer stock minimum basé sur dose quotidienne
    -- (Cette logique se fait dans l'application car doseSchedule est JSON)
  );
```

### 4. Obtenir Historique de Doses (Derniers 30 Jours)

```sql
SELECT
  id,
  medicationId,
  medicationName,
  medicationType,
  personId,
  scheduledDateTime,
  registeredDateTime,
  status,
  quantity,
  isExtraDose,
  notes
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= date('now', '-30 days')
ORDER BY scheduledDateTime DESC;
```

### 5. Calculer Adhérence (% de Doses Prises)

```sql
-- Total de doses programmées
SELECT COUNT(*) as total
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?;

-- Doses prises
SELECT COUNT(*) as taken
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?
  AND status = 'taken';

-- Adhérence = (taken / total) * 100
```

### 6. Obtenir Personnes Assignées à un Médicament

```sql
SELECT p.id, p.name, p.isDefault
FROM persons p
INNER JOIN person_medications pm ON p.id = pm.personId
WHERE pm.medicationId = ?
ORDER BY p.name ASC;
```

### 7. Vérifier si un Médicament Existe Déjà (par nom)

```sql
SELECT id, name, type, stockQuantity
FROM medications
WHERE LOWER(name) = LOWER(?)
LIMIT 1;
```

---

## Optimisations

### 1. Transactions Batch

Pour les opérations qui modifient plusieurs tables, des transactions sont utilisées :

```dart
await db.transaction((txn) async {
  // Plusieurs opérations atomiques
  await txn.insert('dose_history', entry.toMap());
  await txn.update('medications', {'stockQuantity': newStock}, where: 'id = ?', whereArgs: [medicationId]);
  await txn.update('person_medications', {'takenDosesToday': taken}, where: 'personId = ? AND medicationId = ?', whereArgs: [personId, medicationId]);
});
```

**Avantages** :
- Atomicité : Tout est sauvegardé ou rien ne l'est
- Cohérence : Pas d'états intermédiaires
- Performance : Une seule écriture sur disque

### 2. Prepared Statements

Toutes les requêtes utilisent des prepared statements avec placeholders (`?`) pour prévenir l'injection SQL et améliorer la performance :

```dart
// ✅ Correct (prepared statement)
await db.query('medications', where: 'id = ?', whereArgs: [id]);

// ❌ Incorrect (vulnérable à l'injection SQL)
await db.rawQuery("SELECT * FROM medications WHERE id = '$id'");
```

### 3. Index Sélectifs

Les index sont conçus pour les requêtes les plus fréquentes :
- `idx_person_medications_person` : Pour l'écran principal (afficher médicaments de l'utilisateur)
- `idx_dose_history_medication` : Pour l'historique d'un médicament spécifique
- `idx_dose_history_date` : Pour les requêtes par plage de dates

### 4. Dénormalisation Stratégique

Dans `dose_history`, `medicationName` et `medicationType` sont stockés (dénormalisés) pour éviter des JOINs coûteux dans les requêtes d'historique. Cela sacrifie un peu d'espace pour beaucoup de performance.

### 5. Cache en Mémoire

L'application utilise un cache pour la personne par défaut :

```dart
Person? _cachedDefaultPerson;

Future<Person?> getDefaultPerson() async {
  if (_cachedDefaultPerson != null) return _cachedDefaultPerson;
  // Consulter base de données seulement si pas en cache
}
```

### 6. ANALYZE et VACUUM

**ANALYZE** : Met à jour les statistiques de la base de données pour optimiser le query planner.

```sql
ANALYZE;
```

**VACUUM** : Reconstruit la base de données pour libérer de l'espace et optimiser.

```sql
VACUUM;
```

**Recommandation** : Exécuter `ANALYZE` après changements massifs de données, et `VACUUM` périodiquement (ex : tous les 3 mois).

---

## Backup et Restauration

### Emplacement du Fichier de Base de Données

La base de données est stockée dans :

```
Android : /data/data/com.example.medicapp/databases/medications.db
iOS : /Documents/databases/medications.db
```

Pour obtenir le chemin réel :

```dart
final dbPath = await DatabaseHelper.instance.getDatabasePath();
print('Database location: $dbPath');
```

### Stratégies de Backup

#### 1. Backup Manuel (Exportation de Fichier)

```dart
final backupPath = await DatabaseHelper.instance.exportDatabase();
// backupPath = /tmp/medicapp_backup_2025-11-14T10-30-00.db
```

L'application copie le fichier `.db` vers un emplacement temporaire. L'utilisateur peut ensuite partager ce fichier (Google Drive, email, etc.).

#### 2. Importation de Backup

```dart
await DatabaseHelper.instance.importDatabase('/path/to/backup.db');
```

**Notes** :
- Un backup automatique du fichier actuel est créé avant l'importation (`.backup`)
- Si l'importation échoue, le backup est automatiquement restauré

#### 3. Backup Automatique (Recommandé pour Production)

Implémenter un système de backup automatique vers le cloud :

```dart
// Pseudocode
void scheduleAutomaticBackup() {
  Timer.periodic(Duration(days: 7), (timer) async {
    final backupPath = await DatabaseHelper.instance.exportDatabase();
    await uploadToCloud(backupPath); // Google Drive, Dropbox, etc.
  });
}
```

### Exportation de Données (JSON)

Pour une portabilité maximale, la base de données complète peut être exportée en JSON :

```dart
Future<Map<String, dynamic>> exportToJson() async {
  final db = await DatabaseHelper.instance.database;

  return {
    'version': 19,
    'exportDate': DateTime.now().toIso8601String(),
    'persons': await db.query('persons'),
    'medications': await db.query('medications'),
    'person_medications': await db.query('person_medications'),
    'dose_history': await db.query('dose_history'),
  };
}
```

**Avantages** :
- Format lisible par humains
- Facile à inspecter et déboguer
- Indépendant de SQLite

**Inconvénients** :
- Fichier plus grand que `.db`
- Nécessite parsing lors de l'importation

---

## Exemple d'Usage Complet

### Scénario : Ana et Carlos partagent de l'Ibuprofène

```sql
-- 1. Créer personnes
INSERT INTO persons (id, name, isDefault) VALUES ('person_1', 'Ana', 1);
INSERT INTO persons (id, name, isDefault) VALUES ('person_2', 'Carlos', 0);

-- 2. Créer médicament partagé (Ibuprofène)
INSERT INTO medications (id, name, type, stockQuantity, lowStockThresholdDays)
VALUES ('med_1', 'Ibuprofène 600mg', 'pill', 40.0, 3);

-- 3. Assigner à Ana avec sa posologie (08:00 et 20:00)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_1', 'person_1', 'med_1', '2025-11-14T00:00:00', 'everyday', 12,
  '{"08:00": 1.0, "20:00": 1.0}', '', ''
);

-- 4. Assigner à Carlos avec sa posologie (14:00 seulement)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_2', 'person_2', 'med_1', '2025-11-14T00:00:00', 'everyday', 0,
  '{"14:00": 1.0}', '', ''
);

-- 5. Ana prend une dose à 08:05
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose
) VALUES (
  'dose_1', 'med_1', 'Ibuprofène 600mg', 'pill', 'person_1',
  '2025-11-14T08:00:00', '2025-11-14T08:05:00', 'taken', 1.0, 0
);

-- 6. Mettre à jour stock (reste 39.0)
UPDATE medications SET stockQuantity = 39.0 WHERE id = 'med_1';

-- 7. Mettre à jour takenDosesToday d'Ana
UPDATE person_medications
SET takenDosesToday = '08:00', takenDosesDate = '2025-11-14'
WHERE id = 'pm_1';

-- 8. Consulter stock restant (visible pour les deux)
SELECT stockQuantity FROM medications WHERE id = 'med_1';
-- Résultat : 39.0

-- 9. Consulter adhérence d'Ana
SELECT
  COUNT(*) FILTER (WHERE status = 'taken') as taken,
  COUNT(*) as total
FROM dose_history
WHERE personId = 'person_1' AND medicationId = 'med_1';
```

---

## Résumé

- **Version** : V19 (SQLite)
- **Tables Principales** : `persons`, `medications`, `person_medications`, `dose_history`
- **Architecture** : Multi-personne avec données partagées (stock) et configurations individuelles (posologies)
- **Migrations** : Système automatique progressif V1→V19
- **Intégrité** : Clés étrangères avec cascades, index optimisés
- **Optimisations** : Transactions batch, prepared statements, cache en mémoire, dénormalisation stratégique
- **Backup** : Exportation de fichier `.db` et JSON, importation avec rollback automatique

Cette base de données est conçue pour supporter des applications de gestion de médicaments multi-utilisateurs avec haute performance et garanties d'intégrité des données.
