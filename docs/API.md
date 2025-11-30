# SoulLines API Documentation

Complete API reference for the SoulLines platform.

## Base URL

```
Production: https://soullines.vercel.app/api
Development: http://localhost:3000/api
```

## Authentication

All authenticated endpoints require a valid Supabase JWT token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## Endpoints

### Poems

#### Get All Poems

```http
GET /api/poems
```

**Query Parameters:**
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 10)
- `emotion` (string): Filter by emotion
- `category` (string): Filter by category
- `sort` (string): Sort by (views, likes, date)

**Response:**
```json
{
  "poems": [
    {
      "id": "uuid",
      "title": "Poem Title",
      "excerpt": "First few lines...",
      "emotion": "romantic",
      "category": "love",
      "likeCount": 42,
      "viewCount": 150,
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 100,
    "pages": 10
  }
}
```

#### Get Single Poem

```http
GET /api/poems/:id
```

**Response:**
```json
{
  "id": "uuid",
  "title": "Poem Title",
  "content": "Full poem content...",
  "emotion": "romantic",
  "category": "love",
  "tags": ["love", "nature"],
  "hiddenMeanings": [
    {
      "layerType": "interpretation",
      "content": "The rain symbolizes..."
    }
  ],
  "likeCount": 42,
  "viewCount": 150,
  "commentCount": 8,
  "createdAt": "2024-01-01T00:00:00Z"
}
```

#### Create Poem (Admin Only)

```http
POST /api/poems
Authorization: Bearer <admin-token>
```

**Request Body:**
```json
{
  "title": "New Poem",
  "content": "Poem content...",
  "excerpt": "First few lines...",
  "category": "love",
  "tags": ["love", "nature"],
  "emotion": "romantic",
  "coverImageUrl": "https://...",
  "isPublished": true,
  "scheduledAt": "2024-12-31T00:00:00Z",
  "hiddenMeanings": [
    {
      "layerType": "interpretation",
      "content": "Explanation..."
    }
  ]
}
```

#### Update Poem (Admin Only)

```http
PATCH /api/poems/:id
Authorization: Bearer <admin-token>
```

#### Delete Poem (Admin Only)

```http
DELETE /api/poems/:id
Authorization: Bearer <admin-token>
```

---

### Emotions

#### Analyze Poem Emotion

```http
POST /api/emotions/analyze
```

**Request Body:**
```json
{
  "content": "Poem content to analyze..."
}
```

**Response:**
```json
{
  "primary": "romantic",
  "confidence": 0.85,
  "scores": {
    "sad": 0.1,
    "happy": 0.2,
    "romantic": 0.85,
    "motivational": 0.3,
    "peaceful": 0.4,
    "angry": 0.05,
    "nostalgic": 0.15,
    "neutral": 0.1
  },
  "keywords": ["love", "heart", "forever"],
  "theme": {
    "gradient": "linear-gradient(...)",
    "effect": "petals",
    "colors": ["#fa709a", "#fee140"]
  }
}
```

#### Get Emotion Recommendations

```http
GET /api/emotions/recommend?emotion=sad&strategy=balance
```

**Query Parameters:**
- `emotion` (string): User's current emotion
- `strategy` (string): 'match' or 'balance'

**Response:**
```json
{
  "recommendedEmotions": ["happy", "motivational", "peaceful"],
  "poems": [...]
}
```

---

### Voice Analysis

#### Analyze Voice Recording

```http
POST /api/voice/analyze
Authorization: Bearer <token>
Content-Type: multipart/form-data
```

**Request Body:**
- `audio` (file): Audio recording (WAV, MP3, M4A)
- `poemId` (string, optional): Associated poem ID

**Response:**
```json
{
  "emotion": "happy",
  "confidence": 0.78,
  "tone": {
    "pitch": 0.65,
    "energy": 0.72,
    "tempo": 125
  },
  "recommendations": ["poem-id-1", "poem-id-2"]
}
```

#### Get Voice Profile

```http
GET /api/voice/profile
Authorization: Bearer <token>
```

**Response:**
```json
{
  "dominantEmotion": "romantic",
  "averageTone": {
    "pitch": 0.55,
    "energy": 0.60,
    "tempo": 120
  },
  "emotionDistribution": {
    "sad": 0.15,
    "happy": 0.25,
    "romantic": 0.35,
    ...
  },
  "totalAnalyses": 42
}
```

---

### Poem Fusion

#### Generate Fusion

```http
POST /api/fusion/generate
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "poem1Id": "uuid-1",
  "poem2Id": "uuid-2",
  "style": "blend"
}
```

**Fusion Styles:**
- `blend`: Seamless mix
- `alternate`: Dialogue between poems
- `thematic`: Theme intersection
- `emotional`: Emotional journey

