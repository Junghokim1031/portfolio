import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;

public class Book extends JFrame{
	//==================================================================================
	// 전역변수
	//==================================================================================		
	private JTextField tfId = null;
	private JTextField tfTitle = null;
	private JTextField tfAuthor = null;
	
	//==================================================================================
	// Table
	//==================================================================================		
	private DefaultTableModel model = null;
	private JTable table = null;
	private Connection con = null;
	private Statement stmt = null;
	private ResultSet rs = null;
	
	//==================================================================================
	// Table Buttons
	//==================================================================================		
	private JButton btnInsert = null; // 추가 C
	private JButton btnSelect = null; // 목록 R
	private JButton btnUpdate = null; // 수정 U
	private JButton btnDelete = null; // 삭제 D
	
	//==================================================================================
	// Search Buttons
	//==================================================================================		
	private JButton btnSearch = null;

	public Book() {
		//==================================================================================
		// Layout 생성
		//==================================================================================		
		setLayout(new FlowLayout());
		
		//==================================================================================
		// JTextField 생성
		//==================================================================================		
		// 책 ID
		add(new JLabel("책ID"));
		tfId = new JTextField(20);
		add(tfId);
		
		// 책 제목
		add(new JLabel("제목"));
		tfTitle = new JTextField(20);
		add(tfTitle);
		
		// 책 저자
		add(new JLabel("저자"));
		tfAuthor = new JTextField(20);
		add(tfAuthor);
		
		// 책 검색
		btnSearch = new JButton("검색");
		add(btnSearch);
		
		//==================================================================================
		// TABLE 생성
		//==================================================================================		
		// 테이블 컬럼명 Table column names
		String[] colNames = {"책 ID","제목","저자"};
		// 테이블 모델 생성 Table Model 생성
		model = new DefaultTableModel(colNames,0);
		table = new JTable(model); 
		// 테이블 크기 지정
		table.setPreferredScrollableViewportSize(new java.awt.Dimension(250,270)); 
		// 테이블 삽입
		JScrollPane scrollPane = new JScrollPane(table); 
		add(scrollPane);
		
		//==================================================================================
		// Button 생성
		//==================================================================================		
		//----------------------------------------------------------------------------------
		// 책 추가
		//----------------------------------------------------------------------------------		
		btnInsert = new JButton("책 추가");
		btnInsert.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				String id = tfId.getText();
				tfId.setText("");
				String title = tfTitle.getText();
				tfTitle.setText("");
				String author = tfAuthor.getText();
				tfAuthor.setText("");
				
				String query = "INSERT INTO BOOKS VALUES(BOOKNO.NEXTVAL,"+title+","+ author+ ")";
				System.out.println(query);
//				
//				try {
//					Class.forName("oracle.jdbc.driver.OracleDriver");
//					con = DriverManager.getConnection(
//							"jdbc:oracle:thin:@192.168.219.154:1521:xe", 
//							"user10", 
//							"1234"
//					);
//					stmt = con.createStatement();
//					stmt.executeUpdate(query);
//					stmt.close();
//					con.close();
//				} catch (Exception e1) {
//					// TODO Auto-generated catch block
//					e1.printStackTrace();
//				}	
			}
		});
		add(btnInsert);
		//----------------------------------------------------------------------------------
		// 책 검색
		//----------------------------------------------------------------------------------		
		btnSelect = new JButton("책 검색");
		btnSelect.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				renewList();
			}
		});
		add(btnSelect);
		
		
		//==================================================================================
		// JPanel 생성
		//==================================================================================		
		setSize(280,500);
		setVisible(true);

	}
	//==================================================================================
	// Helper Methods
	//==================================================================================		
	//----------------------------------------------------------------------------------
	// Refresh List
	//----------------------------------------------------------------------------------		
	private void renewList() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			con = DriverManager.getConnection(
					"jdbc:oracle:thin:@192.168.219.154:1521:xe", 
					"user10", 
					"1234"
			);
			stmt = con.createStatement();
			rs = stmt.executeQuery("SELECT * FROM BOOKS ORDER BY NO");
			
			while(rs.next()) {
				String [] row = new String[3];
				row[0] = rs.getString("NO");
				row[1] = rs.getString("TITLE");
				row[2] = rs.getString("AUTHOR");
				model.addRow(row);
			}
			
			rs.close();
			stmt.close();
			con.close();
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}	
	}
	
	public static void main(String[] args) {
		new Book();
	}
}
