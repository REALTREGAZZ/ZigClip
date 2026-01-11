class Animations {
  static flashNeon(element, color = '#00FFD0', times = 3) {
    let count = 0;
    const interval = setInterval(() => {
      element.style.backgroundColor = color;
      setTimeout(() => {
        element.style.backgroundColor = 'transparent';
      }, 100);
      count++;
      if (count >= times) clearInterval(interval);
    }, 200);
  }

  static animateELODelta(text, color, x, y) {
    const element = document.getElementById('elo-delta');
    element.textContent = text;
    element.style.color = color;
    element.style.opacity = '1';
    
    setTimeout(() => {
      element.style.transition = 'opacity 0.3s ease-out';
      element.style.opacity = '0';
    }, 300);
  }

  static playKillSound() {
    const sound = document.getElementById('kill-sound');
    sound.currentTime = 0;
    sound.play().catch(e => console.error('Audio play error:', e));
  }
}

class ParticleSystem {
  constructor(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.particles = [];
    this.resize();
    window.addEventListener('resize', () => this.resize());
  }

  resize() {
    this.canvas.width = window.innerWidth;
    this.canvas.height = window.innerHeight;
  }

  emit(x, y, count = 15) {
    for (let i = 0; i < count; i++) {
      const angle = (Math.PI * 2 * i) / count;
      const velocity = {
        x: Math.cos(angle) * (Math.random() * 3 + 2),
        y: Math.sin(angle) * (Math.random() * 3 + 2)
      };
      
      this.particles.push({
        x, y, 
        velocity,
        life: 1,
        size: Math.random() * 3 + 2,
        color: `hsl(${Math.random() * 60 + 150}, 100%, 50%)`
      });
    }
    
    this.animate();
  }

  animate() {
    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    this.particles = this.particles.filter(p => p.life > 0);
    
    this.particles.forEach(p => {
      p.x += p.velocity.x;
      p.y += p.velocity.y;
      p.life -= 0.02;
      p.size *= 0.98;
      
      this.ctx.fillStyle = p.color;
      this.ctx.globalAlpha = p.life;
      this.ctx.beginPath();
      this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
      this.ctx.fill();
    });
    
    this.ctx.globalAlpha = 1;
    
    if (this.particles.length > 0) {
      requestAnimationFrame(() => this.animate());
    }
  }
}