<%@ page contentType="text/plain" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Obtém a sessão existente sem criar uma nova
    HttpSession sessao = request.getSession(false);

    if (sessao != null && sessao.getAttribute("apelido") != null) {
        // Recupera o atributo "apelido" da sessão e o retorna como texto
        out.print(sessao.getAttribute("apelido"));
    } else {
        // Retorna "not_logged_in" se a sessão ou o apelido não existirem
        out.print("not_logged_in");
    }
%>
