<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // Recupera a sessão do usuário
    HttpSession sessao = request.getSession(false); // Obtém a sessão sem criar uma nova
    if (sessao == null || sessao.getAttribute("email") == null) {
        // Redireciona para o login caso a sessão não exista
        response.sendRedirect("login.html");
        return;
    }

    String email = (String) sessao.getAttribute("email");

    Connection conecta = null;
    PreparedStatement st = null;

    try {
        // Estabelecendo a conexão com o banco de dados
        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3307/banco", "Matheus", "#22m14c18m12L");

        // Comando para deletar o usuário baseado no email
        String sql = "DELETE FROM usuarios WHERE email = ?";
        st = conecta.prepareStatement(sql);
        st.setString(1, email);

        int rowsDeleted = st.executeUpdate();

        if (rowsDeleted > 0) {
            // Usuário excluído com sucesso
            sessao.invalidate(); // Encerra a sessão
            out.println("<p style='color:green;'>Conta excluída com sucesso!</p>");
            response.setHeader("Refresh", "3;URL=login.html");
        } else {
            // Caso nenhuma linha tenha sido afetada
            out.println("<p style='color:red;'>Erro: Nenhuma conta encontrada para exclusão.</p>");
        }
    } catch (Exception e) {
        // Exibe erros relacionados à exclusão
        out.println("<p style='color:red;'>Erro ao excluir conta: " + e.getMessage() + "</p>");
    } finally {
        // Fecha a conexão com o banco de dados
        if (st != null) try { st.close(); } catch (Exception ignored) {}
        if (conecta != null) try { conecta.close(); } catch (Exception ignored) {}
    }
%>
