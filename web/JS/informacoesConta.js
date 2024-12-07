document.addEventListener("DOMContentLoaded", () => {
    const nameField = document.getElementById("name");
    const nicknameField = document.getElementById("nickname");
    const emailField = document.getElementById("email");

    // Função para buscar as informações da sessão no servidor
    async function fetchSessionData() {
        try {
            const response = await fetch("getSessionData.jsp"); // Endpoint que retorna os dados da sessão
            if (response.ok) {
                const sessionData = await response.json(); // Supondo que o servidor retorna JSON
                return sessionData; // Retorna o objeto contendo as informações da sessão
            } else {
                console.error("Erro ao buscar dados da sessão:", response.statusText);
                return null;
            }
        } catch (error) {
            console.error("Erro ao realizar a requisição:", error);
            return null;
        }
    }

    // Atualiza os campos com as informações da sessão
    fetchSessionData().then(sessionData => {
        if (sessionData) {
            nameField.textContent = sessionData.nome || "Não disponível";
            nicknameField.textContent = sessionData.apelido || "Não disponível";
            emailField.textContent = sessionData.email || "Não disponível";
        } else {
            nameField.textContent = "Não disponível";
            nicknameField.textContent = "Não disponível";
            emailField.textContent = "Não disponível";
        }
    }).catch(error => {
        console.error("Erro ao processar os dados da sessão:", error);
        nameField.textContent = "Erro ao carregar";
        nicknameField.textContent = "Erro ao carregar";
        emailField.textContent = "Erro ao carregar";
    });
});
