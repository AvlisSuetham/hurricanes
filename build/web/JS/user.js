document.addEventListener('DOMContentLoaded', function () {
    // Função para obter o apelido da sessão via requisição ao servidor
    async function getSessionApelido() {
        try {
            const response = await fetch('getSessionApelido.jsp'); // Página JSP que retorna o apelido da sessão
            if (response.ok) {
                const apelido = await response.text();
                return apelido.trim(); // Remove espaços extras
            } else {
                console.error('Erro ao obter o apelido da sessão:', response.statusText);
                return null;
            }
        } catch (error) {
            console.error('Erro ao realizar a requisição:', error);
            return null;
        }
    }

    // Elementos da interface
    const loginButton = document.getElementById('login-button');
    const signupButton = document.getElementById('signup-button');
    const logoutButton = document.getElementById('logout-button');
    const userApelido = document.getElementById('user-apelido');
    const userNickname = document.getElementById('user-nickname');
    const configButton = document.getElementById('config-button');

    // Obtém o apelido da sessão e atualiza a interface
    getSessionApelido().then(apelido => {
        console.log('Apelido da sessão:', apelido); // Verifique se o apelido está sendo obtido corretamente

        if (apelido && apelido !== 'not_logged_in') {
            // Usuário logado, exibe apelido, botão de logout e configurações; esconde login e cadastro
            userApelido.style.display = 'block';
            userNickname.textContent = apelido;
            loginButton.style.display = 'none';
            signupButton.style.display = 'none';
            logoutButton.style.display = 'inline-block';
            configButton.style.display = 'inline-block'; // Exibe o botão de configurações

            console.log('Botão de configurações será exibido.'); // Depuração

            // Adiciona evento de clique no botão de configurações
            configButton.addEventListener('click', function () {
                window.location.href = 'informacoesConta.html'; // Redireciona para a página de configurações
            });
        } else {
            // Usuário não logado, exibe botões de login e cadastro; esconde o apelido, logout e configurações
            console.log('Usuário não logado. Botões de login e cadastro serão exibidos.'); // Depuração

            userApelido.style.display = 'none';
            loginButton.style.display = 'inline-block';
            signupButton.style.display = 'inline-block';
            logoutButton.style.display = 'none';
            configButton.style.display = 'none';
        }
    });
});
