-- ============================================
-- Script de réinitialisation des données
-- ============================================
-- Ce script vide les tables de questions et commentaires
-- tout en préservant les profils utilisateurs existants
--
-- ATTENTION : Cette action est IRRÉVERSIBLE !
-- Assurez-vous de faire une sauvegarde avant d'exécuter ce script
--
-- Utilisation :
-- 1. Allez dans Supabase Dashboard → SQL Editor
-- 2. Collez ce script
-- 3. Exécutez-le
-- ============================================

-- Désactiver temporairement les triggers et contraintes pour accélérer la suppression
SET session_replication_role = 'replica';

-- Supprimer tous les commentaires
-- (les commentaires doivent être supprimés avant les questions à cause de la contrainte de clé étrangère)
DELETE FROM comments;

-- Supprimer toutes les questions
DELETE FROM questions;

-- Réactiver les triggers et contraintes
SET session_replication_role = 'origin';

-- Afficher un résumé de ce qui reste
SELECT 
  'profiles' as table_name, 
  COUNT(*) as remaining_rows 
FROM profiles
UNION ALL
SELECT 
  'questions' as table_name, 
  COUNT(*) as remaining_rows 
FROM questions
UNION ALL
SELECT 
  'comments' as table_name, 
  COUNT(*) as remaining_rows 
FROM comments;

-- Message de confirmation
DO $$
BEGIN
  RAISE NOTICE '✅ Réinitialisation terminée !';
  RAISE NOTICE '📊 Les profils utilisateurs ont été préservés';
  RAISE NOTICE '🗑️  Toutes les questions et commentaires ont été supprimés';
  RAISE NOTICE '🚀 La plateforme est prête pour vos élèves !';
END $$;
