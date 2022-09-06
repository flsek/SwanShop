package com.swan.model;

import java.util.List;

public class AnswerPageDTO {
	/*
	 * 서버에서는 두 개의 정보를 만들어서 뷰로 전달해주어야 함.
	 * 1. 10개로 페이징 된 '답변 정보 리스트'
	 * 2. 회원이 보고자 하는 '페이지 정보' 
	 * 한 번의 ajax 요청으로 두 개의 정보를 뷰로 반환할 수 있도록, 두 개의 정보를 담는 그릇이 될 새로운 타입의 DTO 클래스 생성
	 * !! 서버에서 뷰로 전송될 때 해당 객체는 JSON으로 변환되어 뷰로 전달 됨!!
	 */
	// 페이징된 답변 리스트 정보
	List<AnswerDTO> list;
	
	// 페이지 정보를 저장할 변수
	PageDTO pageInfo;
	
	public AnswerPageDTO() {}

	public AnswerPageDTO(List<AnswerDTO> list, PageDTO pageInfo) {
		super();
		this.list = list;
		this.pageInfo = pageInfo;
	}

	public List<AnswerDTO> getList() {
		return list;
	}

	public void setList(List<AnswerDTO> list) {
		this.list = list;
	}

	public PageDTO getPageInfo() {
		return pageInfo;
	}

	public void setPageInfo(PageDTO pageInfo) {
		this.pageInfo = pageInfo;
	}

	@Override
	public String toString() {
		return "AnswerPageDTO [list=" + list + ", pageInfo=" + pageInfo + "]";
	}

}
