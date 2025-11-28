import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JButton; //NOTE all swing class (GUI) have prefix J-
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;


//Difference between Frame and Panel is 
//the The Top bar with Name and exit button

// JPanel is like a container
public class Student extends JPanel {
	//==================================================================================
	// TextField
	// Global Variable because it will be used in multiple locations
	//==================================================================================		
	JTextField tfId = null; 	//TextField Id		(ID)
	JTextField tfName = null;  	//TextField Name	(이름)
	JTextField tfDept = null;	//TextField Dept	(학과)
	JTextField tfAddr = null;	//TextField Address	(주소)
	
	//==================================================================================
	// Table
	// Beginning of MVC - Separation of Model, View, and Controller
	// 		DefaultTableModel = Model -> Manage Data
	//		JTable = View 			  -> Manage UI
	//==================================================================================		
	DefaultTableModel model = null;
	JTable table = null;
	private static Connection con;
	
	
	//==================================================================================
	// Table Buttons
	//==================================================================================		
	JButton btnInsert = null; // 추가 C
	JButton btnSelect = null; // 목록 R
	JButton btnUpdate = null; // 수정 U
	JButton btnDelete = null; // 삭제 D
	
	//==================================================================================
	// Search Buttons
	//==================================================================================		
	JButton btnSearchId = null;
	
