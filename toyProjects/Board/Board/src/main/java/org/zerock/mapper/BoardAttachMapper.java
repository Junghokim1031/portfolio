package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.BoardAttachVO;

public interface BoardAttachMapper {
	//Create (CREATE)
	public void insert(BoardAttachVO vo);
	
	// List (READ)
	public List<BoardAttachVO> findByBno(Long Bno);
	
	//Delete (one) (DELETE)
	public void delete(String uuid);
	
	// Delete (all) (DELETE)
	public void deleteAll(Long bno);
	
	// 이전 파일 목록(?)
	public List<BoardAttachVO> getOldFiles();
}
