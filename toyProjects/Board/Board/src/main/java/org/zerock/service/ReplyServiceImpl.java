package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {

	//Because we got @AllArgsConstructor, we don't need these
	//@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	//@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
	
	@Transactional
	@Override
	public int register(ReplyVO vo) {
		log.info("inserted reply: " + vo);
		boardMapper.updateReplyCnt(vo.getBno(), 1);
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) {
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		log.info("modified reply: " + vo);
		return mapper.update(vo);
	}

	@Transactional
	@Override
	public int remove(Long rno) {
		log.info("removed reply: " + rno);
		//BNO를 찾기 위해서는 ReplyVO가 필요함
		ReplyVO vo = mapper.read(rno);
		
		// BNO와 -1을 사용함
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.delete(rno);
	}
	
	@Transactional
	@Override
	public int removeAll(Long bno) {
		// BNO와 -1을 사용함
		boardMapper.updateReplyCnt(bno, -1);
		return mapper.deleteAll(bno);
	}
	

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		log.info("getList Successful");
		return mapper.getListWithPaging(cri, bno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		log.info("getList Successful"); 
		return new ReplyPageDTO(mapper.getCountByBno(bno),mapper.getListWithPaging(cri, bno));
	}

}
