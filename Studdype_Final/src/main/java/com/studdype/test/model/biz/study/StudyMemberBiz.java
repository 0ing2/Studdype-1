package com.studdype.test.model.biz.study;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.studdype.test.model.dto.study.StudyMemberDto;

@Service
public interface StudyMemberBiz {
	public List<StudyMemberDto> StudyMemberList(int s_no); //스터디 번호로 가입된 스터디 멤버번호 가져오기
	public List<StudyMemberDto> StudyList(int mem_no); //멤버 번호로 가입된 스터디번호 가져오기
	public int StudyTotalNum(int mem_no); 
	public List<StudyMemberDto> pagingstudylist(Map pageMap);
	
}