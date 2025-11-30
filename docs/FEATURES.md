# SoulLines Features Documentation

Comprehensive guide to all extraordinary features in SoulLines.

## 1. Emotion-Reactive Poetry Display

### Overview
Background themes automatically change based on detected poem emotions, creating an immersive reading experience.

### Emotions & Effects

| Emotion | Gradient | Visual Effect | Description |
|---------|----------|---------------|-------------|
| **Sad** | Purple-Violet | Rain drops | Gentle rain falling creates melancholic atmosphere |
| **Happy** | Pink-Red | None | Vibrant, energetic gradient |
| **Romantic** | Pink-Yellow | Falling petals | Rose petals gently falling |
| **Motivational** | Cyan-Purple | Sunrise | Rising sun effect from bottom |
| **Peaceful** | Teal-Pink | None | Soft, calming gradient |
| **Angry** | Red-Orange | None | Intense, fiery gradient |
| **Nostalgic** | Cream-Peach | None | Warm, vintage tones |
| **Neutral** | Gray-White | None | Clean, minimal background |

### Implementation

```typescript
import { EmotionDetector } from '@/lib/emotion-detector'

const analysis = EmotionDetector.analyze(poemContent)
const theme = EmotionDetector.getTheme(analysis.primary)
```

### Customization

Admins can override automatic emotion detection and manually set poem emotions.

---

## 2. Voice Aura Interpretation

### Overview
Users read poems aloud, and the app analyzes their vocal tone and emotion to provide personalized recommendations.

### How It Works

1. **Recording**: User taps microphone icon and reads poem
2. **Analysis**: System analyzes:
   - Pitch (low to high)
   - Energy (calm to energetic)
   - Tempo (words per minute)
3. **Emotion Detection**: Maps voice characteristics to emotions
4. **Recommendations**: Suggests poems matching detected emotion

### Voice-to-Emotion Mapping

```typescript
// High energy + high pitch = Happy
// Low energy + low pitch = Sad
// Medium energy + varied pitch = Romantic
// High energy + medium pitch = Motivational
```

### Privacy

- Recordings are processed locally when possible
- Optional cloud processing for advanced analysis
- Recordings are not stored permanently
- Users can delete voice data anytime

---

## 3. Poem Time-Travel Timeline

### Overview
Interactive timeline showing the evolution of your poetry writing, mood graphs, and theme progression.

### Features

- **Chronological View**: All poems arranged by creation date
- **Mood Graph**: Visual representation of emotional trends over time
- **Theme Clusters**: Poems grouped by similar themes
- **Writing Patterns**: Insights into writing frequency and style evolution
- **Milestone Markers**: Special events and achievements

### Timeline Views

1. **Linear Timeline**: Scrollable horizontal timeline
2. **Calendar View**: Monthly grid with poem markers
3. **Graph View**: Statistical visualization of trends
4. **Cluster View**: Thematic groupings

### Analytics Provided

- Most common emotions
- Writing frequency patterns
- Theme evolution
- Vocabulary growth
- Style changes over time

---

## 4. AI Poem Companion Read-Along Mode

### Overview
Emotion-matched narration with adaptive ambient soundscapes that enhance the reading experience.

### Features

- **AI Narration**: Natural voice reading with emotional inflection
- **Ambient Soundscapes**: Background sounds matching poem mood
- **Adaptive Pacing**: Reading speed adjusts to poem rhythm
- **Highlight Sync**: Text highlights as it's being read
- **Emotion Transitions**: Smooth audio transitions between emotional shifts

### Soundscapes

| Emotion | Soundscape |
|---------|------------|
| Sad | Rain, distant thunder, soft piano |
| Happy | Birds chirping, light music |
| Romantic | Soft strings, gentle breeze |
| Motivational | Uplifting orchestral, drums |
| Peaceful | Ocean waves, wind chimes |
| Angry | Storm, intense percussion |
| Nostalgic | Vintage music box, old records |

### Controls

- Play/Pause
- Speed adjustment (0.5x - 2x)
- Volume control
- Soundscape intensity
- Voice selection

---

## 5. Hidden Meanings Layer

### Overview
Swipable deeper layers under poems revealing secrets, interpretations, or additional context added by admin.

### Layer Types

1. **Interpretation Layer**: Explanation of metaphors and symbolism
2. **Context Layer**: Background story or inspiration
3. **Translation Layer**: Alternative meanings or translations
4. **Personal Notes**: Author's private thoughts
5. **Easter Eggs**: Hidden messages or surprises

### User Experience

- Swipe up to reveal layers
- Each layer has distinct visual style
- Layers can be locked/unlocked
- Some layers require achievements to unlock

### Admin Controls

```typescript
// Add hidden meaning
{
  layerType: 'interpretation',
  content: 'The rain symbolizes...',
  unlockCondition: 'default' | 'achievement' | 'time-based'
}
```

