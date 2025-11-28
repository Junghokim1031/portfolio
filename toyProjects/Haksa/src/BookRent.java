import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class BookRent extends JPanel {
	DefaultTableModel model=null;
	JTable table=null;
	Connection conn=null;
	
	Statement stmt;  
	String query;
	
	
	public BookRent() {
		
		setLayout(null);//레이아웃 설정 안함
		
		//학과레이블
		JLabel lblDept = new JLabel("학과");
		lblDept.setBounds(10, 10, 30, 20);
		add(lblDept);
		//학과콤보박스
		String[] dept = {"전체","컴퓨터공학","전자공학","소프트웨어공학"};
		JComboBox cbDept = new JComboBox(dept);
		cbDept.setBounds(45, 10, 100, 20);
		cbDept.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				//동적쿼리
				query="select s.id, s.name, b.title, br.rdate "
						+ " from student s, books b, bookrent br "
						+ " where s.id=br.id and b.no=br.bookno";
				
				JComboBox cb=(JComboBox)e.getSource(); //이벤트가 발생한 콤보박스 구하기
				//동적쿼리
				if(cb.getSelectedIndex()==0) {
					//전체
					query+=" order by s.id";
				}else if(cb.getSelectedIndex()==1) {
					//컴퓨터공학과
					query+=" and s.dept='컴퓨터공학' order by br.no";
				}else if(cb.getSelectedIndex()==2) {
					//경제학과
					query+=" and s.dept='전자공학' order by br.no";
				}else if(cb.getSelectedIndex()==3) {
					//소프트웨어공학
					query+=" and s.dept='소프트웨어공학' order by br.no";
				}
				//System.out.println(query);
				list();//도서대여목록메서드 호출
				
			}
		});
		add(cbDept);
		
		//테이블
		String colName[]={"학번","이름","도서명","대출일"};
	    model=new DefaultTableModel(colName,0);
	    table = new JTable(model);
	    table.setPreferredScrollableViewportSize(new Dimension(470,200));
	    add(table);
	    JScrollPane sp=new JScrollPane(table);
	    sp.setBounds(10, 40, 300, 500);
	    add(sp);
		
		
	    setSize(280,500);
		setVisible(true);
	}
	
	//도서대여목록메서드
	public void list(){
		try{
			//DB연결
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "user10", "1234");
			//System.out.println("연결완료");
			stmt=conn.createStatement();
			
			// Select문 실행     
			ResultSet rs=stmt.executeQuery(query);
		    
			//JTable 초기화
			model.setNumRows(0);
			
			while(rs.next()){
				String[] row=new String[4];//컬럼의 갯수가 4
				row[0]=rs.getString("id");
				row[1]=rs.getString("name");
				row[2]=rs.getString("title");
				row[3]=rs.getString("rdate");
				model.addRow(row);
			}
			rs.close();
		}
		catch(Exception e1){
			System.out.println(e1.getMessage());
		}							
	}
}
