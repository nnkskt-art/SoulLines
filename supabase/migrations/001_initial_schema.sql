-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create custom types
CREATE TYPE emotion_type AS ENUM (
  'sad', 'happy', 'romantic', 'motivational', 
  'peaceful', 'angry', 'nostalgic', 'neutral'
);

CREATE TYPE user_role AS ENUM ('admin', 'viewer');

-- Users table (extends Supabase auth.users)
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  role user_role DEFAULT 'viewer',
  two_factor_enabled BOOLEAN DEFAULT FALSE,
  two_factor_secret TEXT,
  preferences JSONB DEFAULT '{"theme": "light", "notifications": true}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Poems table
CREATE TABLE public.poems (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  excerpt TEXT,
  cover_image_url TEXT,
  category TEXT NOT NULL,
  tags TEXT[] DEFAULT '{}',
  emotion emotion_type DEFAULT 'neutral',
  is_published BOOLEAN DEFAULT FALSE,
  scheduled_at TIMESTAMP WITH TIME ZONE,
  view_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,
  reading_time_minutes INTEGER,
  hidden_meanings JSONB DEFAULT '[]'::jsonb,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_by UUID REFERENCES public.profiles(id) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  published_at TIMESTAMP WITH TIME ZONE
);

-- Categories table
CREATE TABLE public.categories (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  color TEXT DEFAULT '#6366f1',
  icon TEXT,
  poem_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Likes table
CREATE TABLE public.likes (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  poem_id UUID REFERENCES public.poems(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(poem_id, user_id)
);

-- Comments table
CREATE TABLE public.comments (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  poem_id UUID REFERENCES public.poems(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  is_approved BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Bookmarks table
CREATE TABLE public.bookmarks (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  poem_id UUID REFERENCES public.poems(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(poem_id, user_id)
);

-- Reading history table
CREATE TABLE public.reading_history (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  poem_id UUID REFERENCES public.poems(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  reading_time_seconds INTEGER,
  completed BOOLEAN DEFAULT FALSE,
  emotion_detected emotion_type,
  line_highlights JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Voice analysis table
CREATE TABLE public.voice_analyses (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  poem_id UUID REFERENCES public.poems(id) ON DELETE CASCADE,
  audio_url TEXT,
  detected_emotion emotion_type,
  confidence_score DECIMAL(3,2),
  tone_analysis JSONB,
  recommended_poems UUID[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Poem fusions table (temporary AI-generated fusions)
CREATE TABLE public.poem_fusions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  poem_1_id UUID REFERENCES public.poems(id) ON DELETE CASCADE NOT NULL,
  poem_2_id UUID REFERENCES public.poems(id) ON DELETE CASCADE NOT NULL,
  fusion_content TEXT NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '24 hours')
);

-- Memory capsules table
CREATE TABLE public.memory_capsules (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  poem_id UUID REFERENCES public.poems(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  personal_note TEXT NOT NULL,
  unlock_date TIMESTAMP WITH TIME ZONE NOT NULL,
  is_unlocked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Analytics events table
CREATE TABLE public.analytics_events (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_type TEXT NOT NULL,
  poem_id UUID REFERENCES public.poems(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_poems_published ON public.poems(is_published, published_at DESC);
CREATE INDEX idx_poems_category ON public.poems(category);
CREATE INDEX idx_poems_emotion ON public.poems(emotion);
CREATE INDEX idx_poems_created_by ON public.poems(created_by);
CREATE INDEX idx_likes_poem_id ON public.likes(poem_id);
CREATE INDEX idx_likes_user_id ON public.likes(user_id);
CREATE INDEX idx_comments_poem_id ON public.comments(poem_id);
CREATE INDEX idx_bookmarks_user_id ON public.bookmarks(user_id);
CREATE INDEX idx_reading_history_user_id ON public.reading_history(user_id);
CREATE INDEX idx_reading_history_poem_id ON public.reading_history(poem_id);
CREATE INDEX idx_analytics_events_type ON public.analytics_events(event_type, created_at DESC);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at triggers
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_poems_updated_at BEFORE UPDATE ON public.poems
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON public.comments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS) Policies

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.poems ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reading_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.voice_analyses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.poem_fusions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.memory_capsules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.analytics_events ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Public profiles are viewable by everyone" ON public.profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

-- Poems policies
CREATE POLICY "Published poems are viewable by everyone" ON public.poems
  FOR SELECT USING (is_published = true OR created_by = auth.uid());

CREATE POLICY "Admin can insert poems" ON public.poems
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "Admin can update poems" ON public.poems
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "Admin can delete poems" ON public.poems
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Categories policies
CREATE POLICY "Categories are viewable by everyone" ON public.categories
  FOR SELECT USING (true);

CREATE POLICY "Admin can manage categories" ON public.categories
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Likes policies
CREATE POLICY "Likes are viewable by everyone" ON public.likes
  FOR SELECT USING (true);

CREATE POLICY "Users can like poems" ON public.likes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unlike poems" ON public.likes
  FOR DELETE USING (auth.uid() = user_id);

-- Comments policies
CREATE POLICY "Approved comments are viewable by everyone" ON public.comments
  FOR SELECT USING (is_approved = true OR user_id = auth.uid());

CREATE POLICY "Users can create comments" ON public.comments
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own comments" ON public.comments
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own comments" ON public.comments
  FOR DELETE USING (auth.uid() = user_id);

-- Bookmarks policies
CREATE POLICY "Users can view own bookmarks" ON public.bookmarks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create bookmarks" ON public.bookmarks
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own bookmarks" ON public.bookmarks
  FOR DELETE USING (auth.uid() = user_id);

-- Reading history policies
CREATE POLICY "Users can view own reading history" ON public.reading_history
  FOR SELECT USING (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can create reading history" ON public.reading_history
  FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

-- Voice analyses policies
CREATE POLICY "Users can view own voice analyses" ON public.voice_analyses
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create voice analyses" ON public.voice_analyses
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Poem fusions policies
CREATE POLICY "Users can view own fusions" ON public.poem_fusions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create fusions" ON public.poem_fusions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Memory capsules policies
CREATE POLICY "Users can view own capsules" ON public.memory_capsules
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create capsules" ON public.memory_capsules
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own capsules" ON public.memory_capsules
  FOR UPDATE USING (auth.uid() = user_id);

-- Analytics policies
CREATE POLICY "Admin can view all analytics" ON public.analytics_events
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "Anyone can create analytics events" ON public.analytics_events
  FOR INSERT WITH CHECK (true);

-- Functions for analytics

-- Increment view count
CREATE OR REPLACE FUNCTION increment_poem_views(poem_uuid UUID)
RETURNS void AS $$
BEGIN
  UPDATE public.poems
  SET view_count = view_count + 1
  WHERE id = poem_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Update like count
CREATE OR REPLACE FUNCTION update_poem_like_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.poems SET like_count = like_count + 1 WHERE id = NEW.poem_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.poems SET like_count = like_count - 1 WHERE id = OLD.poem_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_like_count_trigger
AFTER INSERT OR DELETE ON public.likes
FOR EACH ROW EXECUTE FUNCTION update_poem_like_count();

-- Update comment count
CREATE OR REPLACE FUNCTION update_poem_comment_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.poems SET comment_count = comment_count + 1 WHERE id = NEW.poem_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.poems SET comment_count = comment_count - 1 WHERE id = OLD.poem_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_comment_count_trigger
AFTER INSERT OR DELETE ON public.comments
FOR EACH ROW EXECUTE FUNCTION update_poem_comment_count();

-- Clean up expired fusions
CREATE OR REPLACE FUNCTION cleanup_expired_fusions()
RETURNS void AS $$
BEGIN
  DELETE FROM public.poem_fusions WHERE expires_at < NOW();
END;
$$ LANGUAGE plpgsql;
