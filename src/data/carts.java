package data;
import dbUtil.dbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class carts {
	private static Connection con = null;
	private products product;
	private int quantity;
	
	
	public carts() {
		this.product = new products();
	}
	
	public products getProduct() {
		return product;
	}
	public void setProduct(products product) {
		this.product = product;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	
	public static void addToCart(users user, products product,int quantity) throws Exception{
		PreparedStatement pstmt=null;
		try {
			con=dbUtil.connect();
			pstmt=con.prepareStatement("INSERT INTO carts(uid,pid,quantity,price) VALUES(?,?,?,?);");
			pstmt.setInt(1, user.getId());
			pstmt.setInt(2, product.getId());
			pstmt.setInt(3, quantity);
			pstmt.setInt(4, product.getPrice());
			pstmt.executeUpdate();
		} finally {
			dbUtil.close(con, pstmt, null);
		}
	}
	
	public static ArrayList<carts> listCart(users user) throws Exception {
		if(user==null) {
			throw new Exception("no user");
		}
		ArrayList<carts> cart=null;
		try {
			con=dbUtil.connect();
			con.setAutoCommit(false);
			cart =getCart(user);
			con.commit();
		} catch(Exception e) {
			con.rollback();
			throw e;
		} finally {
			con.setAutoCommit(true);
			dbUtil.close(con, null, null);
		}
		return cart;	
	}
	
	public static void clearCart(users user) throws Exception{
		if(user==null) {
			throw new Exception("no user");
		}
		try {
			con=dbUtil.connect();
			emptyCart(user);
		} finally {
			dbUtil.close(con, null, null);
		}
	}
	
	public static ArrayList<carts> purchase(users user,String credit_card) throws Exception{
		if (user==null||!user.getRole().equals("customer")) {
			throw new Exception("Not a valid customer");
		}
		
		String regex = "[0-9]+";
		if(credit_card==null||credit_card.isEmpty()||!credit_card.matches(regex)||credit_card.length()<16||credit_card.length()>16) {
			throw new Exception("Invalid credit card number");
		}
		ArrayList<carts> cart=null;
		try {
			con = dbUtil.connect();
			con.setAutoCommit(false);
			cart = getCart(user);
			if(cart==null||cart.isEmpty()) {
				throw new Exception("Nothing to purchase");
			}
			for(carts item:cart) {
				buyItem(user,item,credit_card);
			}
			emptyCart(user);
			con.commit();
			
		} catch (Exception e) {
			con.rollback();
			throw e;
		} finally {
			con.setAutoCommit(true);
			dbUtil.close(con, null, null);
		}
		return cart;
	}
	
	
	
	private static ArrayList<carts> getCart(users user) throws Exception{
		
		ArrayList<carts> cart=new ArrayList<carts>();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs=null;
		ResultSet rs2=null;
		ResultSet rs3=null;
		pstmt=con.prepareStatement("SELECT pid,quantity,price FROM carts WHERE uid=?");
		pstmt2=con.prepareStatement("SELECT cid,name,SKU FROM products WHERE id=?");
		pstmt3=con.prepareStatement("SELECT name FROM categories WHERE id=?");
		pstmt.setInt(1, user.getId());
		try {
			rs=pstmt.executeQuery();
			while(rs.next()) {
				carts item=new carts();
				
				item.setQuantity(rs.getInt(2));
				products product = item.getProduct();
				product.setPrice(rs.getInt(3));
				product.setId(rs.getInt(1));
				pstmt2.setInt(1,rs.getInt(1));
				rs2=pstmt2.executeQuery();
				if(rs2.next()) {
					product.setCid(rs2.getInt(1));
					product.setName(rs2.getString(2));
					product.setSKU(rs2.getString(3));
				}
				pstmt3.setInt(1, product.getCid());
				rs3=pstmt3.executeQuery();
				if(rs3.next()) {
					product.setCategory(rs3.getString(1));
				}
				cart.add(item);
			}
		} finally {
			dbUtil.close(null, pstmt3, rs3);
			dbUtil.close(null, pstmt2, rs2);
			dbUtil.close(null, pstmt, rs);
		}	
		return cart;
	}
	
	private static void emptyCart(users user) throws Exception{
		PreparedStatement pstmt=null;
		try {
			pstmt=con.prepareStatement("DELETE FROM carts WHERE uid=?");
			pstmt.setInt(1, user.getId());
			pstmt.executeUpdate();
		} finally {
			dbUtil.close(null, pstmt, null);
		}
	}
	
	private static void buyItem(users user,carts item,String credit_card) throws Exception{
		PreparedStatement pstmt = null;
		PreparedStatement pstmtQ = null;
		PreparedStatement pstmtQ2 = null;
		PreparedStatement pstmtQ3 = null;
		PreparedStatement pstmtQ4 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4 = null;
		PreparedStatement pstmt2=null;
		PreparedStatement pstmt3=null;
		PreparedStatement pstmt4=null;
		PreparedStatement pstmt5=null;
		try {
			pstmt = con.prepareStatement("INSERT INTO sales(uid,pid,quantity,price) VALUES(?,?,?,?);");
			pstmt.setInt(1, user.getId());
			products product = item.getProduct();
			pstmt.setInt(2,product.getId());
			pstmt.setInt(3, item.getQuantity());
			pstmt.setInt(4, product.getPrice());
			pstmt.executeUpdate();
			
			pstmtQ = con.prepareStatement("SELECT * FROM user_product_amount WHERE uid=? AND pid=? ");
			pstmtQ.setInt(1, user.getId());
			pstmtQ.setInt(2, product.getId());
			rs=pstmtQ.executeQuery();
			if(rs.next()) {
				pstmt2 = con.prepareStatement("UPDATE user_product_amount SET amount=amount+? WHERE uid=? AND pid=?");
				
			} else {
				pstmt2 = con.prepareStatement("INSERT INTO user_product_amount(amount,uid,pid) VALUES(?,?,?)");
			}
			pstmt2.setInt(1, product.getPrice()*item.getQuantity());
			pstmt2.setInt(2, user.getId());
			pstmt2.setInt(3, product.getId());
			pstmt2.executeUpdate();
			
			pstmtQ2 = con.prepareStatement("SELECT * FROM state_product_amount WHERE state=? AND pid=?");
			pstmtQ2.setString(1,user.getState());
			pstmtQ2.setInt(2, product.getId());
			rs2 = pstmtQ2.executeQuery();
			if(rs2.next()) {
				pstmt3 = con.prepareStatement("UPDATE state_product_amount SET amount=amount+? "
						+ "WHERE state=? AND pid=?");
			} else {
				pstmt3 = con.prepareStatement("INSERT INTO state_product_amount(amount,state,pid) VALUES(?,?,?)");
			}
			pstmt3.setInt(1, product.getPrice()*item.getQuantity());
			pstmt3.setString(2, user.getState());
			pstmt3.setInt(3, product.getId());
			pstmt3.executeUpdate();
			
			
			pstmtQ3 = con.prepareStatement("SELECT * FROM user_category_amount WHERE uid=? AND cid=?");
			pstmtQ3.setInt(1,user.getId());
			pstmtQ3.setInt(2, product.getCid());
			rs3 = pstmtQ3.executeQuery();
			if(rs3.next()) {
				pstmt4 = con.prepareStatement("UPDATE user_category_amount SET amount=amount+? "
						+ "WHERE uid=? AND cid=?");
			} else {
				pstmt4 = con.prepareStatement("INSERT INTO user_category_amount(amount,uid,cid) VALUES(?,?,?)");
			}
			pstmt4.setInt(1, product.getPrice()*item.getQuantity());
			pstmt4.setInt(2, user.getId());
			pstmt4.setInt(3, product.getCid());
			pstmt4.executeUpdate();
			
			pstmtQ4 = con.prepareStatement("SELECT * FROM state_category_amount WHERE state=? AND cid=?");
			pstmtQ4.setString(1,user.getState());
			pstmtQ4.setInt(2, product.getCid());
			rs4= pstmtQ4.executeQuery();
			if(rs4.next()) {
				pstmt5 = con.prepareStatement("UPDATE state_category_amount SET amount=amount+? "
						+ "WHERE state=? AND cid=?");
			} else {
				pstmt5 = con.prepareStatement("INSERT INTO state_category_amount(amount,state,cid) VALUES(?,?,?)");
			}
			pstmt5.setInt(1, product.getPrice()*item.getQuantity());
			pstmt5.setString(2, user.getState());
			pstmt5.setInt(3, product.getCid());
			pstmt5.executeUpdate();
		} finally {
			dbUtil.close(con, pstmtQ, rs);
			dbUtil.close(null, pstmtQ2, rs2);
			dbUtil.close(null, pstmtQ3, rs3);
			dbUtil.close(null, pstmtQ3, rs3);
			dbUtil.close(null, pstmtQ4, rs4);
			dbUtil.close(null, pstmt, null);
			dbUtil.close(null, pstmt2, null);
			dbUtil.close(null,pstmt3,null);
			dbUtil.close(null, pstmt4, null);
			dbUtil.close(null, pstmt5, null);
		}
	}
	
}
