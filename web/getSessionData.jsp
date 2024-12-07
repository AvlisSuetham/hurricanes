<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%
    // Obtém a sessão existente sem criar uma nova
    HttpSession sessao = request.getSession(false);

    // Prepara o JSON de resposta
    String nome = "";
    String apelido = "";
    String email = "";

    if (sessao != null) {
        email = (String) sessao.getAttribute("email");

        if (email != null) {
            Connection conecta = null;
            PreparedStatement st = null;
            ResultSet rs = null;

            try {
                // Conectando ao banco de dados
                Class.forName("com.mysql.cj.jdbc.Driver");
                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3307/banco", "Matheus", "#22m14c18m12L");

                // Consulta para obter o nome e apelido mais recentes do banco de dados
                String sql = "SELECT nome, apelido, email FROM usuarios WHERE email = ?";
                st = conecta.prepareStatement(sql);
                st.setString(1, email);
                rs = st.executeQuery();

                if (rs.next()) {
                    nome = rs.getString("nome");
                    apelido = rs.getString("apelido");
                    email = rs.getString("email");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Erro ao recuperar dados do banco: " + e.getMessage() + "</p>");
            } finally {
                // Fechar a conexão
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (conecta != null) conecta.close();
            }
        }
    }

    // Retorna as informações da sessão no formato JSON
    out.print("{");
    out.print("\"nome\": \"" + (nome != null ? nome : "") + "\",");
    out.print("\"apelido\": \"" + (apelido != null ? apelido : "") + "\",");
    out.print("\"email\": \"" + (email != null ? email : "") + "\"");
    out.print("}");
%>
