package org.zerock.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@ToString
@Setter
@Getter
public class Criteria {

  private int pageNum;
  private int amount;
  
  private String type;
  private String keyword;

  public Criteria() {
    this(1, 10);
  }

  public Criteria(int pageNum, int amount) {
    this.pageNum = pageNum;
    this.amount = amount;
  }
  
  //Lombok의 getter만 있을 경우, getter에 대응되는 private field를 자동 생성(?)
  public String[] getTypeArr() {
	//type의 값이 있으면, 한글자씩 분리해서 배열로 리턴함
    return type == null? new String[] {}: type.split("");
  }
}
