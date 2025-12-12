# 📋 Guide Rapide - Scripts SQL

## 🎯 NOUVEAU DÉPLOIEMENT

**Utilisez uniquement ce fichier :**

```
✅ supabase_complete_schema.sql  → Script complet (RECOMMANDÉ)
```

**Instructions :**
1. Éditeur SQL Supabase → Copier/coller → Exécuter
2. Storage → Créer bucket public "avatars"
3. Terminé ! 🎉

---

## 🔄 BASE DE DONNÉES EXISTANTE

**Fichiers de migration (dans l'ordre) :**

```
1️⃣ supabase_schema.sql                   → Base initiale (INCOMPLET)
2️⃣ supabase_migration_answered.sql       → Ajoute is_answered
3️⃣ supabase_add_tracking_columns.sql     → Ajoute updated_at, last_editor_id
4️⃣ supabase_fix_rls.sql                  → Corrige les politiques RLS
5️⃣ supabase_storage_policies.sql         → Politiques avatars
6️⃣ supabase_admin_delete_comments.sql    → Permissions admin
```

⚠️ **ATTENTION :** Ces fichiers ont des problèmes :
- Table `comments` jamais créée
- Colonne `is_admin` jamais créée

➡️ **Utilisez plutôt `supabase_complete_schema.sql`**

---

## 🛠️ MAINTENANCE

**Nettoyage des données :**

```
🗑️ supabase_reset_data.sql       → Vide questions & commentaires
🗑️ supabase_reset_storage.sql    → Nettoie les avatars (optionnel)
```

---

## 📚 DOCUMENTATION

```
📖 SQL_DOCUMENTATION.md          → Documentation complète
📖 README.md                     → Guide d'utilisation général
```

---

## ❓ FAQ

**Q: Quel fichier utiliser pour une nouvelle installation ?**  
R: `supabase_complete_schema.sql` uniquement.

**Q: J'ai déjà une base de données en production, que faire ?**  
R: Sauvegarde → Suppression tables → `supabase_complete_schema.sql` → Restauration données

**Q: Où est créée la colonne is_admin ?**  
R: Dans `supabase_complete_schema.sql` ligne 29

**Q: Où est créée la table comments ?**  
R: Dans `supabase_complete_schema.sql` ligne 49-58

**Q: Les anciens fichiers SQL sont-ils obsolètes ?**  
R: Ils sont conservés pour référence historique, mais utilisez le fichier complet.

---

**Mis à jour le :** 2025-12-12  
**Auteur :** Thomas TIROLE
