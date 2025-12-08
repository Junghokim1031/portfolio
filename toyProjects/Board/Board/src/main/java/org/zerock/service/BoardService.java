package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardService {

	// 목록
	public List<BoardVO> getList();
	public List<BoardVO> getList(Criteria cri);
		// Paging을 위한 getTotal (전체 글수)
		public int getTotal(Criteria cri);

	// 등록
	public void register(BoardVO board);

	// 상세보기 및 수정화면
	public BoardVO get(Long bno);
	
	// 수정 처리
	public boolean modify(BoardVO board);
	
	// 삭제
	public boolean remove(Long bno);
	
	
	//첨부파일 끌고오기
	public List<BoardAttachVO> getAttachList(Long bno);
	//public void removeAttach(Long bno);
}
