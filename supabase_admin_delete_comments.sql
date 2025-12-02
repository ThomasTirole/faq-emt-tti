-- Drop existing delete policy for comments
DROP POLICY IF EXISTS "Users can delete own comments." ON comments;

-- Recreate delete policy allowing users to delete their own comments OR admins to delete any comment
CREATE POLICY "Users can delete own comments or admins can delete any." ON comments
  FOR DELETE USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() AND is_admin = true
    )
  );
