-- Add is_answered column to questions table
ALTER TABLE questions ADD COLUMN is_answered boolean DEFAULT false;

-- Add policy for question owner to update answered status
CREATE POLICY "Question owner can update question." ON questions
  FOR UPDATE USING (auth.uid() = user_id);

-- Add policy for admins to update any question
CREATE POLICY "Admins can update any question." ON questions
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() AND is_admin = true
    )
  );
