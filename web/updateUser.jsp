<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Dados enviados pelo formulário
    String nome = request.getParameter("name");
    String apelido = request.getParameter("nickname");
    String email = request.getParameter("email");
    String senha = request.getParameter("password");

    // Obtendo o usuário logado da sessão
    String currentEmail = (String) session.getAttribute("email");

    if (currentEmail == null) {
        // Usuário não logado
        response.sendRedirect("login.html");
        return;
    }

    // Criptografar a senha antes de atualizar
    String senhaCriptografada = null;
    if (senha != null && !senha.isEmpty()) { // Se a senha foi alterada
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
    }

    Connection conecta = null;
    PreparedStatement st = null;

    try {
        // Conectando ao banco de dados
        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3307/banco", "Matheus", "#22m14c18m12L");

        // Atualizando os dados do usuário no banco de dados
        String sql = "UPDATE usuarios SET nome = ?, apelido = ?, email = ?, senha = ? WHERE email = ?";
        st = conecta.prepareStatement(sql);
        st.setString(1, nome);       // Atualiza o nome completo
        st.setString(2, apelido);    // Atualiza o apelido
        st.setString(3, email);      // Atualiza o email

        // Se a senha foi alterada, atualiza a senha criptografada
        if (senhaCriptografada != null) {
            st.setString(4, senhaCriptografada);  // Atualiza a senha criptografada
        } else {
            // Se a senha não foi alterada, utiliza a senha atual do banco (não modifica)
            // Não é necessário fazer nada aqui porque a senha permanecerá a mesma
            st.setString(4, senha);  // Mantém a senha anterior caso não tenha sido alterada
        }

        st.setString(5, currentEmail); // Condição para atualizar o usuário correto

        int rowsUpdated = st.executeUpdate();

        if (rowsUpdated > 0) {
            // Atualização bem-sucedida
            session.setAttribute("email", email);    // Atualiza o email na sessão
            session.setAttribute("apelido", apelido); // Atualiza o apelido na sessão
            out.println("<p>Informações atualizadas com sucesso!</p>");
            response.sendRedirect("informacoesConta.html");  // Redireciona para a página de informações
        } else {
            // Falha ao atualizar
            out.println("<p>Erro ao atualizar as informações. Tente novamente.</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
    } finally {
        if (st != null) try { st.close(); } catch (SQLException ignored) {}
        if (conecta != null) try { conecta.close(); } catch (SQLException ignored) {}
    }
%>
