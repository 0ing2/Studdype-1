package com.studdype.test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.studdype.test.model.biz.board.MeetBiz;
import com.studdype.test.model.dto.board.MeetDto;
import com.studdype.test.model.dto.study.StudyDto;

@Controller
public class MeetController {
	
	@Autowired
	private MeetBiz meetbiz;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	private final static int pageSize = 15; //한페이지에 보여줄 개수
	private final static int pageGroupSize = 5; //페이지 그룹 사이즈
	
	@RequestMapping("/meetlist.do")
	public String meetList(HttpSession session, String pagenum, Model model) {
		StudyDto study = (StudyDto)session.getAttribute("study"); // 현재 클릭 된 스터디
		List<MeetDto> list = null;
		Map<String,Integer> pageMap = new HashMap<String, Integer>();  // 시작페이지, 끝페이지 정보 담을 MAP
		Map<Integer, String> writerNameMap = null;//게시글 작성자 이름 담을 MAP
		logger.info("[MEET BOARD SELECT LIST]");
		
		//페이징----------------------------------------
		int currentPage = ( pagenum == null || pagenum.trim() == ""  ) ? 1 : Integer.parseInt(pagenum) ;  //현재 페이지
		
		int startRow = ( currentPage - 1) * pageSize + 1; //페이지 첫번째 글
		int endRow = currentPage * pageSize; // 페이지 마지막 글
		
		int numPageGroup = (int)Math.ceil( (double)currentPage / pageGroupSize ); //페이지 그룹
		/*
		 * [1][2][3][4][5] -> 1 ( numPageGroup )
		 * [6][7][8][9][10] -> 2
		 */
		
		int startPage = ( numPageGroup - 1 ) * pageGroupSize + 1; //시작페이지
		int endPage = numPageGroup * pageGroupSize ; //끝 페이지
		
		int totalBoardNum = meetbiz.selectTotalBoardNum( study.getS_no() ); //총 자유게시판 게시글 수
		int totalPageNum = totalBoardNum / pageSize + 1; //총페이지 개수

		//마지막 페이지가 총 페이지 갯수보다 많으면
		if ( endPage > totalPageNum ) {
			endPage = totalPageNum;
		}
		
		pageMap.put("startRow", startRow);
		pageMap.put("endRow", endRow);
		pageMap.put("studyno", study.getS_no());
		
		//15개 게시물만 가져오기
		list = meetbiz.selectPagingBoardList(pageMap);
		
		writerNameMap = meetbiz.getWriterNameByList(list);
		
		model.addAttribute("startPage", startPage);		
		model.addAttribute("endPage", endPage);		
		model.addAttribute("currentPage", currentPage);		
		model.addAttribute("totalPageNum", totalPageNum);		
		model.addAttribute("list", list);	
		model.addAttribute("writerMap", writerNameMap);
		model.addAttribute("selectList", meetbiz.selectList());
		session.setAttribute("leftnavi", "meet");
		return "community/meet/meetList";
	}
	
	@RequestMapping("/meetinsertform.do")
	public String meetInsert(HttpSession session) {
		session.setAttribute("leftnavi", "meet");
		return "community/meet/meetInsert";
	}
	
	@RequestMapping("/meetdetail.do")
	public String meetDetail(HttpSession session) {
		session.setAttribute("leftnavi", "meet");
		return "community/meet/meetDetail";
	}
	
	@RequestMapping("/meetupdateform.do")
	public String meetUpdate(HttpSession session) {
		session.setAttribute("leftnavi", "meet");
		return "community/meet/meetUpdate";
	}
}
