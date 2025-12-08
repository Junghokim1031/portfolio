package org.zerock.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {
	
	// org.zerock.service.SampleService로 시작하는 모든 class, interface의 모든 메서드가 실행되기 전에 동작
	@Before("execution(* org.zerock.service.SampleService*.*(..))")
	public void logBefore() {
		//공통 기능을 여기에 작성
		//Method가 실행되기 전에 공통작업 작성.
		// 로그인 여부 확인 (This is in security library)
		log.info("========================");
	}
	
	//In do Add, with args(str1, str2)
	@Before("execution(* org.zerock.service.SampleService*.doAdd(String, String)) && args(str1, str2)")
	public void logBeforeWithParam(String str1, String str2) {
		//validation 작업들에 응용가능
		log.info("str1: " + str1);
		log.info("str2: " + str2);
	}  

	//org.zerock.service.SampleService로 시작하는 모든 class,interface의 모든 메서드가 실행되어 exception이 발생하면 동작
	@AfterThrowing(pointcut = "execution(* org.zerock.service.SampleService*.*(..))", throwing="exception")
	public void logException(Exception exception) {
		//Exception발생 시 처리할 내용 작성
		log.info("Exception....!!!!");
		log.info("exception: "+ exception);
	}
	
	// 모든 method가 실행될 때 동작
	@Around("execution(* org.zerock.service.SampleService*.*(..))")
	  public Object logTime( ProceedingJoinPoint pjp) {
	    
		// 시작시간
	    long start = System.currentTimeMillis();
	    
	    //TARGET
	    log.info("Target: " + pjp.getTarget());
	    //PARAMETER
	    log.info("Param: " + Arrays.toString(pjp.getArgs()));
	    
	    
	    //invoke method 
	    Object result = null;
	    
	    try {
	    	//결과 수집
	    	result = pjp.proceed();
	    } catch (Throwable e) {
	      // TODO Auto-generated catch block
	      e.printStackTrace();
	    }
	    
	    //끝 시간
	    long end = System.currentTimeMillis();
	    
	    //총 실행시간
	    log.info("TIME: "  + (end - start));
	    
	    // 값 반환
	    return result;
	  }
}
