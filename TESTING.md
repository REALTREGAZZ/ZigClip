# ZIGCLIP - Testing Guide

## 🧪 Manual Testing Checklist

### Pre-Test Setup
1. Servir la aplicación localmente
2. Abrir DevTools (F12)
3. Limpiar caché y cookies
4. Verificar consola para errores

### 1. Startup Screen
- [ ] Logo "ZIGCLIP" con glow animation visible
- [ ] Texto "ENTER THE ARENA" visible
- [ ] Botón "START" responde al hover
- [ ] Click en START lleva a Arena

### 2. Arena - Video Manager
- [ ] Ambos videos cargan correctamente
- [ ] Videos reproducen en loop
- [ ] No hay flashazos al cambiar clips
- [ ] Nombres y ELO de clips visibles
- [ ] Counter "DUEL #X" incrementa

### 3. Arena - Interacción
- [ ] Click en video izquierdo selecciona ganador
- [ ] Click en video derecho selecciona ganador
- [ ] Swipe arriba/abajo funciona (touch)
- [ ] Flash blanco aparece al seleccionar
- [ ] Sonido "kill.mp3" reproduce
- [ ] Popup "+X ELO" aparece al centro
- [ ] Vibración (en mobile)
- [ ] Siguiente par de videos carga suavemente

### 4. Ranking - Wall of Ego
- [ ] Click en tab "RANKING" cambia pantalla
- [ ] Tabla Top 100 visible
- [ ] Filtros (ALLTIME, MONTH, WEEK) funcionan
- [ ] Usuario "YOU" está resaltado
- [ ] Top 3 tiene glow cyan
- [ ] Badges (👑, ⭐, 🔥) visibles
- [ ] Scroll funciona correctamente

### 5. Brag - Export Status
- [ ] Click en tab "BRAG" cambia pantalla
- [ ] ELO del usuario visible y actualizado
- [ ] Stats (Wins, Losses, Win Rate) correctos
- [ ] Botón "EXPORT STATUS" funciona
- [ ] Click descarga PNG (1080x1920)
- [ ] Canvas tiene logo, tier, stats
- [ ] Texto legible en export

### 6. Navigation
- [ ] Tab "ARENA" activa cuando seleccionada
- [ ] Tab "RANKING" activa cuando seleccionada
- [ ] Tab "BRAG" activa cuando seleccionada
- [ ] Videos pausan cuando sales de Arena
- [ ] Videos resumen cuando vuelves a Arena

### 7. PWA - Service Worker
- [ ] Service Worker registrado (DevTools → Application)
- [ ] Cache "zigclip-v1" creado
- [ ] Assets cacheados correctamente
- [ ] App funciona offline (modo avión)
- [ ] Icono "Instalar" aparece en barra

### 8. PWA - Install
- [ ] "Add to Home Screen" funciona
- [ ] App abre en fullscreen (standalone)
- [ ] Offline functionality mantiene
- [ ] Videos cacheados reproducen

### 9. Mobile Responsiveness
- [ ] Layout funciona en 375px width
- [ ] Videos no distorsionados
- [ ] Botones clickeables (44px min)
- [ ] Texto legible sin zoom
- [ ] Bottom nav no obstruye contenido

### 10. Performance
- [ ] No lag al cambiar videos
- [ ] Animaciones fluidas (60fps)
- [ ] Sin memory leaks (verificar en profiler)
- [ ] Carga inicial < 3 segundos
- [ ] Interacciones responden < 100ms

### 11. Browser Compatibility
- [ ] Chrome/Edge (latest)
- [ ] Firefox (latest)
- [ ] Safari iOS (latest)
- [ ] Chrome Android (latest)

### 12. Data Persistence
- [ ] ELO persiste tras recargar página
- [ ] Stats persisten tras recargar
- [ ] localStorage contiene "zigclip_data"
- [ ] Historial de votos guardado

## 🐛 Common Issues & Fixes

### Videos no cargan
```javascript
// En consola, verificar:
document.querySelector('#video-left').readyState
document.querySelector('#video-right').readyState
// Debe ser >= 2 (HAVE_CURRENT_DATA)
```

### Service Worker no registra
```javascript
// En consola:
navigator.serviceWorker.getRegistrations().then(console.log)
// Debe mostrar registration activa
```

### Audio no reproduce
- Click en página primero (política autoplay)
- Verificar volumen del sistema
- Verificar en DevTools → Console para errores

### Offline no funciona
- Verificar Service Worker activo
- Verificar assets en cache
- Forzar reload (Ctrl + Shift + R)

## 🔍 DevTools Inspection

### Console Checks
```javascript
// Verificar Storage
localStorage.getItem('zigclip_data')

// Verificar clips cargados
window.zigclip.dataManager.getClips()

// Verificar user data
window.zigclip.storage.getUserData()

// Limpiar storage y reiniciar
window.zigclip.storage.clear()
location.reload()
```

### Application Panel
- **Service Workers**: Debe mostrar "activated and running"
- **Cache Storage**: Debe tener "zigclip-v1" con assets
- **Local Storage**: Debe tener key "zigclip_data"

### Network Panel
- Verificar que assets cargan
- Verificar Content-Type correcto (JS, CSS)
- Verificar 200 status codes

### Performance Panel
- Grabar sesión de 10 segundos
- FPS debe mantenerse ~60fps
- No debe haber long tasks (>50ms)

## 📊 Lighthouse Audit

### Correr Audit
1. DevTools → Lighthouse
2. Seleccionar: Performance, Accessibility, Best Practices, SEO, PWA
3. Mode: Desktop o Mobile
4. Generate report

### Scores Objetivo
- **Performance**: ≥ 90
- **Accessibility**: ≥ 90
- **Best Practices**: ≥ 90
- **SEO**: ≥ 80
- **PWA**: ✓ Installable

## ✅ Acceptance Criteria

### Funcional
- ✅ Todos los módulos cargan sin errores
- ✅ Videos reproducen sin flashazos
- ✅ ELO calcula correctamente (K=32)
- ✅ Ranking actualiza en real-time
- ✅ Brag export descarga PNG

### Performance
- ✅ 60fps en animaciones
- ✅ Sin lag al cambiar videos
- ✅ < 3s carga inicial

### PWA
- ✅ Service Worker registrado
- ✅ Offline funcional
- ✅ Installable

### UX
- ✅ Feedback inmediato en clicks
- ✅ Animaciones suaves
- ✅ UI coherente cyberpunk

## 🚀 Automated Tests (Future)

```javascript
// Example test structure (Jest/Vitest)
describe('EloSystem', () => {
  test('calculates ELO correctly', () => {
    const elo = new EloSystem(32);
    const delta = elo.calculate(2000, 2000);
    expect(delta).toBe(16);
  });
});

describe('Storage', () => {
  test('persists user data', () => {
    const storage = new Storage();
    storage.updateUserElo(50);
    expect(storage.getUserData().elo).toBe(2500);
  });
});
```

## 📝 Test Report Template

```
Date: _______
Browser: _______
Device: _______

✅ Startup: Pass / Fail
✅ Arena: Pass / Fail
✅ Ranking: Pass / Fail
✅ Brag: Pass / Fail
✅ PWA: Pass / Fail
✅ Offline: Pass / Fail
✅ Performance: Pass / Fail

Issues Found:
1. _______________
2. _______________

Notes:
_______________
```

---

**Reportar Issues**: Crear ticket con consola logs + screenshots