	//==================================================================================
    // Initialize Connection with Shutdown Hook
    //==================================================================================
    private static Connection getConnection() {
        try {
            if (con == null || con.isClosed()) {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@192.168.219.154:1521:xe", 
                    "user10", 
                    "1234"
                );
                
                // Register shutdown hook to close connection on JVM exit
                Runtime.getRuntime().addShutdownHook(new Thread() {
                    @Override
                    public void run() {
                        closeConnection();
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
    
    //==================================================================================
    // Close Connection Method
    //==================================================================================
    private static void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                System.out.println("Oracle database connection closed successfully");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

	
	private void addButtons() {
		//==================================================================================
		// JTextField 생성
		//==================================================================================		
		// Adding Label/JTextField for ID
		add(new JLabel("학번"));
		tfId = new JTextField(14);
		add(tfId);
		
		// Add Search Button
		btnSearchId = new JButton("검색");
		add(btnSearchId);
		
		// Adding Label/JTextField for Name
		add(new JLabel("이름"));
		tfName = new JTextField(20);
		add(tfName);
		
		// Adding Label/JTextField for Address
		add(new JLabel("학과"));
		tfDept = new JTextField(20);
		add(tfDept);
		
		// Adding Label/JTextField for Dept
		add(new JLabel("주소"));
		tfAddr = new JTextField(20);
		add(tfAddr);
	}
	
	private void createTable() {
		//==================================================================================
		// TABLE 생성
		//==================================================================================		
		// 테이블 컬럼명 Table column names
		String[] colNames = {"학번","이름","학과","주소"};
		// 테이블 모델 생성 Table Model 생성
		model = new DefaultTableModel(colNames,0);
		// 테이블 생성 Binding Model to View in MVC 
		table = new JTable(model); 
		// 테이블 크기 지정
		table.setPreferredScrollableViewportSize(new java.awt.Dimension(250,270)); 
		// Create scroll for scrollable vw
		JScrollPane scrollPane = new JScrollPane(table); 
		//프레임에 스크롤이 포함된 테이블 추가
		add(scrollPane); 
	}
	
	private void addClickButtons() {
		//==================================================================================
		// Table Buttons 생성
		//==================================================================================		
		// Assign Buttons
		JButton btnInsert = new JButton("등록"); //  C
		JButton btnSelect = new JButton("목록"); //  R
		JButton btnUpdate = new JButton("수정"); //  U
		JButton btnDelete = new JButton("삭제"); //  D
		
		// add Buttons
		add(btnInsert);
		add(btnSelect);
		add(btnUpdate);
		add(btnDelete);
		
		//==================================================================================
		// btnInsert Event Handler
		//==================================================================================		
		btnInsert.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e1) {
				try {  // INSERT
					Statement stmt=con.createStatement();
					stmt.executeUpdate("INSERT INTO STUDENT VALUES('" + tfId.getText() + "','"+ tfName.getText()+ "','"+ tfDept.getText() +"','"+tfAddr.getText() +"')");
					stmt.close();
				}catch(Exception e) {
					e.printStackTrace();
				}
				list();
			}
		}); // END OF CREATE/INSERT
		
		
		//==================================================================================
		// btnSelect Event Handler
		//==================================================================================		
		btnSelect.addActionListener(new ActionListener() {
			@Override // 버튼 클릭 시 호출되는 메서드 => Callback Methods
			public void actionPerformed(ActionEvent e1) {
				list();
			}
		}); // END OF SELECT
		
		
		//==================================================================================
		// btnUpdate Event Handler
		//==================================================================================		
		btnUpdate.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e1) {
				try {  //UPDATE
					Statement stmt=con.createStatement();
					stmt.executeUpdate("UPDATE STUDENT SET NAME='" + tfName.getText() + "', DEPT= '"+ tfDept.getText()+"', ADDR= '"+tfAddr.getText() +"' WHERE ID='"+ tfId.getText()+"'");
					
					stmt.close();
				}catch(Exception e) {
					e.printStackTrace();
				}
				list();
			}
		}); // END OF UPDATE
		
		
		//==================================================================================
		// btnDelete Event Handler
		//==================================================================================		
		btnDelete.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e1) {
				
				//Ask if you want to Delete
				int result = JOptionPane.showConfirmDialog(null, "삭제하시겠습니까?","삭제", JOptionPane.YES_NO_OPTION);
				System.out.println(result);
				if(result == JOptionPane.NO_OPTION) {
					list();
				}
				else if(result == JOptionPane.YES_OPTION) {					
					try {
						Statement stmt=con.createStatement(); 
						
						//Create Update statement
						stmt.executeUpdate("DELETE FROM STUDENT WHERE ID = '"+ tfId.getText()+"'");
						
						stmt.close();
					}catch(Exception e) {
						e.printStackTrace();
					}
					list();
				}
			}
		});  // END OF DELETE
		
		//==================================================================================
		// MouseListener Event Handler
		//==================================================================================		
		table.addMouseListener(new MouseListener() {
			@Override
			public void mouseClicked(MouseEvent e) {
				model = (DefaultTableModel)table.getModel();
				int row = table.getSelectedRow();
				tfId.setText((String)model.getValueAt(row, 0));
				tfName.setText((String)model.getValueAt(row, 1));
				tfDept.setText((String)model.getValueAt(row, 2));
				tfAddr.setText((String)model.getValueAt(row, 3));
			}
			public void mousePressed(MouseEvent e) {}
			public void mouseReleased(MouseEvent e) {}
			public void mouseEntered(MouseEvent e) {}
			public void mouseExited(MouseEvent e) {}
			
		}); //END OF MOUSE CLICK
		
		//==================================================================================
		// Search Event Handler
		//==================================================================================		
		btnSearchId.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if(tfId.getText().equals("")) {
					JOptionPane.showMessageDialog(null, "학번을 입력하세요", "알림",JOptionPane.ERROR_MESSAGE);
					return; // Method 종료
				}
				
				try {
					Statement stmt=con.createStatement(); 
					
					//Create SELECT statement
					ResultSet rs=stmt.executeQuery("select * from student where id = '" + tfId.getText() + "'");
					
					//Reset Table to Refresh View
					model.setRowCount(0);

					// Print Data
					while(rs.next()) {
						String [] row = new String[4];
						row[0] = rs.getString("ID");
						row[1] = rs.getString("NAME");
						row[2] = rs.getString("DEPT");
						row[3] = rs.getString("ADDR");
						model.addRow(row);
					}
					
					clearText();
					
					rs.close();
					stmt.close();
				}catch(Exception e1) {
					e1.printStackTrace();
				}	
			}
		
		});
	}
	
	private void setUp() {
		getConnection();
		addButtons();
		createTable();
		addClickButtons();
	}
	
	public Student() {
		// FlowLayout 설정
		// Maximize 하면 화면이 깨짐. 미래에 JPanel을 이용하여 고정할 계획임.
		setLayout(new FlowLayout()); // Note FlowLayout has (horizontally) center alignment 
		setUp();
		setSize(300,500);
		setVisible(true);
		list();
	}
	
	//==================================================================================
	// Updating View In defaultTable
	//==================================================================================		
	public void list() {
		try {
			Statement stmt=con.createStatement(); 
			
			//Create SELECT statement
			ResultSet rs=stmt.executeQuery("select * from student order by id");
			
			//Reset Table to Refresh View
			model.setRowCount(0);

			// Print Data
			while(rs.next()) {
				String [] row = new String[4];
				row[0] = rs.getString("ID");
				row[1] = rs.getString("NAME");
				row[2] = rs.getString("DEPT");
				row[3] = rs.getString("ADDR");
				model.addRow(row);
			}
			
			clearText();
			
			rs.close();
			stmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	//==================================================================================
	// ClearText() 
	// Technically can just be written in list();
	//==================================================================================
	private void clearText() {
		tfId.setText("");
		tfName.setText("");
		tfDept.setText("");
		tfAddr.setText("");
	}

}