---

## 6. Poem Fusion Generator

### Overview
Users can select any two poems and AI generates a unique fusion piece combining both.

### Fusion Styles

1. **Blend**: Seamlessly mix themes and imagery
2. **Alternate**: Create dialogue between poems
3. **Thematic**: Explore theme intersections
4. **Emotional**: Combine emotional journeys

### How It Works

```typescript
const fusion = await PoemFusionGenerator.generateFusion(
  poem1,
  poem2,
  'blend'
)
```

### Features

- AI-powered generation using Gemini
- Temporary (24-hour) storage
- Shareable links
- Cannot be saved permanently
- Respects original poem copyrights

### Limitations

- Maximum 2 poems per fusion
- Poems must be substantial (50+ characters)
- Cannot fuse same poem with itself
- Rate limited to prevent abuse

---

## 7. Mood-Driven Home Feed

### Overview
Users select their current emotion, and the feed adapts to match or balance their mood.

### Strategies

**Match Mode**: Shows poems with similar emotions
- Sad → Sad, Nostalgic, Peaceful poems
- Happy → Happy, Motivational, Romantic poems

**Balance Mode**: Shows complementary emotions
- Sad → Happy, Motivational, Peaceful poems
- Angry → Peaceful, Happy, Romantic poems

### Personalization

- Learns from user preferences
- Considers reading history
- Adapts to time of day
- Seasonal adjustments

### Algorithm

```typescript
const recommendations = EmotionDetector.recommendByMood(
  userEmotion,
  strategy: 'match' | 'balance'
)
```

---

## 8. Real-Time Poetry Atmosphere Projection

### Overview
Background colors, animations, and ambient effects shift subtly as users scroll line by line.

### Dynamic Elements

- **Color Transitions**: Gradual color shifts between lines
- **Particle Effects**: Contextual animations
- **Blur Effects**: Depth and focus changes
- **Light Effects**: Subtle glows and shadows
- **Motion**: Parallax and scroll-based animations

### Line-by-Line Analysis

Each line is analyzed for:
- Emotional intensity
- Imagery type
- Rhythm and pace
- Key words and themes

### Performance

- GPU-accelerated animations
- Optimized for 60fps
- Minimal battery impact
- Graceful degradation on low-end devices

---

## 9. Poem Memory Capsule

### Overview
Users can lock a poem with a personal note that reopens after a chosen future date.

### Features

- **Time Lock**: Set any future date
- **Personal Note**: Add private message
- **Notification**: Reminder when capsule unlocks
- **Reflection**: Compare past and present feelings
- **Privacy**: Fully encrypted and private

### Use Cases

- Birthday messages to future self
- Anniversary reflections
- Goal tracking
- Emotional time capsules
- Memory preservation

### Implementation

```typescript
{
  poemId: 'uuid',
  personalNote: 'Reading this in 2025...',
  unlockDate: '2025-12-31',
  isUnlocked: false
}
```

---

## 10. Admin Analytics Dashboard

### Overview
Comprehensive analytics for poem performance and reader engagement.

### Metrics Tracked

#### Poem Analytics
- View count
- Like count
- Comment count
- Bookmark count
- Share count
- Reading time average
- Completion rate

#### Emotional Trends
- Emotion distribution
- Mood patterns over time
- Seasonal emotional trends
- User emotion preferences

#### Reading Patterns
- Peak reading times
- Average session duration
- Scroll depth
- Line highlighting frequency
- Re-read rate

#### Engagement Heatmaps
- Most highlighted lines
- Drop-off points
- Engagement by section
- Time spent per line

### Visualizations

- Line charts for trends
- Heatmaps for engagement
- Pie charts for distribution
- Bar graphs for comparisons
- Geographic maps for reach

### Export Options

- CSV export
- PDF reports
- API access
- Real-time webhooks

---

## Additional Features

### Offline Mode
- Cache viewed poems
- Sync when online
- Background sync
- Conflict resolution

### Dark/Light Mode
- System preference detection
- Manual toggle
- Scheduled switching
- Per-poem themes

### Accessibility
- Screen reader support
- Keyboard navigation
- High contrast mode
- Font size adjustment
- Dyslexia-friendly fonts

### Social Features
- Share to social media
- Generate quote images
- Embed poems
- QR code generation

### Search & Discovery
- Full-text search
- Filter by emotion
- Filter by category
- Sort by popularity
- Advanced filters

---

## Coming Soon

- **Collaborative Poems**: Multiple users contribute
- **Poem Challenges**: Weekly writing prompts
- **Community Voting**: Reader's choice awards
- **Translation Support**: Multi-language poems
- **Audio Poems**: Record your own readings
- **Poem Collections**: Curated anthologies
- **NFT Integration**: Mint poems as NFTs
- **AR Experience**: View poems in augmented reality

---

**SoulLines** - Where every feature tells a story
