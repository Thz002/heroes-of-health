// ── Toggle senha ────────────────────────────
    const passInput  = document.getElementById('password');
    const toggleBtn  = document.getElementById('toggle-pass');
    const eyeOpen    = document.getElementById('eye-open');
    const eyeClosed  = document.getElementById('eye-closed');

    toggleBtn.addEventListener('click', () => {
      const visible = passInput.type === 'text';
      passInput.type = visible ? 'password' : 'text';
      eyeOpen.style.display   = visible ? ''     : 'none';
      eyeClosed.style.display = visible ? 'none' : '';
      toggleBtn.setAttribute('aria-label', visible ? 'Mostrar senha' : 'Ocultar senha');
    });

    // ── Alerta ──────────────────────────────────
    function showAlert(message, type) {
      const el = document.getElementById('form-alert');
      el.textContent = message;
      el.className = `form-alert show ${type}`;
      if (type === 'success') setTimeout(() => el.classList.remove('show'), 3500);
    }

    function hideAlert() {
      document.getElementById('form-alert').classList.remove('show');
    }

    // ── Loading state ───────────────────────────
    function setLoading(on) {
      const btn   = document.getElementById('submit-btn');
      const label = document.getElementById('btn-label');
      const spin  = document.getElementById('btn-spin');
      btn.disabled       = on;
      label.textContent  = on ? 'Entrando...' : 'Entrar no Jogo';
      spin.style.display = on ? 'block'       : 'none';
    }

    // ── Validação ───────────────────────────────
    function validate(email, password) {
      if (!email.trim())                              return 'Informe seu e-mail.';
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return 'E-mail inválido.';
      if (!password)                                  return 'Informe sua senha.';
      if (password.length < 6)                       return 'A senha deve ter pelo menos 6 caracteres.';
      return null;
    }

    // ── Submit ──────────────────────────────────
    document.getElementById('login-form').addEventListener('submit', async (e) => {
      e.preventDefault();
      hideAlert();

      const email    = document.getElementById('email').value;
      const password = document.getElementById('password').value;
      const error    = validate(email, password);

      if (error) { showAlert(error, 'error'); return; }

      setLoading(true);

      try {
        // Integração com auth.js se disponível, senão simula
        if (typeof AUTH !== 'undefined') {
          const result = await AUTH.login(email, password);
          if (result.ok) {
            showAlert('Bem-vindo, Herói! 🎉', 'success');
            setTimeout(() => { window.location.href = 'mapa.html'; }, 1100);
          } else {
            showAlert(result.message || 'E-mail ou senha incorretos.', 'error');
          }
        } else {
          // Simulação standalone
          await new Promise(r => setTimeout(r, 1600));
          showAlert('Bem-vindo, Herói! 🎉', 'success');
          // setTimeout(() => { window.location.href = 'mapa.html'; }, 1100);
        }
      } catch (_) {
        showAlert('Erro ao conectar. Verifique sua internet.', 'error');
      } finally {
        setLoading(false);
      }
    });

    // ── Esqueci senha ───────────────────────────
    document.getElementById('forgot-btn').addEventListener('click', () => {
      const email = document.getElementById('email').value.trim();
      if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        showAlert('Digite seu e-mail primeiro para recuperar a senha.', 'error');
        document.getElementById('email').focus();
        return;
      }
      showAlert(`Link de recuperação enviado para ${email}!`, 'success');
    });

    // ── Criar conta ─────────────────────────────
    document.getElementById('register-btn').addEventListener('click', () => {
      // Redirecionar para página de registro (se existir)
      // window.location.href = 'register.html';
      showAlert('Página de registro em breve!', 'success');
    });