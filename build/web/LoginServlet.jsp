<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <form action="LoginServlet.jsp" method="POST">
        <input type="email" name="email" placeholder="E-mail" required>
        <input type="password" name="senha" placeholder="Senha" required>
        <button type="submit">Entrar</button>
    </form>
    <p>Não tem uma conta? <a href="register.html">Cadastre-se</a></p>

    <%
        // Verifica se o método é POST
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Recebe os dados do formulário
            String email = request.getParameter("email");
            String senha = request.getParameter("senha");

            // Criptografar a senha recebida
            String senhaCriptografada = null;
            try {
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                md.update(senha.getBytes());
                byte[] byteData = md.digest();
                StringBuilder sb = new StringBuilder();
                for (byte b : byteData) {
                    sb.append(String.format("%02x", b));
                }
                senhaCriptografada = sb.toString();  // Senha criptografada em formato hexadecimal
            } catch (NoSuchAlgorithmException e) {
                out.print("Erro ao criptografar a senha: " + e.getMessage());
                return; // Retorna para evitar execução adicional em caso de erro
            }

            Connection conecta = null;
            PreparedStatement st = null;
            ResultSet rs = null;

            try {
                // Estabelecendo a conexão com o banco de dados
                Class.forName("com.mysql.cj.jdbc.Driver");
                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3307/banco", "Matheus", "#22m14c18m12L");

                // Consulta para verificar se o usuário existe no banco
                String sql = "SELECT * FROM usuarios WHERE email = ? AND senha = ?";
                st = conecta.prepareStatement(sql);
                st.setString(1, email);
                st.setString(2, senhaCriptografada);  // Usa a senha criptografada para comparação

                // Executa a consulta
                rs = st.executeQuery();

                // Verifica se o usuário foi encontrado
                if (rs.next()) {
                    // Recupera as informações do usuário
                    String nome = rs.getString("nome");
                    String apelido = rs.getString("apelido");

                    // Cria uma sessão para o usuário
                    HttpSession sessao = request.getSession();
                    sessao.setAttribute("nome", nome);
                    sessao.setAttribute("apelido", apelido);
                    sessao.setAttribute("email", email);

                    // Define o tempo de inatividade da sessão (em segundos)
                    sessao.setMaxInactiveInterval(60 * 60 * 24);

                    // Redireciona para a página inicial (index.html)
                    response.sendRedirect("index.html");
                } else {
                    // Redireciona para login.html com mensagem de erro
                    response.sendRedirect("login.html?error=invalid");
                }

            } catch (Exception e) {
                // Exibe erro em caso de falha na conexão
                out.println("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
            } finally {
                // Fechar a conexão com o banco de dados
                try {
                    if (rs != null) rs.close();
                    if (st != null) st.close();
                    if (conecta != null) conecta.close();
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Erro ao fechar a conexão: " + e.getMessage() + "</p>");
                }
            }
        }
    %>
</body>
</html>
