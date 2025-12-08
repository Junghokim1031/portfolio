package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {

	//I finished ReplyVO, so I came to make Mapper
	//After this, we go to src/main/resources/.../Mapper.xml
	
	//등록 Create
	public int insert(ReplyVO vo);

	//상세보기
	public ReplyVO read(Long bno);

	//삭제
	public int delete(Long bno);
	
	public int deleteAll(Long bno);

	//수정
	public int update(ReplyVO reply);

	//목록 with Paging
	public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long bno);

	//댓글 갯수
	public int getCountByBno(Long bno);
	
}
