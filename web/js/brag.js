class BragService {
  static updateBragDisplay() {
    const profile = StorageService.loadProfile();
    const clips = StorageService.loadClips();
    const totalPlayers = clips.length + 1; // +1 for user
    
    // Update stats
    document.getElementById('brag-elo').textContent = profile.elo;
    
    const totalGames = profile.wins + profile.losses;
    const winRate = totalGames > 0 ? Math.round((profile.wins / totalGames) * 100) : 0;
    document.getElementById('brag-winrate').textContent = `${winRate}%`;
    document.getElementById('brag-wins').textContent = profile.wins;
    document.getElementById('brag-losses').textContent = profile.losses;
    
    // Calculate rank and badge
    const rank = ELOCalculator.getRank(profile.elo, totalPlayers);
    const badge = ELOCalculator.getBadge(profile.elo, totalPlayers);
    const percentile = ELOCalculator.getPercentile(rank, totalPlayers);
    
    const badgeElement = document.getElementById('brag-badge');
    badgeElement.textContent = badge.name;
    badgeElement.style.backgroundColor = badge.color;
    
    document.getElementById('brag-percentile').textContent = `TOP ${percentile}%`;
    
    // Setup export button
    document.getElementById('export-status-btn').addEventListener('click', () => {
      BragService.exportStatusAsImage();
    });
  }

  static exportStatusAsImage() {
    const canvas = document.getElementById('status-canvas');
    canvas.width = 1080;
    canvas.height = 1920;
    const ctx = canvas.getContext('2d');
    
    const profile = StorageService.loadProfile();
    const badge = ELOCalculator.getBadge(profile.elo, 100);
    const rank = ELOCalculator.getRank(profile.elo, 100);
    const percentile = ELOCalculator.getPercentile(rank, 100);
    
    // Background gradient
    const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
    gradient.addColorStop(0, '#050505');
    gradient.addColorStop(1, '#001110');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    
    // Glassmorphism overlay
    ctx.fillStyle = 'rgba(0, 255, 208, 0.05)';
    ctx.fillRect(50, 50, canvas.width - 100, canvas.height - 100);
    
    // Logo
    ctx.fillStyle = '#00FFD0';
    ctx.font = 'bold 48px Courier New';
    ctx.textAlign = 'center';
    ctx.fillText('ZIGCLIP', canvas.width / 2, 100);
    
    // Badge
    ctx.fillStyle = badge.color;
    ctx.beginPath();
    ctx.arc(canvas.width / 2, canvas.height / 2 - 100, 120, 0, Math.PI * 2);
    ctx.fill();
    
    ctx.fillStyle = '#050505';
    ctx.font = 'bold 48px Courier New';
    ctx.textAlign = 'center';
    ctx.fillText(badge.name, canvas.width / 2, canvas.height / 2 - 80);
    
    // Stats
    ctx.fillStyle = '#00FFD0';
    ctx.font = 'bold 72px Courier New';
    ctx.textAlign = 'center';
    ctx.fillText(`RANK #${rank}`, canvas.width / 2, canvas.height / 2 + 50);
    ctx.fillText(`${profile.elo} ELO`, canvas.width / 2, canvas.height / 2 + 130);
    
    // Percentile phrase
    let phrase = 'Grinding every day';
    if (percentile <= 1) phrase = "Don't even try to peak me";
    else if (percentile <= 3) phrase = 'Untouchable';
    else if (percentile <= 10) phrase = 'Rising to the top';
    
    ctx.fillStyle = '#B0B0B0';
    ctx.font = 'italic 36px Courier New';
    ctx.textAlign = 'center';
    ctx.fillText(phrase, canvas.width / 2, canvas.height / 2 + 220);
    
    // QR Code
    const qrSize = 150;
    const qrX = canvas.width - qrSize - 50;
    const qrY = canvas.height - qrSize - 50;
    
    // Generate QR code data
    const qrData = `ZIGCLIP:${profile.username}:${profile.elo}:${rank}`;
    
    // Use our QR code generator
    const qrCanvas = QRCode.generate(qrData, qrSize);
    ctx.drawImage(qrCanvas, qrX, qrY, qrSize, qrSize);
    
    ctx.fillStyle = '#B0B0B0';
    ctx.font = '18px Courier New';
    ctx.textAlign = 'center';
    ctx.fillText('PROVE ME WRONG', qrX + qrSize / 2, qrY + qrSize + 30);
    
    // Convert to image and download
    canvas.toBlob((blob) => {
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'zigclip-status.png';
      a.click();
      URL.revokeObjectURL(url);
    });
  }
}