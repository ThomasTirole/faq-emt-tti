# Pakompri - Plateforme de Questions-Réponses pour Étudiants

![Nuxt 3](https://img.shields.io/badge/Nuxt-3-00DC82?style=flat&logo=nuxt.js&logoColor=white)
![Vue 3](https://img.shields.io/badge/Vue-3-4FC08D?style=flat&logo=vue.js&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat&logo=typescript&logoColor=white)

Pakompri est une plateforme moderne de questions-réponses conçue pour les étudiants du module HTML-CSS de l'EMT. Elle permet aux étudiants de poser des questions, partager leurs connaissances et collaborer efficacement.

## 🌟 Fonctionnalités

### Gestion des Questions
- ✅ **Poser des questions** avec titre, description Markdown et tags
- ✅ **Recherche et filtres** par statut (répondu/non répondu) et tags
- ✅ **Pagination** (20 questions par page)
- ✅ **Marquer comme répondu/non répondu** (auteur uniquement)
- ✅ **Supprimer ses questions** avec confirmation
- ✅ **Limite de 5 tags** par question
- ✅ **Compteur de commentaires** sur chaque carte de question

### Système de Commentaires
- 💬 **Ajouter des commentaires** sur les questions
- 💬 **Supprimer ses commentaires** avec dialogue de confirmation
- 💬 **Affichage des avatars** des utilisateurs
- 💬 **Permissions administrateur** : les super admins peuvent supprimer tous les commentaires

### Profil Utilisateur
- 👤 **Modifier son nom d'utilisateur**
- 👤 **Upload de photo de profil** (max 2MB, validation du type)
- 👤 **Avatars affichés** partout (questions, commentaires)
- 👤 **Page "Mes questions"** pour voir ses propres questions

### Interface Utilisateur
- 🎨 **Mode clair/sombre** avec sélecteur dans l'en-tête
- 🎨 **Design moderne** avec Nuxt UI
- 🎨 **Interface entièrement en français**
- 🎨 **Notifications toast** pour les actions (succès/erreur)
- 🎨 **Dialogues de confirmation** pour les actions destructives
- 🎨 **Icônes visuelles** (calendrier, tags, commentaires)
- 🎨 **Séparateurs** pour une meilleure organisation visuelle
- 🎨 **Responsive** et adapté à tous les écrans

### Authentification
- 🔐 **Inscription** avec email et mot de passe
- 🔐 **Connexion** sécurisée via Supabase Auth
- 🔐 **Déconnexion**
- 🔐 **Row Level Security (RLS)** sur toutes les tables

## 🚀 Technologies Utilisées

- **[Nuxt 3](https://nuxt.com/)** - Framework Vue.js full-stack
- **[Vue 3](https://vuejs.org/)** - Framework JavaScript progressif
- **[Nuxt UI](https://ui.nuxt.com/)** - Bibliothèque de composants UI
- **[Supabase](https://supabase.com/)** - Backend as a Service (BaaS)
  - PostgreSQL Database
  - Authentication
  - Storage (avatars)
  - Row Level Security
- **[TypeScript](https://www.typescriptlang.org/)** - Typage statique
- **[Pinia](https://pinia.vuejs.org/)** - State management
- **[MDC](https://github.com/nuxt-modules/mdc)** - Markdown Component pour les descriptions

## 📋 Prérequis

- **Node.js** 18.x ou supérieur
- **npm** ou **yarn** ou **pnpm**
- **Compte Supabase** (gratuit)

## 🛠️ Installation

### 1. Cloner le projet

```bash
git clone <url-du-repo>
cd faq-emt-tti
```

### 2. Installer les dépendances

```bash
npm install
# ou
yarn install
# ou
pnpm install
```

### 3. Configuration Supabase

#### 3.1 Créer un projet Supabase

1. Allez sur [supabase.com](https://supabase.com)
2. Créez un nouveau projet
3. Notez votre **URL du projet** et votre **clé API anonyme**

#### 3.2 Configurer les variables d'environnement

Créez un fichier `.env` à la racine du projet :

```env
SUPABASE_URL=votre_url_supabase
SUPABASE_KEY=votre_cle_api_supabase
```

#### 3.3 Exécuter le script SQL de création de la base de données

Dans l'éditeur SQL de Supabase :

1. Copiez le contenu de **`supabase_complete_schema.sql`**
2. Collez-le dans l'éditeur SQL
3. Exécutez le script

Ce script crée toutes les tables (profiles, questions, comments), les index, les politiques RLS, les fonctions/triggers et les politiques de stockage.

> 📚 Pour plus de détails sur la structure de la base de données, consultez [SQL_DOCUMENTATION.md](./SQL_DOCUMENTATION.md)

#### 3.4 Créer le bucket de stockage

1. Dans Supabase Dashboard → **Storage**
2. Créez un nouveau bucket **public** nommé `avatars`
3. Les politiques RLS seront appliquées par le script SQL

### 4. Lancer l'application

```bash
npm run dev
```

L'application sera accessible sur [http://localhost:3000](http://localhost:3000)

## 📁 Structure du Projet

```
faq-emt-tti/
├── app/                          # Code source de l'application
│   ├── assets/                   # Images et ressources
│   │   ├── nerd_cat.png         # Logo de l'application
│   │   └── favicon.ico          # (optionnel)
│   ├── components/              # Composants Vue réutilisables
│   │   ├── CommentSection.vue   # Section de commentaires
│   │   ├── ConfirmDialog.vue    # Dialogue de confirmation
│   │   ├── QuestionCard.vue     # Carte de question compacte
│   │   ├── QuestionFilters.vue  # Filtres de recherche
│   │   └── QuestionPagination.vue # Pagination
│   ├── layouts/                 # Layouts de l'application
│   │   └── default.vue          # Layout principal avec navbar
│   ├── pages/                   # Pages de l'application (routing auto)
│   │   ├── index.vue            # Page d'accueil (liste des questions)
│   │   ├── login.vue            # Page de connexion
│   │   ├── register.vue         # Page d'inscription
│   │   ├── profile.vue          # Page de profil utilisateur
│   │   ├── my-questions.vue     # Mes questions
│   │   └── questions/
│   │       ├── new.vue          # Créer une question
│   │       └── [id].vue         # Détails d'une question
│   └── app.vue                  # Composant racine
├── public/                      # Fichiers statiques
│   ├── favicon.ico              # Favicon
│   └── nerd_cat.png            # Logo (copie)
├── supabase_*.sql              # Scripts SQL pour la base de données
├── nuxt.config.ts              # Configuration Nuxt
├── package.json                # Dépendances du projet
└── README.md                   # Ce fichier
```

## 🎯 Guide d'Utilisation

### Pour les Étudiants

#### Poser une Question

1. **Connectez-vous** ou **inscrivez-vous**
2. Cliquez sur **"Poser une question"** dans l'en-tête
3. Remplissez le formulaire :
   - **Titre** : Question concise
   - **Description** : Détails en Markdown
   - **Tags** : Jusqu'à 5 tags (séparés par des virgules)
4. Cliquez sur **"Poser la question"**

#### Répondre via Commentaires

1. Ouvrez une question
2. Tapez votre réponse dans le champ de commentaire
3. Cliquez sur **"Publier"**

#### Marquer une Question comme Répondue

1. Ouvrez **votre question**
2. Cliquez sur **"Marquer comme répondu"**
3. Un badge vert apparaîtra sur la question

#### Modifier son Profil

1. Cliquez sur **"Profil"** dans l'en-tête
2. Modifiez votre **nom d'utilisateur**
3. Uploadez une **photo de profil** (optionnel, max 2MB)
4. Cliquez sur **"Enregistrer"**

### Pour les Administrateurs

#### Activer les Permissions Admin

1. Dans Supabase Dashboard → **Table Editor** → **profiles**
2. Trouvez l'utilisateur à promouvoir
3. Cochez la case `is_admin`

#### Supprimer des Commentaires

Les administrateurs voient un bouton **"Supprimer"** sur **tous** les commentaires, pas seulement les leurs.

## 🔒 Sécurité

### Row Level Security (RLS)

Toutes les tables utilisent RLS pour garantir que :
- Les utilisateurs ne peuvent modifier que leurs propres données
- Les questions et commentaires sont visibles par tous
- Les avatars sont stockés dans des dossiers utilisateur séparés
- Les administrateurs ont des permissions étendues

### Validation

- **Taille des fichiers** : Max 2MB pour les avatars
- **Types de fichiers** : Seulement les images pour les avatars
- **Limite de tags** : Maximum 5 tags par question
- **Authentification** : Requise pour toutes les actions de création/modification

## 🎨 Personnalisation

### Changer le Thème

L'application supporte automatiquement les modes clair et sombre. Utilisez le bouton soleil/lune dans l'en-tête.

### Modifier les Couleurs

Les couleurs sont gérées par Nuxt UI. Pour les personnaliser, modifiez `nuxt.config.ts` :

```typescript
export default defineNuxtConfig({
  ui: {
    primary: 'blue', // Changez la couleur primaire
    gray: 'slate'     // Changez la couleur grise
  }
})
```

## 🐛 Dépannage

### Le favicon ne s'affiche pas

1. Videz le cache du navigateur (Ctrl+Shift+Delete)
2. Rechargez avec Ctrl+F5
3. Redémarrez le serveur de développement

### Les images ne se chargent pas

- Vérifiez que le bucket `avatars` existe dans Supabase Storage
- Vérifiez que les politiques RLS sont appliquées
- Vérifiez que le bucket est **public**

### Erreurs de base de données

- Assurez-vous que tous les scripts SQL ont été exécutés dans l'ordre
- Vérifiez les logs dans Supabase Dashboard → **Database** → **Logs**

## 📝 Scripts Disponibles

```bash
# Développement
npm run dev

# Build pour production
npm run build

# Prévisualiser le build de production
npm run preview

# Générer un site statique
npm run generate

# Linter
npm run lint
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Forkez le projet
2. Créez une branche (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Poussez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Auteur

- Thomas TIROLE - [GitHub](https://github.com/ThomasTirole)
- pour l'**EMT** - École des Métiers Techniques - Section informatique

> Projet réalisé dans un cadre de test de Antigravity avec Gemini Pro 3 et Claude Sonnet 4.5

## 🙏 Remerciements

- [Nuxt](https://nuxt.com/) pour le framework incroyable
- [Supabase](https://supabase.com/) pour le backend simple et puissant
- [Nuxt UI](https://ui.nuxt.com/) pour les composants magnifiques
- Tous les étudiants qui utilisent cette plateforme !

---

**Fait avec ❤️ pour les étudiants de l'EMT**
