class Brag {
  constructor(storage, eloSystem) {
    this.storage = storage;
    this.eloSystem = eloSystem;
    this.canvas = null;
    this.ctx = null;
  }

  init() {
    this.canvas = document.getElementById('export-canvas');
    if (this.canvas) {
      this.ctx = this.canvas.getContext('2d');
      this.canvas.width = 1080;
      this.canvas.height = 1920;
    }

    const exportBtn = document.getElementById('export-btn');
    if (exportBtn) {
      exportBtn.addEventListener('click', () => this.exportStatus());
    }

    this.update();
    console.log('✅ Brag initialized');
  }

  update() {
    const userData = this.storage.getUserData();
    
    document.getElementById('brag-elo').textContent = userData.elo;
    document.getElementById('brag-wins').textContent = userData.wins;
    document.getElementById('brag-losses').textContent = userData.losses;
    
    const total = userData.wins + userData.losses;
    const winRate = total > 0 ? Math.floor((userData.wins / total) * 100) : 0;
    document.getElementById('brag-rate').textContent = `${winRate}%`;
  }

  async exportStatus() {
    if (!this.canvas || !this.ctx) {
      console.error('Canvas not available');
      return;
    }

    const userData = this.storage.getUserData();
    const tier = this.eloSystem.getTier(userData.elo);
    
    const ctx = this.ctx;
    
    const gradient = ctx.createLinearGradient(0, 0, 0, 1920);
    gradient.addColorStop(0, '#00FFD0');
    gradient.addColorStop(0.5, '#1a1a1a');
    gradient.addColorStop(1, '#050505');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, 1080, 1920);

    ctx.font = 'bold 140px Courier New';
    ctx.fillStyle = '#00FFD0';
    ctx.textAlign = 'center';
    ctx.shadowColor = 'rgba(0, 255, 208, 0.5)';
    ctx.shadowBlur = 30;
    ctx.fillText('ZIGCLIP', 540, 200);

    ctx.font = 'bold 120px Courier New';
    ctx.fillStyle = tier.color;
    ctx.shadowBlur = 40;
    ctx.shadowColor = tier.color;
    ctx.fillText(tier.name, 540, 500);

    ctx.strokeStyle = '#00FFD0';
    ctx.lineWidth = 3;
    ctx.shadowBlur = 0;
    ctx.beginPath();
    ctx.moveTo(150, 600);
    ctx.lineTo(930, 600);
    ctx.stroke();

    ctx.font = 'bold 180px Courier New';
    ctx.fillStyle = '#FFFFFF';
    ctx.shadowColor = 'rgba(0, 255, 208, 0.3)';
    ctx.shadowBlur = 20;
    ctx.fillText(`${userData.elo}`, 540, 900);

    ctx.font = '40px Courier New';
    ctx.fillStyle = '#B0B0B0';
    ctx.shadowBlur = 0;
    ctx.fillText('ELO RATING', 540, 970);

    ctx.font = '60px Courier New';
    ctx.fillStyle = '#00FF00';
    ctx.textAlign = 'left';
    ctx.fillText(`${userData.wins}W`, 200, 1150);
    
    ctx.fillStyle = '#FF3B3B';
    ctx.textAlign = 'right';
    ctx.fillText(`${userData.losses}L`, 880, 1150);

    const total = userData.wins + userData.losses;
    const rate = total > 0 ? ((userData.wins / total) * 100).toFixed(1) : 0;
    ctx.font = '50px Courier New';
    ctx.fillStyle = '#B0B0B0';
    ctx.textAlign = 'center';
    ctx.fillText(`${rate}% WIN RATE`, 540, 1300);

    ctx.font = 'bold 50px Courier New';
    ctx.fillStyle = '#00FFD0';
    ctx.fillText(`MAIN: JETT`, 540, 1500);

    ctx.strokeStyle = '#00FFD0';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(150, 1600);
    ctx.lineTo(930, 1600);
    ctx.stroke();

    const phrases = [
      '¿Crees que puedes superarme?',
      'Esta es mi clase',
      'Únete si eres lo suficiente bueno',
      'PROVE ME WRONG',
      'SKILL VALIDATED',
      'TOP TIER GAMEPLAY'
    ];
    
    ctx.font = 'italic 40px Courier New';
    ctx.fillStyle = '#FFD700';
    ctx.fillText(phrases[Math.floor(Math.random() * phrases.length)], 540, 1800);

    ctx.font = '35px Courier New';
    ctx.fillStyle = '#00FFD0';
    ctx.fillText('ENTRA EN ZIGCLIP.IO', 540, 1900);

    this.canvas.toBlob((blob) => {
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `ZIGCLIP-STATUS-${userData.elo}.png`;
      a.click();
      URL.revokeObjectURL(url);
      
      console.log('✅ Brag card exported');
    });
  }
}

export default Brag;