**Response:**
```json
{
  "id": "fusion-uuid",
  "title": "Fusion: Poem 1 × Poem 2",
  "content": "Fused poem content...",
  "sourcePoems": [
    { "id": "uuid-1", "title": "Poem 1" },
    { "id": "uuid-2", "title": "Poem 2" }
  ],
  "fusionStyle": "blend",
  "createdAt": "2024-01-01T00:00:00Z",
  "expiresAt": "2024-01-02T00:00:00Z"
}
```

#### Get Fusion

```http
GET /api/fusion/:id
Authorization: Bearer <token>
```

---

### Interactions

#### Like Poem

```http
POST /api/poems/:id/like
Authorization: Bearer <token>
```

#### Unlike Poem

```http
DELETE /api/poems/:id/like
Authorization: Bearer <token>
```

#### Bookmark Poem

```http
POST /api/poems/:id/bookmark
Authorization: Bearer <token>
```

#### Add Comment

```http
POST /api/poems/:id/comments
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "content": "Great poem!"
}
```

#### Get Comments

```http
GET /api/poems/:id/comments?page=1&limit=10
```

---

### Memory Capsules

#### Create Capsule

```http
POST /api/capsules
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "poemId": "uuid",
  "personalNote": "Reading this in 2025...",
  "unlockDate": "2025-12-31T00:00:00Z"
}
```

#### Get User Capsules

```http
GET /api/capsules
Authorization: Bearer <token>
```

#### Unlock Capsule

```http
POST /api/capsules/:id/unlock
Authorization: Bearer <token>
```

---

### Analytics (Admin Only)

#### Get Poem Analytics

```http
GET /api/analytics/poems/:id
Authorization: Bearer <admin-token>
```

**Response:**
```json
{
  "poemId": "uuid",
  "views": 1500,
  "likes": 250,
  "comments": 45,
  "bookmarks": 180,
  "shares": 32,
  "averageReadingTime": 180,
  "completionRate": 0.85,
  "emotionalTrends": {
    "happy": 0.35,
    "sad": 0.15,
    ...
  },
  "lineHighlights": [
    { "lineNumber": 5, "count": 42 },
    { "lineNumber": 12, "count": 38 }
  ],
  "readingHeatmap": [...]
}
```

#### Get Dashboard Stats

```http
GET /api/analytics/dashboard
Authorization: Bearer <admin-token>
```

**Response:**
```json
{
  "totalPoems": 150,
  "totalViews": 50000,
  "totalLikes": 8500,
  "totalUsers": 2500,
  "topPoems": [...],
  "emotionDistribution": {...},
  "growthMetrics": {...}
}
```

---

### Timeline

#### Get Writing Timeline

```http
GET /api/timeline
Authorization: Bearer <admin-token>
```

**Response:**
```json
{
  "timeline": [
    {
      "date": "2024-01-01",
      "poems": [...],
      "dominantEmotion": "romantic",
      "themes": ["love", "nature"]
    }
  ],
  "moodGraph": [...],
  "themeEvolution": [...],
  "writingPatterns": {...}
}
```

---

### User Profile

#### Get Profile

```http
GET /api/profile
Authorization: Bearer <token>
```

#### Update Profile

```http
PATCH /api/profile
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "fullName": "John Doe",
  "avatarUrl": "https://...",
  "preferences": {
    "theme": "dark",
    "notifications": true
  }
}
```

---

## Rate Limiting

- **Anonymous**: 100 requests per 15 minutes
- **Authenticated**: 1000 requests per 15 minutes
- **Admin**: Unlimited

## Error Responses

```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication required",
    "details": {}
  }
}
```

**Error Codes:**
- `UNAUTHORIZED`: Authentication required
- `FORBIDDEN`: Insufficient permissions
- `NOT_FOUND`: Resource not found
- `VALIDATION_ERROR`: Invalid input
- `RATE_LIMIT_EXCEEDED`: Too many requests
- `INTERNAL_ERROR`: Server error

---

## Webhooks

Subscribe to events:

```http
POST /api/webhooks/subscribe
Authorization: Bearer <admin-token>
```

**Request Body:**
```json
{
  "url": "https://your-server.com/webhook",
  "events": ["poem.created", "poem.liked", "comment.added"]
}
```

**Available Events:**
- `poem.created`
- `poem.updated`
- `poem.deleted`
- `poem.liked`
- `poem.viewed`
- `comment.added`
- `user.registered`

---

## SDK Examples

### JavaScript/TypeScript

```typescript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
)

// Get poems
const { data: poems } = await supabase
  .from('poems')
  .select('*')
  .eq('is_published', true)
  .order('created_at', { ascending: false })

// Like poem
await supabase
  .from('likes')
  .insert({ poem_id: poemId, user_id: userId })
```

### Python

```python
from supabase import create_client

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SUPABASE_KEY")
)

# Get poems
poems = supabase.table("poems")\
    .select("*")\
    .eq("is_published", True)\
    .execute()
```

---

**SoulLines API** - Built for developers, designed for poets
