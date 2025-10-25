# 📘 Schéma de base de données — Supabase (Version du 25/10/2025)

Ce document décrit la structure complète de la base de données **Supabase** utilisée pour la gestion des utilisateurs, destinations, trajets et évaluations.

---

## 🧩 1. Table `roles`
Contient les différents rôles attribuables aux utilisateurs.

| Colonne | Type | Description |
|----------|------|-------------|
| `id` | `uuid` | Identifiant unique du rôle. |
| `name` | `text` | Nom du rôle (`ADMIN`, `VISITOR`, `CLIENT`). |
| `created_at` | `timestamptz` | Date de création du rôle. |

### 💡 Notes
- Cette table permet de gérer les permissions et les droits d’accès selon le type d’utilisateur.

---

## 👤 2. Table `profiles`
Représente les informations personnelles et le rôle de chaque utilisateur.

| Colonne | Type | Description |
|----------|------|-------------|
| `id` | `uuid` | Identifiant unique (lié à `auth.users`). |
| `role_id` | `uuid` | Référence à `roles.id`. |
| `first_name` | `text` | Prénom de l’utilisateur. |
| `last_name` | `text` | Nom de famille. |
| `email` | `text` | Adresse e-mail. |
| `mobile` | `text` | Numéro de téléphone. |
| `address` | `text` | Adresse de l’utilisateur (sert de point de départ des trajets). |
| `created_at` | `timestamptz` | Date de création du profil. |

### 💡 Notes
- Chaque utilisateur correspond à un enregistrement dans `auth.users`.
- L’adresse du profil est utilisée comme **point de départ** pour les trajets (`rides`).

---

## 📍 3. Table `destinations`
Liste des lieux disponibles (publics, privés, ou commerciaux).

| Colonne | Type | Description |
|----------|------|-------------|
| `id` | `uuid` | Identifiant unique de la destination. |
| `name` | `text` | Nom du lieu. |
| `type` | `text` | Type (`BUSINESS` ou `PRIVATE`). |
| `description` | `text` | Description courte du lieu. |
| `address` | `text` | Adresse complète. |
| `latitude` | `double precision` | Latitude pour affichage sur carte. |
| `longitude` | `double precision` | Longitude pour affichage sur carte. |
| `status` | `text` | État du lieu (`OPEN`, `CLOSED`, `PAUSED`). |
| `locker_count` | `integer` | Nombre de casiers disponibles. |
| `image_url` | `text` | URL d’une image représentative du lieu. |
| `created_at` | `timestamptz` | Date d’ajout du lieu. |

### 💡 Notes
- Cette table alimente la **carte Google Maps**.
- Peut être liée à des horaires (`opening_hours`), des trajets (`rides`) ou des évaluations (`ratings`).

---

## 🕒 4. Table `opening_hours`
Gère les horaires d’ouverture des destinations.

| Colonne | Type | Description |
|----------|------|-------------|
| `id` | `uuid` | Identifiant unique. |
| `destination_id` | `uuid` | Référence à `destinations.id`. |
| `weekday` | `text` | Jour concerné (`MONDAY` → `SUNDAY`). |
| `open_time` | `time` | Heure d’ouverture. |
| `close_time` | `time` | Heure de fermeture. |
| `is_closed` | `boolean` | Indique si le lieu est fermé ce jour-là. |
| `created_at` | `timestamptz` | Date de création. |

### 💡 Notes
- Permet d’afficher dynamiquement les horaires sur l’application.
- Supprimé automatiquement si la destination correspondante est supprimée.

---

## 🚗 5. Table `rides`
Contient les trajets effectués ou planifiés par les utilisateurs.

| Colonne | Type | Description |
|----------|------|-------------|
| `id` | `uuid` | Identifiant unique du trajet. |
| `user_id` | `uuid` | Référence à `profiles.id` (l’utilisateur/passager). |
| `destination_id` | `uuid` | Référence à `destinations.id` (le lieu d’arrivée). |
| `status` | `text` | Statut du trajet (`PENDING`, `CONFIRMED`, `CANCELLED`, `COMPLETED`). |
| `created_at` | `timestamptz` | Date et heure de création du trajet. |

### 💡 Notes
- Le **point de départ** est issu de `profiles.address`.  
- Le **point d’arrivée** correspond à `destinations.address`.  
- Supprimé automatiquement si le profil ou la destination correspondante est supprimée.

---

## ⭐ 6. Table `ratings`
Stocke les notes et commentaires des utilisateurs sur les destinations.

| Colonne | Type | Description |
|----------|------|-------------|
| `id` | `uuid` | Identifiant unique. |
| `user_id` | `uuid` | Référence à `profiles.id`. |
| `destination_id` | `uuid` | Référence à `destinations.id`. |
| `rating` | `integer` | Note de 1 à 5. |
| `comment` | `text` | Commentaire libre. |
| `created_at` | `timestamptz` | Date de publication de la note. |

### 💡 Notes
- La contrainte `unique (user_id, destination_id)` empêche un utilisateur de noter plusieurs fois la même destination.
- Permet d’afficher la **moyenne des avis** sur chaque lieu.

---

## 🧠 Relations principales

- `profiles.role_id → roles.id` : chaque utilisateur a un rôle.  
- `rides.user_id → profiles.id` : un utilisateur peut effectuer plusieurs trajets.  
- `rides.destination_id → destinations.id` : chaque trajet mène vers une destination.  
- `ratings.user_id → profiles.id` et `ratings.destination_id → destinations.id` : un utilisateur peut noter une destination.  
- `opening_hours.destination_id → destinations.id` : chaque destination a ses horaires.

---

## 🗺️ Vue d’ensemble

```
roles ───< profiles ───< rides >─── destinations ───< opening_hours
                            │
                            └──────< ratings
```
