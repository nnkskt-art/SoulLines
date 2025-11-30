'use client'

import { useEffect, useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'

interface AtmosphericBackgroundProps {
  emotion: string | null
}

export function AtmosphericBackground({ emotion }: AtmosphericBackgroundProps) {
  const [particles, setParticles] = useState<Array<{ id: number; x: number; delay: number }>>([])

  useEffect(() => {
    // Generate particles for effects
    if (emotion === 'sad' || emotion === 'romantic') {
      const newParticles = Array.from({ length: 20 }, (_, i) => ({
        id: i,
        x: Math.random() * 100,
        delay: Math.random() * 2,
      }))
      setParticles(newParticles)
    } else {
      setParticles([])
    }
  }, [emotion])

  const getGradient = () => {
    switch (emotion) {
      case 'sad':
        return 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
      case 'happy':
        return 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)'
      case 'romantic':
        return 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)'
      case 'motivational':
        return 'linear-gradient(135deg, #30cfd0 0%, #330867 100%)'
      case 'peaceful':
        return 'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)'
      case 'angry':
        return 'linear-gradient(135deg, #ff0844 0%, #ffb199 100%)'
      case 'nostalgic':
        return 'linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%)'
      default:
        return 'linear-gradient(135deg, #e0e0e0 0%, #f5f5f5 100%)'
    }
  }

  return (
    <div className="fixed inset-0 -z-10">
      <AnimatePresence mode="wait">
        <motion.div
          key={emotion || 'default'}
          initial={{ opacity: 0 }}
          animate={{ opacity: 0.3 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 1 }}
          className="absolute inset-0"
          style={{ background: getGradient() }}
        />
      </AnimatePresence>

      {/* Rain effect for sad emotion */}
      {emotion === 'sad' && (
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          {particles.map((particle) => (
            <motion.div
              key={particle.id}
              className="rain-drop"
              initial={{ y: -100, x: `${particle.x}%` }}
              animate={{ y: '100vh' }}
              transition={{
                duration: 1,
                repeat: Infinity,
                delay: particle.delay,
                ease: 'linear',
              }}
              style={{
                position: 'absolute',
                width: '2px',
                height: '50px',
                background: 'linear-gradient(transparent, rgba(255, 255, 255, 0.6))',
              }}
            />
          ))}
        </div>
      )}

      {/* Petal effect for romantic emotion */}
      {emotion === 'romantic' && (
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          {particles.map((particle) => (
            <motion.div
              key={particle.id}
              className="petal"
              initial={{ 
                y: -100, 
                x: `${particle.x}%`,
                rotate: 0,
                opacity: 1 
              }}
              animate={{ 
                y: '100vh',
                rotate: 360,
                opacity: 0
              }}
              transition={{
                duration: 8,
                repeat: Infinity,
                delay: particle.delay,
                ease: 'linear',
              }}
              style={{
                position: 'absolute',
                width: '10px',
                height: '10px',
                background: 'rgba(255, 182, 193, 0.8)',
                borderRadius: '50% 0 50% 0',
              }}
            />
          ))}
        </div>
      )}

      {/* Sunrise effect for motivational emotion */}
      {emotion === 'motivational' && (
        <motion.div
          className="absolute bottom-0 left-1/2 -translate-x-1/2"
          initial={{ y: '100%', scale: 0.8, opacity: 0 }}
          animate={{ y: 0, scale: 1, opacity: 0.5 }}
          transition={{ duration: 2, ease: 'easeOut' }}
          style={{
            width: '400px',
            height: '400px',
            borderRadius: '50%',
            background: 'radial-gradient(circle, rgba(255,215,0,0.6) 0%, transparent 70%)',
            filter: 'blur(40px)',
          }}
        />
      )}
    </div>
  )
}
