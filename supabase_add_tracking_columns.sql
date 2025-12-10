-- Add tracking columns to questions table
ALTER TABLE questions 
ADD COLUMN IF NOT EXISTS updated_at timestamptz DEFAULT now(),
ADD COLUMN IF NOT EXISTS last_editor_id uuid REFERENCES profiles(id);

-- Add tracking columns to comments table
ALTER TABLE comments 
ADD COLUMN IF NOT EXISTS updated_at timestamptz DEFAULT now(),
ADD COLUMN IF NOT EXISTS last_editor_id uuid REFERENCES profiles(id);

-- Enable RLS on comments if not already enabled (it should be)
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- Drop existing policies for comments to avoid conflicts (if any)
DROP POLICY IF EXISTS "Users can update own comments." ON comments;
DROP POLICY IF EXISTS "Admins can update any comment." ON comments;

-- Create Update policy for Comments: Owner
CREATE POLICY "Users can update own comments." ON comments
  FOR UPDATE USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create Update policy for Comments: Admin
CREATE POLICY "Admins can update any comment." ON comments
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() AND is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() AND is_admin = true
    )
  );
