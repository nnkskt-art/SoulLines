# SoulLines Setup Guide

Complete guide to set up and deploy the SoulLines poetry platform.

## Prerequisites

- Node.js 18+ and npm
- Git
- Supabase account
- Google AI API key
- Vercel account (for deployment)

## Step 1: Clone Repository

```bash
git clone https://github.com/nnkskt-art/soullines-poetry-platform.git
cd soullines-poetry-platform
```

## Step 2: Install Dependencies

```bash
npm install
```

## Step 3: Set Up Supabase

### 3.1 Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Note your project URL and anon key

### 3.2 Run Database Migrations

```bash
# Install Supabase CLI
npm install -g supabase

# Link to your project
supabase link --project-ref your-project-ref

# Run migrations
supabase db push
```

### 3.3 Set Up Storage Buckets

In Supabase Dashboard:
1. Go to Storage
2. Create buckets:
   - `poem-covers` (public)
   - `voice-recordings` (private)
   - `user-avatars` (public)

### 3.4 Configure Storage Policies

```sql
-- Allow public read access to poem covers
CREATE POLICY "Public read access" ON storage.objects
FOR SELECT USING (bucket_id = 'poem-covers');

-- Allow authenticated users to upload
CREATE POLICY "Authenticated upload" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'poem-covers' AND
  auth.role() = 'authenticated'
);
```

## Step 4: Set Up Google AI

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create an API key
3. Enable Gemini API

## Step 5: Configure Environment Variables

Create `.env.local` in `apps/web/`:

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Google AI
GOOGLE_AI_API_KEY=your-google-ai-key

# App Configuration
NEXT_PUBLIC_APP_URL=http://localhost:3000
ADMIN_EMAIL=your-admin-email@example.com

# Optional: Analytics
NEXT_PUBLIC_GA_ID=your-google-analytics-id
```

## Step 6: Create Admin User

After first sign-up, run this SQL in Supabase:

```sql
-- Set user as admin
UPDATE public.profiles
SET role = 'admin'
WHERE email = 'your-admin-email@example.com';
```

## Step 7: Run Development Server

```bash
# Run web app
npm run web:dev

# Or run all apps
npm run dev
```

Visit `http://localhost:3000`

## Step 8: Deploy to Vercel

### 8.1 Install Vercel CLI

```bash
npm install -g vercel
```

### 8.2 Deploy

```bash
cd apps/web
vercel

# Follow prompts to:
# 1. Link to Vercel project
# 2. Set environment variables
# 3. Deploy
```

### 8.3 Set Environment Variables in Vercel

In Vercel Dashboard:
1. Go to Project Settings → Environment Variables
2. Add all variables from `.env.local`
3. Redeploy

## Step 9: Configure Custom Domain (Optional)

1. In Vercel Dashboard, go to Domains
2. Add your custom domain
3. Update DNS records as instructed

## Step 10: Set Up Mobile App (Optional)

```bash
cd apps/mobile

# Install dependencies
npm install

# Start Expo
npx expo start

# Build for production
eas build --platform all
```

## Features Configuration

### Enable Two-Factor Authentication

1. Install authenticator library:
```bash
npm install speakeasy qrcode
```

2. Configure in admin settings

### Enable Voice Analysis

1. Ensure microphone permissions in browser
2. Configure Web Speech API settings
3. Set up audio processing pipeline

### Enable Offline Mode

1. Configure service worker
2. Set up IndexedDB for caching
3. Implement sync strategy

## Troubleshooting

### Database Connection Issues

```bash
# Check Supabase connection
supabase status

# Reset database
supabase db reset
```

### Build Errors

```bash
# Clear cache
npm run clean

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### Environment Variable Issues

- Ensure all required variables are set
- Restart development server after changes
- Check Vercel deployment logs

## Security Checklist

- [ ] Enable Row Level Security (RLS) on all tables
- [ ] Set up proper CORS policies
- [ ] Configure rate limiting
- [ ] Enable 2FA for admin account
- [ ] Set up automated backups
- [ ] Configure SSL/TLS
- [ ] Implement input validation
- [ ] Set up monitoring and alerts

## Performance Optimization

### Enable Caching

```typescript
// next.config.js
module.exports = {
  images: {
    formats: ['image/avif', 'image/webp'],
  },
  experimental: {
    optimizeCss: true,
  },
}
```

### Configure CDN

- Use Vercel Edge Network
- Enable image optimization
- Set up proper cache headers

### Database Optimization

```sql
-- Create indexes for frequently queried fields
CREATE INDEX idx_poems_published_date ON poems(published_at DESC);
CREATE INDEX idx_poems_emotion ON poems(emotion);
```

## Monitoring

### Set Up Analytics

1. Google Analytics
2. Vercel Analytics
3. Supabase Analytics

### Error Tracking

```bash
npm install @sentry/nextjs
```

Configure Sentry in `next.config.js`

## Backup Strategy

### Automated Backups

1. Enable Supabase automated backups
2. Set up daily database dumps
3. Store backups in separate location

### Manual Backup

```bash
# Export database
supabase db dump > backup.sql

# Export storage
supabase storage download --bucket poem-covers
```

## Support

For issues or questions:
- GitHub Issues: [github.com/nnkskt-art/soullines-poetry-platform/issues](https://github.com/nnkskt-art/soullines-poetry-platform/issues)
- Email: nnkskt@gmail.com

## Next Steps

1. Customize theme colors
2. Add your first poem
3. Configure emotion detection settings
4. Set up analytics dashboard
5. Invite beta testers

---

**SoulLines** - Built with ❤️ by नवनीत कुमार
