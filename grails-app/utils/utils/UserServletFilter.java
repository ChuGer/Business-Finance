package utils;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.security.Principal;

public class UserServletFilter implements Filter {

    public void destroy() {
    }

    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        Principal principal = req.getUserPrincipal();

        if (principal != null) {
            String username = principal.getName();
            System.out.println(username);
        }

        chain.doFilter(request, response);
    }

    public void init(FilterConfig arg0) throws ServletException {
    }

}
