import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.TextField;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.WindowConstants;

class Login extends JDialog{
	private TextField tfId=new TextField(10);
	private TextField tfPw=new TextField(9);
	private JButton login = new JButton("로그인");
	private JLabel lblId = new JLabel("ID");
	private JLabel lblPw = new JLabel("PW");
	
	public Login(JFrame frame, String title) {
		super(frame,title,true);//if not modal, I can access parent's window
		setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
		this.setLayout(new FlowLayout());
		this.add(lblId);
		this.add(tfId);
		this.add(lblPw);
		this.add(tfPw);
		this.add(login);
		
		login.addActionListener(e->{
			String id = tfId.getText();
			String pw = tfPw.getText();
			if(id.equals("user10") && pw.equals("1234")) {
				System.out.println("로그인되었습니다.");
				this.setVisible(false);
			}
			else {
			}
		});
		
		this.setSize(150, 150);
	}
}

public class Haksa extends JFrame{
	
	//==================================================================================
	// 전역 변수 생성
	//==================================================================================		
	private JPanel panel;  // 메뉴 별 화면이 출력되는 패널
	private Login login;
	
	
	public Haksa() {
		//==================================================================================
		// JFrame 초기화
		//==================================================================================		
		setTitle("학사관리시스템"); 
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//x버튼 누르면 프로그램 종료
		setLayout(new BorderLayout()); // BorderLayout 사용	
		
		//==================================================================================
		// 로그인 삽입
		//==================================================================================		
		login = new Login(this,"로그인");
		login.setLocationRelativeTo(null);
		login.setVisible(true);
		
		//==================================================================================
		// Panel 삽입
		//==================================================================================		
		panel = new JPanel();
		add(panel);
		panel.setLayout(new BorderLayout()); // BorderLayout 사용
	    add(panel, BorderLayout.CENTER); // CENTER에 추가
	    
	    
		//==================================================================================
		// TABLE 생성
		//==================================================================================		
		// Menu Bar
		JMenuBar menuBar = new JMenuBar();
		  
		//==================================================================================
		// Menu 삽입
		//==================================================================================		
		JMenu mStudent = new JMenu("학생관리");
		menuBar.add(mStudent);
		JMenu mBook = new JMenu("도서관리");
		menuBar.add(mBook);
		
		//==================================================================================
		// Menu Items - 학생정보 삽입
		//==================================================================================		
		JMenuItem miStudent = new JMenuItem("학생정보");
		miStudent.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				//System.out.println("학생정보");
				panel.removeAll(); //모든컴포넌트 삭제
			    panel.revalidate(); //다시 활성화
			    panel.repaint();    //다시 그리기
			    panel.add(new Student()); //화면 생성.
			    panel.setLayout(null);//레이아웃적용안함
			}
		}); // END OF miStudent ActionListener
		mStudent.add(miStudent);
		
		//==================================================================================
		// Menu Items - 대출정보 삽입
		//==================================================================================		
		JMenuItem miBookRent = new JMenuItem("대출정보");
		miBookRent.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				//System.out.println("대출정보");
				panel.removeAll(); //모든컴포넌트 삭제
			    panel.revalidate(); //다시 활성화
			    panel.repaint();    //다시 그리기
			    panel.add(new BookRent()); //화면 생성.
			    panel.setLayout(null);//레이아웃적용안함
			}
		}); // END OF miStudent ActionListener
		mBook.add(miBookRent);
		
		
		//Menu Bar 프레임에 추가
		setJMenuBar(menuBar);

		
		
		setSize(300,500);
		this.setLocationRelativeTo(null);
		setVisible(true);
  
	}
	public static void main(String[] args) {
		new Haksa();
	}

}
