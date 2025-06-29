/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tuonglh.registration;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import tuonglh.utils.DBHeper;

/**
 *
 * @author USER
 */
public class RegistrationDAO {
    public RegistrationDTO checkLogin(String username , String password)
    throws SQLException, ClassNotFoundException
    {
        RegistrationDTO result = null;
        //B1 Connect DB
        Connection con = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try{
            con = DBHeper.makeConnection();
            //2.1 Make query 
            String query = "Select * "
                    + "From Registration "
                    + "Whrere username = ? ,"
                    + "password = ? ";
            
            //2.2 set statement to query
            stm = con.prepareCall(query);
            stm.setString(1, username);
            stm.setString(2, password);
            //2.3 process 
            rs = stm.executeQuery();
        }finally{
            if(rs != null){
                rs.close();
            }
            if(stm != null){
                stm.close();
            }
            if(con != null){
                con.close();
            }
        }
        
        return result;
    }
}
