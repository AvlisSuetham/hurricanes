<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html> 
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cadastro de Usuário</title>
    </head>
    <body>
        <%
        // Receber os dados digitados no formulário cadpro.html
        String nome, apelido, email, senha;
        
        nome = request.getParameter("nome");
        apelido = request.getParameter("apelido");
        email = request.getParameter("email");
        senha = request.getParameter("password");

        // Criptografar a senha usando SHA-256
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

        try {
            // Realizar a Conexão com o Banco de dados
            Class.forName("com.mysql.cj.jdbc.Driver");
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3307/banco", "Matheus", "#22m14c18m12L");

            // Inserir os dados na tabela
            st = conecta.prepareStatement("INSERT INTO usuarios (nome, apelido, email, senha) VALUES (?, ?, ?, ?)");
            st.setString(1, nome);
            st.setString(2, apelido);
            st.setString(3, email);
            st.setString(4, senhaCriptografada); // Salvar a senha criptografada
            st.executeUpdate(); // Executar o comando de inserção

            // Redirecionar para login.html com parâmetro de sucesso
            response.sendRedirect("login.html?success=1");

        } catch (Exception x) {
            // Exibir erros caso aconteçam
            out.print("Erro: " + x.getMessage());
        } finally {
            // Fechar a conexão com o banco de dados
            try {
                if (conecta != null) {
                    conecta.close();
                }
                if (st != null) {
                    st.close();
                }
            } catch (Exception e) {
                out.print("Erro ao fechar a conexão: " + e.getMessage());
            }
        }
        %>
    </body>
</html>
