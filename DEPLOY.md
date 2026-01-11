# ZIGCLIP - Guía de Deployment

## 🚀 Métodos de Deployment

### 1. GitHub Pages (Recomendado)

#### Setup Inicial
```bash
# Asegúrate de estar en la rama correcta
git checkout refactor-zigclip-modular-offline-pwa-video-manager

# Añadir todos los cambios
git add .

# Commit
git commit -m "feat: modular architecture with PWA support"

# Push
git push origin refactor-zigclip-modular-offline-pwa-video-manager
```

#### Configurar GitHub Pages
1. Ve a tu repositorio en GitHub
2. Settings → Pages
3. Source: Deploy from a branch
4. Branch: `refactor-zigclip-modular-offline-pwa-video-manager`
5. Folder: `/ (root)`
6. Save

#### Acceso
- URL: `https://<username>.github.io/<repo-name>/`
- El sitio estará disponible en 1-2 minutos

### 2. Netlify

#### Opción A: Drag & Drop
1. Ve a [netlify.com](https://netlify.com)
2. Arrastra la carpeta del proyecto
3. Deploy automático

#### Opción B: Git Integration
1. Conecta tu repositorio de GitHub
2. Build settings:
   - **Build command**: (dejar vacío)
   - **Publish directory**: `/`
3. Deploy

### 3. Vercel

```bash
# Instalar Vercel CLI (opcional)
npm i -g vercel

# Deploy
vercel
```

O usar la integración con GitHub.

### 4. Local Development

#### Python HTTP Server
```bash
cd /path/to/zigclip
python3 -m http.server 8000
```

Acceso: `http://localhost:8000`

#### PHP Server
```bash
cd /path/to/zigclip
php -S localhost:8000
```

#### Node.js http-server
```bash
npx http-server -p 8000
```

#### VS Code Live Server
1. Instala extensión "Live Server"
2. Right-click en `index.html`
3. "Open with Live Server"

## 🔧 Configuración Post-Deployment

### Service Worker
- El Service Worker se registrará automáticamente
- Verificar en DevTools → Application → Service Workers
- Forzar actualización: Application → Service Workers → Update

### PWA Install
- Chrome/Edge: Icono de instalación en barra de direcciones
- Safari iOS: Share → Add to Home Screen
- Android: Menú → Add to Home Screen

### Cache Management
Para limpiar caché y forzar actualización:
```javascript
// En DevTools Console
caches.keys().then(keys => {
  keys.forEach(key => caches.delete(key));
  location.reload();
});
```

## 🐛 Troubleshooting

### Videos no cargan
- Verificar que `/assets/videos/` tiene los 5 clips
- Verificar formato MP4 compatible con navegador
- Verificar permisos de archivos

### Service Worker no registra
- HTTPS requerido (excepto localhost)
- Verificar rutas en `sw.js`
- Verificar consola para errores

### Módulos ES6 no cargan
- Verificar que el servidor envía `Content-Type: application/javascript`
- Verificar rutas relativas en imports
- Verificar que navegador soporta ES6 modules

### PWA no instala
- Verificar `manifest.json` válido
- Verificar Service Worker activo
- Verificar HTTPS (requerido para PWA)

### Audio no reproduce
- Usuario debe interactuar primero (política de navegador)
- Verificar que `kill.mp3` existe en `/assets/sounds/`
- Verificar permisos de autoplay

## 📊 Performance

### Optimizaciones Aplicadas
- ✅ Service Worker con cache agresivo
- ✅ Preload de videos
- ✅ CSS modular cargado en paralelo
- ✅ ES6 modules con tree-shaking
- ✅ Assets comprimidos por servidor

### Métricas Objetivo
- **LCP (Largest Contentful Paint)**: < 2.5s
- **FID (First Input Delay)**: < 100ms
- **CLS (Cumulative Layout Shift)**: < 0.1
- **TTI (Time to Interactive)**: < 3.5s

### Testing Performance
```bash
# Lighthouse CLI
npx lighthouse http://localhost:8000 --view

# o usar DevTools → Lighthouse
```

## 🔐 Security Headers (opcional)

Si usas Netlify, crear `netlify.toml`:
```toml
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    X-XSS-Protection = "1; mode=block"
    Referrer-Policy = "strict-origin-when-cross-origin"
```

## 🌍 Custom Domain (opcional)

### GitHub Pages
1. Settings → Pages → Custom domain
2. Agregar CNAME record en DNS: `yourdomain.com` → `username.github.io`

### Netlify/Vercel
1. Domain settings en dashboard
2. Seguir instrucciones para DNS

## ✅ Checklist Pre-Deploy

- [ ] Videos en `/assets/videos/` (clip_1.mp4 a clip_5.mp4)
- [ ] Sonido en `/assets/sounds/kill.mp3`
- [ ] `manifest.json` configurado
- [ ] Service Worker registrándose
- [ ] Todas las rutas relativas (`./` en lugar de `/`)
- [ ] `.gitignore` actualizado
- [ ] README.md completo
- [ ] Probado en localhost
- [ ] Probado en mobile viewport
- [ ] Probado offline

## 🎯 Next Steps

Después del deployment:
1. Probar instalación como PWA
2. Probar offline functionality
3. Compartir URL con usuarios
4. Monitorear errores en producción
5. Iterar basado en feedback

---

**¿Problemas?** Revisar consola de navegador y Service Worker status.
