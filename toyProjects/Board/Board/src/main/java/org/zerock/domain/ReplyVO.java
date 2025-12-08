package org.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyVO {

	//댓글 번호
	private Long rno;
	//부모글 번호
	private Long bno;
	
	//댓글 내용
	private String reply;
	//작성자
	private String replyer;
	//등록일
	private Date replyDate;
	//수정일
	private Date updateDate;

}
