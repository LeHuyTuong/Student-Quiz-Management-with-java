/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package tuonglh.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import tuonglh.registration.RegistrationDAO;
import tuonglh.registration.RegistrationDTO;

/**
 *
 * @author USER
 */
@WebServlet(name = "CheckAccountServlet", urlPatterns = {"/CheckAccountServlet"})
public class CheckAccountServlet extends HttpServlet {
    
    private final String LOGIN_PAGES = "welcome.jsp";
    private final String ERROR_PAGES ="error.html";
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGES;
        try {
            //B1 Get cookies 
            Cookie[] cookies = request.getCookies();  // Muon co duoc cookies thi phai get cookies truoc 

            Cookie recentCookies = cookies[cookies.length - 1]; //cookies luon luon thay thang login cuoi cung 

            String username = recentCookies.getName(); // lay data tu cookies , hien tai dang co name = username value = password
            String password = recentCookies.getValue();

            // da lay duoc name va value cua cookies roi gio thi login thoi 
            //Login xong roi se ra duoc trang bai thi va co Welcome username o ben phai tren 
            //B2 call dao from DAO Object 
            RegistrationDAO dao = new RegistrationDAO();
            RegistrationDTO result = dao.checkLogin(username, password);
            
            //B3 Process
            if (result != null) {
                HttpSession session = request.getSession();

                // muon hien thi phai co scope de luu tru username hien thi ra man hinh
                session.setAttribute("USER_INFO", result);
                url = LOGIN_PAGES;
            }
        } catch (SQLException ex) {
            log("SQL " + ex.getMessage());
        } catch (ClassNotFoundException ex) {
            log("Class not found " + ex.getMessage());
        } finally {
            
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
