function getDate() {
    const date = new Date();
    const opts = {weekday: 'long', day: 'numeric', month: 'long', year: 'numeric'};
    const formattedDate = date.toLocaleDateString('pt-BR', opts);
    document.getElementById('welcome-message').textContent = formattedDate;
}

document.getElementById('logout-btn').addEventListener('click', () => {
      localStorage.removeItem('herois_user');
      localStorage.removeItem('herois_token');
      window.location.href = 'index.html';
    });
