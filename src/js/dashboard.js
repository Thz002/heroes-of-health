function getDate() {
    const date = new Date();
    const opts = {weekday: 'long', day: 'numeric', month: 'long', year: 'numeric'};
    const formattedDate = date.toLocaleDateString('pt-BR', opts);
    document.getElementById('welcome-message').textContent = formattedDate;
}

function logOutt() {
    document.getElementById('logout-btn').addEventListener('click', () => {
        // Esses comando removem os dados do usuário do localStorage ao fazer logout
        localStorage.removeItem('auth.users(email)');
        localStorage.removeItem('auth.users(id)');
        // redireciona o usuário para a página de login (index.html)
        window.location.href = 'index.html';
    });
}
