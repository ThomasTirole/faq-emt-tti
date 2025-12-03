-- ============================================
-- Script de nettoyage du stockage (OPTIONNEL)
-- ============================================
-- Ce script supprime tous les avatars du bucket 'avatars'
-- sauf ceux des utilisateurs que vous souhaitez conserver
--
-- ATTENTION : Adaptez ce script selon vos besoins !
-- Par défaut, il liste les fichiers sans les supprimer
-- ============================================

-- Lister tous les fichiers dans le bucket avatars
SELECT 
  name,
  id,
  created_at,
  metadata->>'size' as size_bytes
FROM storage.objects
WHERE bucket_id = 'avatars'
ORDER BY created_at DESC;

-- ============================================
-- OPTION 1 : Supprimer TOUS les avatars
-- ============================================
-- Décommentez les lignes ci-dessous pour supprimer tous les avatars
-- (Attention : cela supprimera aussi VOS avatars !)

-- DELETE FROM storage.objects
-- WHERE bucket_id = 'avatars';

-- ============================================
-- OPTION 2 : Supprimer les avatars SAUF certains utilisateurs
-- ============================================
-- Remplacez 'user-id-1', 'user-id-2' par les IDs des utilisateurs à conserver
-- Pour trouver votre user ID, allez dans : Authentication → Users

-- DELETE FROM storage.objects
-- WHERE bucket_id = 'avatars'
-- AND name NOT LIKE 'user-id-1/%'
-- AND name NOT LIKE 'user-id-2/%';

-- ============================================
-- OPTION 3 : Ne rien supprimer (recommandé)
-- ============================================
-- Si vous voulez garder tous les avatars, ne faites rien !
-- Les nouveaux élèves pourront uploader leurs propres avatars

-- Message d'information
DO $$
BEGIN
  RAISE NOTICE '📁 Script de nettoyage du stockage';
  RAISE NOTICE 'ℹ️  Par défaut, aucun fichier n''est supprimé';
  RAISE NOTICE '⚠️  Décommentez les sections appropriées si vous voulez supprimer des avatars';
END $$;
