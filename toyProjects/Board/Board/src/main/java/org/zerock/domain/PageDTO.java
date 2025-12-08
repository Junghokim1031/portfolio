package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	// Starting page the block
	// If 1 ~ 10, 1
	private int startPage;
	// Last page of the block
	// If 1 ~ 10, 10
	private int endPage;
	// prev and next block
	// If 11 ~ 20 
	// 1~10 for prev & 21~30 for next  
	private boolean prev, next;
	// Total num of pages
	private int total;
	// Criteria object
	private Criteria cri;
	
	
	public PageDTO(Criteria cri, int total) {

		this.cri = cri;
		this.total = total;
		
		// Last page of the block
		this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;
		
		// Starting page the block
		this.startPage = this.endPage - 9;
		
		// The real last page
		int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));
		
		// If the final page of block is < endPage, replace endPage
		if (realEnd <= this.endPage) {
		  this.endPage = realEnd;
		}
		
		// If this is not the first block, use prev
		this.prev = this.startPage > 1;
		
		// If this is not the last block, use next
		this.next = this.endPage < realEnd;
  }
  
}

