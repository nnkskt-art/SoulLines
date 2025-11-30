'use client'

import { useEffect, useState } from 'react'
import { motion } from 'framer-motion'
import Link from 'next/link'
import { BookOpen, Heart, Sparkles, TrendingUp } from 'lucide-react'
import { EmotionSelector } from '@/components/emotion-selector'
import { PoemCard } from '@/components/poem-card'
import { AtmosphericBackground } from '@/components/atmospheric-background'

export default function HomePage() {
  const [selectedEmotion, setSelectedEmotion] = useState<string | null>(null)
  const [poems, setPoems] = useState<any[]>([])

  useEffect(() => {
    // Fetch poems based on selected emotion
    // In production, this would call Supabase
    fetchPoems(selectedEmotion)
  }, [selectedEmotion])

  const fetchPoems = async (emotion: string | null) => {
    // Placeholder - would fetch from Supabase
    setPoems([])
  }

  return (
    <div className="min-h-screen relative overflow-hidden">
      <AtmosphericBackground emotion={selectedEmotion} />
      
      {/* Hero Section */}
      <section className="relative z-10 pt-20 pb-16 px-4">
        <div className="max-w-7xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
          >
            <h1 className="text-6xl md:text-8xl font-playfair font-bold mb-6 bg-clip-text text-transparent bg-gradient-to-r from-purple-400 to-pink-600">
              SoulLines
            </h1>
            <p className="text-xl md:text-2xl text-muted-foreground mb-8 max-w-2xl mx-auto">
              Where poetry meets emotion, technology meets art
            </p>
            
            <div className="flex gap-4 justify-center flex-wrap">
              <Link 
                href="/explore"
                className="px-8 py-3 bg-primary text-primary-foreground rounded-full font-medium hover:opacity-90 transition-opacity"
              >
                Explore Poems
              </Link>
              <Link 
                href="/timeline"
                className="px-8 py-3 border border-border rounded-full font-medium hover:bg-accent transition-colors"
              >
                View Timeline
              </Link>
            </div>
          </motion.div>
        </div>
      </section>

      {/* Emotion Selector */}
      <section className="relative z-10 py-12 px-4">
        <div className="max-w-7xl mx-auto">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
          >
            <h2 className="text-3xl font-playfair font-bold text-center mb-8">
              How are you feeling today?
            </h2>
            <EmotionSelector 
              selected={selectedEmotion}
              onSelect={setSelectedEmotion}
            />
          </motion.div>
        </div>
      </section>

      {/* Featured Poems */}
      <section className="relative z-10 py-12 px-4">
        <div className="max-w-7xl mx-auto">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.4 }}
          >
            <div className="flex items-center justify-between mb-8">
              <h2 className="text-3xl font-playfair font-bold">
                {selectedEmotion ? `${selectedEmotion} Poems` : 'Featured Poems'}
              </h2>
              <Link 
                href="/explore"
                className="text-primary hover:underline flex items-center gap-2"
              >
                View All
                <TrendingUp className="w-4 h-4" />
              </Link>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {poems.length === 0 ? (
                <div className="col-span-full text-center py-12 text-muted-foreground">
                  <BookOpen className="w-16 h-16 mx-auto mb-4 opacity-50" />
                  <p>No poems available yet. Check back soon!</p>
                </div>
              ) : (
                poems.map((poem) => (
                  <PoemCard key={poem.id} poem={poem} />
                ))
              )}
            </div>
          </motion.div>
        </div>
      </section>

      {/* Features Section */}
      <section className="relative z-10 py-16 px-4">
        <div className="max-w-7xl mx-auto">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.6 }}
          >
            <h2 className="text-3xl font-playfair font-bold text-center mb-12">
              Extraordinary Features
            </h2>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              <FeatureCard
                icon={<Sparkles className="w-8 h-8" />}
                title="Emotion-Reactive Display"
                description="Backgrounds change based on poem emotions with rain, petals, and sunrise effects"
              />
              <FeatureCard
                icon={<Heart className="w-8 h-8" />}
                title="Voice Aura Interpretation"
                description="Read poems aloud and get recommendations based on your emotional tone"
              />
              <FeatureCard
                icon={<BookOpen className="w-8 h-8" />}
                title="Poem Fusion Generator"
                description="Combine any two poems to create unique AI-generated fusion pieces"
              />
            </div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}

function FeatureCard({ 
  icon, 
  title, 
  description 
}: { 
  icon: React.ReactNode
  title: string
  description: string 
}) {
  return (
    <motion.div
      whileHover={{ scale: 1.05 }}
      className="p-6 rounded-2xl glass backdrop-blur-lg border border-border"
    >
      <div className="text-primary mb-4">{icon}</div>
      <h3 className="text-xl font-semibold mb-2">{title}</h3>
      <p className="text-muted-foreground">{description}</p>
    </motion.div>
  )
}
