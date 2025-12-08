package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class BoardServiceImpl implements BoardService{

	@Setter(onMethod_ = @Autowired) //if Lombok
	//@Autowired if Spring
	//@Inject if Java
	private BoardMapper mapper; //주입
	
	@Setter(onMethod_ = @Autowired) 
	private BoardAttachMapper attachMapper;
	
	
	@Override // also overloading
	public List<BoardVO> getList(Criteria cri) {
		// Using Board Mapper!
		return mapper.getListWithPaging(cri);
	}
	
	
	@Override 
	public List<BoardVO> getList() {
		return mapper.getList(); //mapper의 getList()호출 
	}
	
	
	
	@Transactional
	@Override
	public void register(BoardVO board) {

		//regular Insert
		//mapper.insert(board);
		
		//Insert with ability to get BNO from db 
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <=0) {
			return;
		}
		
		board.getAttachList().forEach(attach->{
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
		
	}

	@Override
	public BoardVO get(Long bno) {
		
		return mapper.read(bno);
	}

	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		
		log.info("modified Board: " + board);
		
		// Delete everything that is currently attached
		attachMapper.deleteAll(board.getBno());
		
		// maper.update(board) == 1 when something has been modified on the board
		// If this is not successful, it means update has failed, so next one doesn't trigger
		// With @Transactional, if it fails, rolls back everything.
		boolean modifyResult = mapper.update(board)==1;
		
		// If modified (successfully) and there are any attachments
		if(modifyResult && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach-> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		//returns 1 if board has been updated successfully
		// else return 0, which will indicate modify was false (Not modified)
		return mapper.update(board) == 1;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		attachMapper.deleteAll(bno);
		return mapper.delete(bno)==1;
	}

	@Override
	public int getTotal(Criteria cri) {
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		return attachMapper.findByBno(bno);
	}
}
