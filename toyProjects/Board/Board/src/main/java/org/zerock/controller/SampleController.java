package org.zerock.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.zerock.domain.SampleVO;
import org.zerock.domain.Ticket;

import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/sample")
@Log4j2
public class SampleController {
	
	@GetMapping("/all")
    public void all() {
    }

    @PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
    @GetMapping("/member")
    public void member() {
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/admin")
    public void admin() {
    }
	
	/*
	 * // OLDER STUFF
	 * 
	 * @GetMapping(value = "/getSample",produces = {
	 * MediaType.APPLICATION_JSON_UTF8_VALUE, MediaType.APPLICATION_XML_VALUE })
	 * public SampleVO getSample() { return new SampleVO(112, "스타", "로드"); }
	 * 
	 * @GetMapping(value = "/getList") //We get Both Json and XML as default public
	 * List<SampleVO> getList() { //========================= // DOES NOT INCLUDE
	 * 10!!!!! //========================= return IntStream.range(1, 10).mapToObj(i
	 * -> new SampleVO(i, i + " First", i + " Last")) .collect(Collectors.toList());
	 * }
	 * 
	 * @GetMapping(value="/getMap") public Map<String,SampleVO> getMap(){
	 * Map<String, SampleVO> map = new HashMap<>(); map.put("First", new
	 * SampleVO(111,"그루트","주니어")); map.put("Second", new SampleVO(111,"길동","홍"));
	 * map.put("Third", new SampleVO(111,"순신","이"));
	 * 
	 * return map; }
	 * 
	 * @GetMapping(value="/check", params= {"height", "weight"}) public
	 * ResponseEntity<SampleVO> check(Double height, Double weight){ SampleVO vo =
	 * new SampleVO(000,""+ height, "" + weight); ResponseEntity<SampleVO> result=
	 * null;
	 * 
	 * if(height < 150) {
	 * result=ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(vo); } else {
	 * result=ResponseEntity.status(HttpStatus.OK).body(vo); }
	 * 
	 * return result; }
	 * 
	 * @GetMapping("/product/{cat1}/{pid1}/{cat2}/{pid2}") public String[]
	 * getPath(@PathVariable("cat1") String cat1, @PathVariable("pid1") String pid1,
	 * 
	 * @PathVariable("cat2") String cat2, @PathVariable("pid2") String pid2) {
	 * return new String[] { "category: " + cat1, "productid: " + pid1, "category: "
	 * + cat2, "productid: " + pid2 }; }
	 * 
	 * 
	 * 
	 * @GetMapping("/product/{cat}/{pid}") public String[]
	 * getPath(@PathVariable("cat") String cat, @PathVariable("pid") Integer pid) {
	 * return new String[] { "category: " + cat, "productid: " + pid }; }
	 * 
	 * @PostMapping("/ticket") public Ticket convert(@RequestBody Ticket ticket) {
	 * return ticket; }
	 */
}
