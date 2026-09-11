# StudyPair

Application multiplateforme de **mentorat académique et professionnel** et de **mise en relation d’étudiants**.

---

## 📌 Nom et description du projet

| | |
|---|---|
| **Nom** | StudyPair |
| **Description** | Plateforme intelligente de mentorat et de mise en relation mettant en contact des étudiants et des mentors qualifiés. L'application intègre un algorithme de matching IA, une messagerie instantanée à double opt-in et un système de suivi monétisé. |

### Objectif
Faciliter le travail collaboratif et l'accompagnement académique en réduisant le temps passé à chercher un partenaire de révision ou un mentor compatible, tout en garantissant un cadre d'échange sécurisé et modéré.

### Stack technique
- **Frontend** : Flutter (GetX — gestion d'état, routes, services, injection de dépendances)
- **Backend & Serverless** : Firebase
  - Authentication (Email/Mot de passe + Google Sign-In + Règle de vérification d'email obligatoire)
  - Cloud Firestore (Base NoSQL temps réel pour les utilisateurs, profils, correspondances et messages)
  - Firebase Cloud Messaging (FCM — Notifications push automatisées)
- **Automatisation & IA** : 
  - n8n (Workflows de bienvenue et d'approbation/rejet admin)
  - API IA externe (Scoring de compatibilité, modération synchrone des messages et vérification des photos/bios)
- **Paiements** : Stripe Connect (Gestion du KYC, encaissement des tarifs horaires et virements mensuels)
- **Plateformes cibles** : Android / iOS (configurations Web et Desktop incluses)

### Fonctionnalités principales
- **Authentification & Choix du Rôle** : Inscription unique par email unique vérifié ou Google OAuth. Définition irréversible du rôle (**Étudiant** ou **Mentor**).
- **Profils Spécifiques & Onboarding** :
  - *Étudiant* : Questionnaire d'orientation en 5 questions (Objectif, Rythme, Style, Dispo, Attentes) et 3 tags d'intérêt minimum.
  - *Mentor* : Dépôt de CV/diplôme, charte de bienveillance, engagement sur un minimum de 3 créneaux par semaine. Profil bloqué en statut `pending` soumis à modération humaine (24-48h).
- **Matching Intelligent par IA (`STUD-11` / `STUD-40`)** : Suggestions quotidiennes limitées à 5 mentors maximum par jour via l'endpoint sécurisé `POST /match-payload` (limité à 100 req/jour). Calcul d'un score de compatibilité (%) basé sur les matières, filières, disponibilités et centres d'intérêt.
- **Relation & Messagerie Sécurisée à Double Opt-in (`STUD-3`)** :
  - *Phase de découverte* : Chat restreint et bloqué au bout de **6 messages cumulés**. Partage de fichiers et de coordonnées personnelles strictement interdit.
  - *Modération des messages (`STUD-15`)* : Analyse synchrone par IA avant écriture dans Firestore. Blocage automatique des contenus toxiques avec alerte admin.
  - *Validation (`STUD-16`)* : L'acceptation du mentor débloque le mode illimité (support des messages vocaux et fichiers PDF/JPG/PNG jusqu'à 10 Mo). Le refus archive la conversation.
- **Monétisation & Rétribution (`STUD-26`)** : Rémunération des mentors via Stripe Connect (commission plateforme de 15% prélevée sur chaque transaction) et virements mensuels automatisés par tâche Cron.
- **Dashboard Post-Auth & Suivi** : Hub centralisé (Accueil, Matchs/Binômes, Chats, Paramètres/Profil). Statistiques mentors (revenus, heures cumulées, note moyenne). Système de notation post-session en double aveugle.
- **Sécurité Communautaire (`STUD-17`)** : Option de signalement d'utilisateur disponible depuis le chat. Une accumulation de 3 signalements entraîne la suspension automatique du compte.

---

## 🎯 Périmètre du MVP (Minimum Viable Product)

Pour la première version livrable de l'application (fin du Sprint 1), le **MVP** se concentre exclusivement sur la mise en relation et la validation du concept. Les fonctionnalités complexes de monétisation et de notation sont repoussées à la version finale.

### Ce qui est INCLUS dans le MVP :
- **Onboarding fonctionnel** : Inscription Google/Email avec validation et choix définitif du rôle.
- **Profils de base** : Renseignement de l'université, du niveau, des matières recherchées ou enseignées.
- **Système de Match Basique** : Possibilité pour un étudiant de voir des profils, d'envoyer une demande de match (limité à 3 demandes actives) et gestion de l'expiration à 7 jours.
- **Messagerie de Découverte** : Le chat s'ouvre lors d'un match mutuel et se bloque **strictement à 6 messages** pour forcer la validation ou le refus de la relation par le mentor.
- **Modération Admin** : Validation manuelle/n8n des profils mentors (statut `pending` vers actif).

### Ce qui est EXCLU du MVP (Prévu pour la V1 globale / Sprint 2) :
- **Scoring IA Avancé** : Remplacé temporairement dans le MVP par un filtrage classique par matières et disponibilités.
- **Monétisation & Stripe Connect** : Pas de gestion des paiements ni des commissions dans le MVP.
- **Planification & Rappels automatiques** : L'organisation des rendez-vous se fait à l'amiable dans le chat débloqué.
- **Système de Notation & Badges Certifiés** : Pas de notes ni d'attribution automatique de badges à ce stade.

---

## 📅 Planning

| | |
|---|---|
| **Date de début** | 8 septembre 2026 |
| **Date de fin prévue** | 15 septembre 2026 |

---

## 👥 Équipe

### 👨‍💼 Chef d’équipe & Project Manager
- **Kluc Dalland** (`klucdalland-web`) — Architecture globale de l'application, infrastructure Firebase, authentification, workflows.

### 👥 Membres & Contributeurs

| Nom | Rôle |
|-----|------|
| Kluc Dalland | Développeur principal Cross-Platform & Cloud Backend |
| Robert Phillipe N. I. Ikama | Product Owner / Contributer externes |

### 🎓 Mentor
- * David BONGOUADE *

---

## 🗂️ Structure du projet


## 🗂️ Structure du projet (aperçu)

```
lib/
  pages/
    pre_auth/     # Splash (avant auth)
    auth/         # Login / Register
    dashboard/    # Shell + bottom nav + home, match, chats, profile, chat
  services/       # Auth, User, Match, Chat (Firebase)
  models/         # User, Match, Chat, Message
  routes/         # GetX routes + middlewares
  bindings/       # Injection GetX
  widgets/        # Widgets globaux
  utils/          # Validators, snackbars, spacing
```

---

## 🚀 Lancer le projet

### Prérequis
- Flutter SDK (stable)
- Compte Firebase projet `studypair-c081b`
- Android Studio / Xcode selon la plateforme

### Installation

```bash
git clone git@github.com:klucdalland-web/StudyPair.git
cd StudyPair
flutter pub get
flutter run
```

### Vérifier Firebase
Au démarrage, la console doit afficher notamment :
- `🔥 Firebase OK`
- puis, après login/register : `✅ Login OK` / `📄 Firestore: profil…`

---

## 🔐 Firebase (rappel)

| Service | Usage |
|---------|--------|
| Authentication | Email/password + Google |
| Cloud Firestore | `users`, `matches`, `chats`, `messages` |
| Projet | `studypair-c081b` |

---

## 📝 Suivi / livrables (suggestion)

- [ ] Auth email + Google opérationnels
- [ ] Profil + recherche de binômes
- [ ] Acceptation de match + création de chat
- [ ] Rules Firestore sécurisées
- [ ] Démo / soutenance

---

## 📄 Licence

Projet académique — usage éducatif.
