package com.studdype.test.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.studdype.test.model.biz.board.MeetBiz;
import com.studdype.test.model.biz.member.MemberBiz;
import com.studdype.test.model.biz.study.StudyApplyingBiz;
import com.studdype.test.model.biz.study.StudyBiz;
import com.studdype.test.model.biz.study.StudyMemberBiz;
import com.studdype.test.model.dto.board.MeetDto;
import com.studdype.test.model.dto.member.MemberDto;
import com.studdype.test.model.dto.study.StudyApplyingDto;
import com.studdype.test.model.dto.study.StudyDto;
import com.studdype.test.model.dto.study.StudyMemberDto;


/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Autowired
	private MemberBiz memberBiz;
	@Autowired
	private StudyBiz studyBiz;
	@Autowired
	private StudyMemberBiz studymemberBiz;
	@Autowired
	private StudyApplyingBiz studyapplyingBiz;
	@Autowired
	private MeetBiz meetBiz;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	private final static int pageSize = 6; // 한 페이지에 보여줄 개수
	private final static int pageGroupSize = 5; // 페이지 그룹 사이즈
	
	@RequestMapping("/studdypehome.do")
	public String studdypeHeader() {
		
		return "studdype/studdypeHome";
	}
	
	@RequestMapping("/studdypeexample.do")
	public String studdypeExample() {
	
		return "studdype/studdypeExample";
	}
	
	@RequestMapping("/searchbycategory.do")
	public String searchByCategory() {
	
		return "studdype/searchByCategory";
	}
	
	//마이페이지로 이동
	@RequestMapping("/myPage.do")
	public String myPage(HttpSession session,String pagenum, Model model) {
		MemberDto login = memberBiz.selectOne(1);
		List<StudyMemberDto> joinedstudy = studymemberBiz.StudyList(1);
		List<StudyDto> studylist = new ArrayList<StudyDto>();
		List<StudyDto> applylist = new ArrayList<StudyDto>();
		List<StudyDto> LeaderList = studyBiz.studyLeader(1);    //본인이 리더인 스터디 리스트 
		List<StudyApplyingDto> Receiveapply = new ArrayList<StudyApplyingDto>(); //내가 받은 가입 신청
		List<StudyApplyingDto> studyApplylist = studyapplyingBiz.studyApplyingList(1); //멤버 번호로 studyapply 리스트 가져오기
		List<StudyDto> receiveapplyname = new ArrayList<StudyDto>();
		List<MeetDto> meetlist = new ArrayList<>();
		
		for(int i=0;i<joinedstudy.size();i++) {
			StudyDto dto = studyBiz.selectOneBySno(joinedstudy.get(i).getS_no());
			studylist.add(dto);
		}
		
		
		
		for(int i=0;i<studyApplylist.size();i++) {
			StudyDto dto2 = studyBiz.selectOneBySno(studyApplylist.get(i).getS_no());
			applylist.add(dto2);
		}
		
		if(LeaderList.size()>studyApplylist.size()) {
			for(int i=0;i<studyApplylist.size();i++) {
				if(LeaderList.get(i).getLeader_no()==studyApplylist.get(i).getMem_no()) {
					StudyApplyingDto dto3 = studyapplyingBiz.selectOneByMno(studyApplylist.get(i).getMem_no());
					Receiveapply.add(dto3);
				}
			}
		}else {
			for(int i=0;i<LeaderList.size();i++) {
				if(LeaderList.get(i).getLeader_no()==studyApplylist.get(i).getMem_no()) {
					StudyApplyingDto dto3 = studyapplyingBiz.selectOneByMno(studyApplylist.get(i).getMem_no());
					Receiveapply.add(dto3);
				}
			}
		}
		
		for(int i=0;i<Receiveapply.size();i++) {
			StudyDto dto4 = studyBiz.selectOneBySno(Receiveapply.get(i).getS_no());
			receiveapplyname.add(dto4);
		}
		for(int i=0;i<joinedstudy.size();i++) {
			List<MeetDto> list = meetBiz.selectMeetList(joinedstudy.get(i).getS_no());
			meetlist.addAll(list);
		}
	
		
		model.addAttribute("meetlist",meetlist);
		model.addAttribute("Receiveapply",Receiveapply);
		model.addAttribute("receiveapplyname",receiveapplyname);
		model.addAttribute("studyApplylist",studyApplylist);
		model.addAttribute("applylist",applylist);
		session.setAttribute("login",login);
		model.addAttribute("studylist", studylist);
	
		
		
		return "studdype/myPage";
	}
	@RequestMapping("/UpdateMember.do")
	public String UpdateMember(HttpSession session, Model model,HttpServletRequest request) {
		MemberDto login = memberBiz.selectOne(1);
		
	
		model.addAttribute("mem_id",request.getParameter("mem_id"));
		model.addAttribute("mem_pw",request.getParameter("mem_pw"));
		model.addAttribute("mem_email",request.getParameter("mem_email"));
		model.addAttribute("mem_phone",request.getParameter("mem_phone"));
		
		session.setAttribute("login",login);
		return "studdype/UpdateMember";
	}
	//정보 수정 아이디 중복체크
	@RequestMapping(value="/idchk.do",method = RequestMethod.GET)
	public String idchk(HttpServletRequest request, Model model) {
		
		
		MemberDto dto = memberBiz.idchk(request.getParameter("mem_id"));
	
	
		if(dto == null) {
		
		model.addAttribute("msg", "사용 가능한 아이디입니다!");
		model.addAttribute("url", "UpdateMember.do?mem_id="+request.getParameter("mem_id")+"&mem_pw="+request.getParameter("mem_pw")+"&mem_email="+request.getParameter("mem_email")+"&mem_phone="+request.getParameter("mem_phone")+"&mem_no="+request.getParameter("mem_no"));
		
		return "commond/alert";
		}else {
		
		model.addAttribute("msg", "중복된 아이디가있습니다,아이디를 변경해주세요!");
		model.addAttribute("url", "UpdateMember.do");
		return "commond/alert";
	}
	}
	@RequestMapping(value="/memberupdate.do",method = RequestMethod.GET)
	public String memberUpdate(HttpServletRequest request, Model model) {
		MemberDto dto = new MemberDto(Integer.parseInt(request.getParameter("mem_no")),request.getParameter("mem_id"),request.getParameter("mem_pw"),request.getParameter("mem_phone"),request.getParameter("mem_email"));
		int res = memberBiz.updateMember(dto);
		
		if(res>0) {
			model.addAttribute("msg","수정성공!");
			model.addAttribute("url","myPage.do");
			return "commond/alert";
		}else {
			model.addAttribute("msg","수정 실패!");
			model.addAttribute("url", "UpdateMember.do?mem_id="+request.getParameter("mem_id")+"&mem_pw="+request.getParameter("mem_pw")+"&mem_email="+request.getParameter("mem_email")+"&mem_phone="+request.getParameter("mem_phone")+"&mem_no="+request.getParameter("mem_no"));
			return "commond/alert";
		}
	
	}
	
	//페이징 함수
	public void paging(Map<String, Integer> pagingMap, String pageNum, int totalBoardNum) {
		int currentPage = (pageNum == null || pageNum.trim() == "") ? 1 : Integer.parseInt(pageNum); // 현재 페이지
		int startRow = (currentPage - 1) * pageSize + 1; 		// 페이지 첫번째 글
		int endRow = currentPage * pageSize; 					// 페이지 마지막 글
		int numPageGroup = (int) Math.ceil((double) currentPage / pageGroupSize); // 페이지 그룹
		/*
		 * [1][2][3][4][5] -> 1 ( numPageGroup ) [6][7][8][9][10] -> 2
		 */
		int startPage = (numPageGroup - 1) * pageGroupSize + 1; // 시작페이지
		int endPage = numPageGroup * pageGroupSize; 			// 끝 페이지
		int totalPageNum = totalBoardNum / pageSize + 1; 		// 총페이지 개수

		// 마지막 페이지가 총 페이지 갯수보다 많으면
		if (endPage > totalPageNum) {
			endPage = totalPageNum;
		}

		pagingMap.put("currentPage", currentPage);
		pagingMap.put("startRow", startRow);
		pagingMap.put("endRow", endRow);
		pagingMap.put("startPage", startPage);
		pagingMap.put("endPage", endPage);
		pagingMap.put("totalPageNum", totalPageNum);
		
	}

	//커뮤니티 홈으로

	@RequestMapping("/communityhome.do")
	public String communityHome(HttpSession session,Model model) {
		

		/////////////////////// 테스트용 세션
		MemberDto login = memberBiz.selectOne(2);
		StudyDto study = studyBiz.selectOneBySno(1);
		
		session.setAttribute("study", study); //스터디 세션
		session.setAttribute("login", login); //스터디 세션
		//////////////////화상회의 테스트를 위한 session login, study커뮤니티접근 세션 구현후 삭제
		session.setAttribute("leftnavi", "studyhome");
	
		return "community/communityHome";
	}
	//마이페이지에서 studycommunity 접근시
	@RequestMapping("studycommunity.do")
	public String studycommunity(HttpSession session,int s_no) {
		MemberDto login = memberBiz.selectOne(1);
		StudyDto study = studyBiz.selectOneBySno(s_no);
		
		session.setAttribute("study", study);
		session.setAttribute("login", login);
		session.setAttribute("leftnavi", "studyhome");
		
		return "community/communityHome";
	}
	
	@RequestMapping("/notice.do")
	public String notice(HttpSession session) {
		session.setAttribute("leftnavi", "notice");
		return "community/notice";
	}
	

	
	@RequestMapping("/signupform.do")
	public String signup(HttpSession session) {
		return "loginpage/signup";
	}
	
	@RequestMapping("/notetest.do")
	public String notetest() {
		return "notetest";
	}
}









