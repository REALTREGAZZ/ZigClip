# ZIGCLIP - Arena

PWA de validación de skills basada en duelos de clips con arquitectura modular.

## 🏗️ Arquitectura

### Estructura de Archivos

```
/zigclip
├── index.html              # Orquestador principal
├── manifest.json           # PWA metadata
├── sw.js                   # Service Worker (offline-first)
│
├── /css
│   ├── reset.css          # CSS reset
│   ├── theme.css          # Paleta cyberpunk neón
│   ├── components.css     # Botones, cards, containers
│   ├── screens.css        # Layouts de pantallas
│   └── animations.css     # Keyframes y transiciones
│
├── /js
│   ├── app.js             # Inicialización + Screen Manager
│   ├── arena.js           # Lógica de duelos + swipe detection
│   ├── videoManager.js    # Preload, loop, cero flashazos
│   ├── eloSystem.js       # Cálculo ELO K=32
│   ├── ranking.js         # Top 100 + filtros
│   ├── brag.js            # Canvas export 1080x1920
│   ├── storage.js         # localStorage wrapper
│   ├── effects.js         # Sonidos, vibraciones, animaciones
│   └── dataManager.js     # Carga clips.json + defaults
│
├── /data
│   └── clips.json         # Lista de clips expandible
│
└── /assets
    ├── logo.svg
    ├── /sounds
    │   └── kill.mp3
    └── /videos
        ├── clip_1.mp4
        ├── clip_2.mp4
        ├── clip_3.mp4
        ├── clip_4.mp4
        └── clip_5.mp4
```

## 🚀 Stack Tecnológico

- **HTML5**: Estructura semántica
- **CSS3**: Variables CSS, Grid, Flexbox, Animations
- **ES6 Modules**: Import/Export nativo
- **Service Worker**: Cache Strategy para offline
- **Canvas API**: Export de Brag Cards
- **localStorage**: Persistencia de datos
- **Web APIs**: Touch Events, Vibration API, Audio API

## 🎯 Módulos

### app.js - Orquestador Principal
- Inicializa todos los módulos
- Gestiona navegación entre pantallas
- Registra Service Worker
- Coordina flujo de datos

### videoManager.js - Gestor de Video (CRÍTICO)
- Mantiene 2 elementos `<video>` en DOM
- Precarga agresiva del siguiente par
- Evita flashazos con crossfade
- Loop infinito de clips
- requestAnimationFrame para sincronización

### arena.js - Pantalla de Duelos
- Detección swipe (touch + mouse)
- Gestión de clicks/swipes
- Feedback inmediato (UI first)
- Comunicación con ELO y Effects

### eloSystem.js - Sistema ELO
- Fórmula: `ΔElo = K * (1 - 1 / (1 + 10^((opponentElo - userElo)/400)))`
- K = 32 (constante)
- Cálculo de tiers y badges
- Procesamiento de matches

### ranking.js - Wall of Ego
- Top 100 dinámico
- Filtros: Week / Month / AllTime
- Colores por posición (Top 3 glow)
- Usuario siempre visible

### brag.js - Export de Status
- Canvas 1080x1920px
- Overlay con gradientes
- Logo + tier + stats
- Exportable como PNG

### effects.js - Sistema de Dopamina
- Flash: radial-gradient (0.1s)
- Sonido: kill.mp3
- Vibración: pattern [50, 30, 50]
- Animaciones: +ELO popup
- Combo effects

### storage.js - Persistencia
- Wrapper de localStorage
- Gestión de user data
- Historial de ELO
- Registro de votos

### dataManager.js - Gestión de Clips
- Carga clips.json
- Fallback a defaults
- Update de stats de clips
- Sorting por ELO

## 🎨 Paleta Visual (Cyberpunk Neón)

```css
--bg-dark: #050505
--bg-secondary: #1a1a1a
--neon-cyan: #00FFD0
--neon-green: #00FF00
--red-loss: #FF3B3B
--text-gray: #B0B0B0
--font-mono: 'Courier New', monospace
```

## 📱 PWA Features

### Service Worker (sw.js)
- **Cache Strategy**: 
  - HTML/CSS/JS/Assets: Cache-first
  - clips.json: Network-first con fallback
  - Videos: Cache on demand
- **Offline**: 100% funcional
- **Add to Home Screen**: Soportado
- **Fullscreen Mode**: Soportado

### Manifest.json
- Standalone display mode
- Portrait orientation
- Theme color: #00FFD0
- Icon: logo.svg (any size)

## 🔧 Desarrollo

### Requisitos
- Navegador moderno con soporte ES6 Modules
- Live Server o servidor HTTP local
- No requiere NPM ni build tools

### Instalación
```bash
# Clonar repositorio
git clone <repo>
cd zigclip

# Servir con Live Server (VS Code) o Python
python3 -m http.server 8000
```

### Testing Local
1. Abrir `http://localhost:8000`
2. Aceptar permisos de audio
3. Click en START
4. Swipe o click para votar

## 📦 Deployment

### GitHub Pages
```bash
git add .
git commit -m "feat: modular architecture"
git push origin main
```

Configurar GitHub Pages en Settings → Pages → Deploy from branch: main

### Netlify / Vercel
1. Conectar repositorio
2. Build command: (ninguno)
3. Publish directory: `/`
4. Deploy

## ✅ Criterios de Aceptación

- [x] Estructura modular con responsabilidad única
- [x] VideoManager sin flashazos, preload funcionando
- [x] Arena con swipe/click detection fluido
- [x] ELO calculando correctamente (K=32)
- [x] Ranking Top 100 con filtros y usuario visible
- [x] Brag Card exportable como PNG
- [x] Effects (sonidos, vibraciones, animaciones)
- [x] PWA con Service Worker cacheando
- [x] Offline funcional con clips cacheados
- [x] Performance 60fps sin lag
- [x] UI cyberpunk coherente
- [x] Código limpio y escalable
- [x] Deployable en GitHub Pages

## 🔐 Sin Dependencias Externas

- ✅ Cero frameworks (React, Vue, Angular)
- ✅ Cero bundlers (Webpack, Vite, Parcel)
- ✅ Cero NPM obligatorio
- ✅ Cero CDNs externos
- ✅ Cero servicios pagos
- ✅ 100% offline-ready

## 🎮 Flujo de Usuario

1. **Startup** → Click START → Arena
2. **Arena** → Swipe/Click para votar → Feedback inmediato
3. **Ranking** → Ver Top 100 + posición propia
4. **Brag** → Ver stats + Exportar PNG

## 🚧 Futuras Mejoras

- [ ] Agregar más clips dinámicamente
- [ ] Sistema de achievements
- [ ] Compartir en redes sociales
- [ ] Histórico de duelos
- [ ] Modo offline con sync al volver online
- [ ] PWA push notifications

## 📄 Licencia

MIT

---

**ZIGCLIP** - Valida tus skills. Domina el Arena. 🔥
