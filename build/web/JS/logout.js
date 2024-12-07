// Função de logout
function logout() {
    // Apaga o cookie que mantém o apelido ou dados de sessão
    document.cookie = "apelido=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "session_id=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;"; // Caso haja outro cookie de sessão

    // Se você estiver usando o localStorage ou sessionStorage, você pode limpar assim:
    // localStorage.clear();
    // sessionStorage.clear();

    // Redireciona o usuário para a página de login
    window.location.href = "login.html";  // Substitua por sua página de login desejada
}

// Adiciona o evento de clique ao botão de logout
document.addEventListener("DOMContentLoaded", () => {
    const logoutButton = document.getElementById("logout-button");
    if (logoutButton) {
        // Exibe o botão de logout apenas se o usuário estiver logado
        const userLoggedIn = document.cookie.indexOf("apelido") !== -1; // Verifique o cookie ou outro critério

        if (userLoggedIn) {
            logoutButton.style.display = "block";  // Exibe o botão
            logoutButton.addEventListener("click", logout);  // Adiciona o evento de logout
        }
    }
});
