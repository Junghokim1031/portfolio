package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardMapper {
	
	//list 목록
	public List<BoardVO> getList();
	
	//list 목록 with paging
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	//insert 등록
	public void insert(BoardVO board);
	
	//Insert + Key (BNO) Key를 찾고 등록
	//Insert를 대체함.
	public void insertSelectKey(BoardVO board);
	
	//Get 상세보기
	public BoardVO read(Long bno);
	
	//수정 처리
	public int update(BoardVO board);
	//삭제
	public int delete(Long bno);
	
	// 전체 글수
	public int getTotalCount(Criteria cri);
	
	//댓글 겟수 update
	// Param이 2개 이상인 경우, @Param이 항상 필요함.
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}
