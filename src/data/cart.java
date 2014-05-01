package data;
import dbUtil.dbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class cart {
	private static Connection con = null;

	public static ArrayList<products> getCart(users user) throws Exception{
		if(user==null) {
			throw new Exception("no user");
		}
		ArrayList<products> productsList=new ArrayList<products>();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2=null;
		PreparedStatement pstmt3=null;
		ResultSet rs=null;
		ResultSet rs2=null;
		ResultSet rs3=null;
		try {
			con=dbUtil.connect();
			con.setAutoCommit(false);
			pstmt=con.prepareStatement("SELECT SKU,amount FROM cart WHERE user_id=?");
			pstmt2=con.prepareStatement("SELECT name,category_id,price FROM products WHERE SKU=?");
			pstmt3=con.prepareStatement("SELECT name FROM categories WHERE id=?");
			pstmt.setInt(1, user.getId());
			rs=pstmt.executeQuery();
			while(rs.next()) {
				products product=new products();
				product.setSKU(rs.getString(1));
				product.setNum(rs.getInt(2));
				pstmt2.setString(1,rs.getString(1));
				rs2=pstmt2.executeQuery();
				if(rs2.next()) {
					product.setName(rs2.getString(1));
					product.setCategory_id(rs2.getInt(2));
					product.setPrice(rs2.getInt(3));
				}
				pstmt3.setInt(1, product.getCategory_id());
				rs3=pstmt3.executeQuery();
				if(rs3.next()) {
					product.setCategory(rs3.getString(1));
				}
				productsList.add(product);
			}
			con.commit();
		} catch(Exception e) {
			con.rollback();
			throw e;
		} finally {
			con.setAutoCommit(true);
			dbUtil.close(null, pstmt3, rs3);
			dbUtil.close(null, pstmt2, rs2);
			dbUtil.close(con, pstmt, rs);
		}
		return productsList;
	}
	public static void emptyCart(users user) throws Exception{
		if(user==null) {
			throw new Exception("no user");
		}
		PreparedStatement pstmt=null;
		try {
			con=dbUtil.connect();
			pstmt=con.prepareStatement("DELETE FROM cart WHERE user_id=?");
			pstmt.setInt(1, user.getId());
			pstmt.executeUpdate();
		} finally {
			dbUtil.close(con, pstmt, null);
		}
	}
	public static void addToCart(products product,ArrayList<products> productsList,users user) throws Exception{
		PreparedStatement pstmt=null;
		boolean flag=false;
		try {
			con=dbUtil.connect();
			for(products prod:productsList) {
				if(prod.getSKU().equals(product.getSKU())) {
					pstmt=con.prepareStatement("UPDATE cart SET amount=? WHERE user_id=? AND SKU=?");
					pstmt.setInt(1, product.getNum());
					pstmt.setInt(2, user.getId());
					pstmt.setString(3, product.getSKU());
					pstmt.executeUpdate();
					flag=true;
					break;
				}
			}
			if (!flag) {
				pstmt=con.prepareStatement("INSERT INTO cart(user_id,SKU,amount) VALUES(?,?,?)");
				pstmt.setInt(1, user.getId());
				pstmt.setString(2, product.getSKU());
				pstmt.setInt(3, product.getNum());
				pstmt.executeUpdate();
			}
		} finally {
			dbUtil.close(con, pstmt, null);
		}
	}
	

	public static ArrayList<products> purchase(users user,ArrayList<products> productsList,String credit_card) throws Exception{
		PreparedStatement pstmt = null;
		if (user==null||!user.getRole().equals("customer")) {
			throw new Exception("Not a valid customer");
		}
		if(productsList==null||productsList.isEmpty()) {
			throw new Exception("Nothing to purchase");
		}
		String regex = "[0-9]+";
		if(credit_card==null||credit_card.isEmpty()||!credit_card.matches(regex)||credit_card.length()<16||credit_card.length()>16) {
			throw new Exception("Invalid credit card number");
		}
		try {
			con = dbUtil.connect();
			con.setAutoCommit(false);
			pstmt = con.prepareStatement("INSERT INTO purchase(customer_id,SKU,price,amount,credit_card,timeStamp) VALUES(?,?,?,?,?,CURRENT_TIMESTAMP);");
			pstmt.setInt(1, user.getId());
			pstmt.setString(5, credit_card);
			for(products product:productsList) {
				pstmt.setString(2, product.getSKU());
				pstmt.setInt(3, product.getPrice());
				pstmt.setInt(4, product.getNum());
				pstmt.executeUpdate();
			}
			con.commit();
			pstmt.close();
		} catch (Exception e) {
			con.rollback();
			throw e;
		} finally {
			con.setAutoCommit(true);
			dbUtil.close(con, pstmt, null);
		}
		return productsList;
	}
	
}
