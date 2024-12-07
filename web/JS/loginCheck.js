// Função para obter o valor de um cookie pelo nome
function getCookie(name) {
    let matches = document.cookie.match(new RegExp(
        "(?:^|; )" + name.replace(/([.$?*|{}()[]\+^])/g, '\\$1') + "=([^;]*)"
    ));
    return matches ? decodeURIComponent(matches[1]) : undefined;
}

// Verificar o apelido do usuário, por exemplo, se estiver armazenado em um cookie
const apelido = getCookie('apelido');  // Considerando que o apelido foi armazenado em um cookie

if (apelido) {
    // Se o apelido existe, mostra o apelido, esconde os botões de login e cadastro, e mostra o logout
    document.getElementById('user-apelido').style.display = 'block';
    document.getElementById('user-nickname').textContent = apelido;
    document.getElementById('login-button').style.display = 'none';
    document.getElementById('signup-button').style.display = 'none';
    document.getElementById('logout-button').style.display = 'block';
} else {
    // Se não estiver logado, esconde o apelido e mostra os botões de login e cadastro
    document.getElementById('user-apelido').style.display = 'none';
    document.getElementById('login-button').style.display = 'block';
    document.getElementById('signup-button').style.display = 'block';
    document.getElementById('logout-button').style.display = 'none';
}

// Lógica para o botão de logout
document.getElementById('logout-button').addEventListener('click', function() {
    // Redirecionar para a página de logout ou apagar o cookie do apelido
    document.cookie = 'apelido=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/';  // Apagar o cookie
    window.location.href = 'logout.html';  // Redirecionar para a página de logout
});

