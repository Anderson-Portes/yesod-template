const togglePasswordButton = document.getElementById('toggle-password-btn');
const passwordInputs = document.querySelectorAll('input[type=password]');
const icon = togglePasswordButton.querySelector('i');

const togglePassword = () => {
  passwordInputs.forEach(i => i.type = i.type == "password" ? "text" : "password");
  ['bi-eye-fill', 'bi-eye-slash-fill'].forEach(c => icon.classList.toggle(c));
}

togglePasswordButton.addEventListener('click', togglePassword);