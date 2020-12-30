------------------계정 생성 및 권한 부여 --------------------------
--------------------------------------------------------
CREATE USER STUDDYPE IDENTIFIED BY STUDDYPE;
GRANT CONNECT, RESOURCE TO STUDDYPE;
------------------ DROP  --------------------------
DROP SEQUENCE MEMBERSEQ;
DROP SEQUENCE SISEQ;
DROP SEQUENCE GUSEQ;
DROP SEQUENCE CATEGORYSEQ;
DROP SEQUENCE STUDYSEQ;
DROP SEQUENCE NOTICEBOARDSEQ;
DROP SEQUENCE NOTICEREPLYSEQ;
DROP SEQUENCE NOTICEFILESEQ;
DROP SEQUENCE FREEBOARDSEQ;
DROP SEQUENCE FREEREPLYSEQ;
DROP SEQUENCE FREEFILESEQ;
DROP SEQUENCE BOOKBOARDSEQ;
DROP SEQUENCE PHOTOBOARDSEQ;
DROP SEQUENCE PHOTOREPLYSEQ;
DROP SEQUENCE PHOTOFILESEQ;
DROP SEQUENCE SCHEBOARDSEQ;
DROP SEQUENCE DATABOARDSEQ;
DROP SEQUENCE DATAREPLYSEQ;
DROP SEQUENCE DATAFILESEQ;
DROP SEQUENCE MEETBOARDSEQ;
DROP SEQUENCE MEETREPLYSEQ;

SELECT * FROM ALL_TABLES WHERE OWNER = 'STUDDYPE'; --전체 테이블 확인

DROP TABLE MEMBER;
DROP TABLE LOCATION_SI;
DROP TABLE LOCATION_GU;
DROP TABLE STUDY_CATEGORY;
DROP TABLE STUDY;
DROP TABLE STUDY_MEMBER;
DROP TABLE STUDY_APPLYING;
DROP TABLE NOTICE_BOARD;
DROP TABLE NOTICE_REPLY;
DROP TABLE NOTICE_FILE;
DROP TABLE FREE_BOARD;
DROP TABLE FREE_REPLY;
DROP TABLE FREE_FILE;
DROP TABLE BOOK_BOARD;
DROP TABLE BOOK;
DROP TABLE PHOTO_BOARD;
DROP TABLE PHOTO_REPLY;
DROP TABLE PHOTO_FILE;
DROP TABLE SCHEDULE_BOARD;
DROP TABLE DATA_BOARD;
DROP TABLE DATA_REPLY;
DROP TABLE DATA_FILE;
DROP TABLE MEET_BOARD;
DROP TABLE MEET_VOTE;
DROP TABLE MEET_REPLY;
--------------------------------------------------------

------------------ NO 시퀀스 --------------------------
--------------------------------------------------------
CREATE SEQUENCE MEMBERSEQ NOCACHE;  --회원 시퀀스

CREATE SEQUENCE SISEQ NOCACHE;  --지역(시) 시퀀스
CREATE SEQUENCE GUSEQ NOCACHE;  --지역(구) 시퀀스
CREATE SEQUENCE CATEGORYSEQ NOCACHE;  --카테고리 시퀀스

CREATE SEQUENCE STUDYSEQ NOCACHE;  --스터디 시퀀스

CREATE SEQUENCE NOTICEBOARDSEQ NOCACHE;  --공지사항게시글
CREATE SEQUENCE NOTICEREPLYSEQ NOCACHE;  --공지사항 댓글
CREATE SEQUENCE NOTICEFILESEQ NOCACHE;  --공지사항 게시그 사진

CREATE SEQUENCE FREEBOARDSEQ NOCACHE;  --자유게시판게시글
CREATE SEQUENCE FREEREPLYSEQ NOCACHE;  --자유게시판 댓글
CREATE SEQUENCE FREEFILESEQ NOCACHE;  --자유 게시판 게시그 사진

CREATE SEQUENCE BOOKBOARDSEQ NOCACHE;  --책 게시판 게시글

CREATE SEQUENCE PHOTOBOARDSEQ NOCACHE;  --사진게시판게시글
CREATE SEQUENCE PHOTOREPLYSEQ NOCACHE;  --사진게시판 댓글
CREATE SEQUENCE PHOTOFILESEQ NOCACHE;  --사진 게시판 게시그 사진

CREATE SEQUENCE SCHEBOARDSEQ NOCACHE; --일정 게시판 게시글

CREATE SEQUENCE DATABOARDSEQ NOCACHE;  --자료실게시판게시글
CREATE SEQUENCE DATAREPLYSEQ NOCACHE;  --자료실게시판 댓글
CREATE SEQUENCE DATAFILESEQ NOCACHE;  --자료실 게시판 게시그 사진

CREATE SEQUENCE MEETBOARDSEQ NOCACHE;  --모임게시판게시글
CREATE SEQUENCE MEETREPLYSEQ NOCACHE;  --모임게시판 댓글


DROP TABLE LOCATION_GU CASCADE CONSTRAINTS;
------------------ 테이블 생성 --------------------------
--------------------------------------------------------

--회원 테이블 
CREATE TABLE MEMBER(
    MEM_NO NUMBER PRIMARY KEY, --번호
    MEM_ID VARCHAR2(100) NOT NULL, --아이디
    MEM_PW VARCHAR2(100) NOT NULL, --비밀번호
    MEM_NAME VARCHAR2(100) NOT NULL, --이름
    MEM_RNO VARCHAR2(14) UNIQUE NOT NULL, --주민번호
    MEM_GENDER VARCHAR2(1) CHECK(MEM_GENDER IN('M','F')) NOT NULL ,--성별 M,F
    MEM_PHONE VARCHAR2(13) NOT NULL, --핸드폰 번호
    MEM_EMAIL VARCHAR2(100) NOT NULL -- 이메일    
);

------지역 카테고리 
---시
CREATE TABLE LOCATION_SI(
    SI_NO NUMBER PRIMARY KEY, --시 번호
    SI_NAME VARCHAR2(50) NOT NULL UNIQUE --시 이름
);
--구
CREATE TABLE LOCATION_GU(
    GU_NO NUMBER PRIMARY KEY, --구 번호
    SI_NO  NUMBER, -- 시 번호 외래키
    GU_NAME VARCHAR(50) NOT NULL , -- 구 이름    
    FOREIGN KEY(SI_NO) REFERENCES LOCATION_SI(SI_NO)  ON DELETE CASCADE
    
);


--스터디 카테고리
CREATE TABLE STUDY_CATEGORY(
    CATE_NO NUMBER PRIMARY KEY, --카테고리 번호
    CATE_NAME VARCHAR2(100) NOT NULL UNIQUE --카테고리 이름
);



--스터디 테이블
 CREATE TABLE STUDY(
    S_NO NUMBER PRIMARY KEY, --스터디 번호
    LEADER_NO NUMBER NOT NULL, --팀장 번호   [ 외래키 ]
    S_NAME VARCHAR2(100) NOT NULL, --스터디 이름
    S_INFO VARCHAR2(100) NOT NULL, --스터디 한줄 소개
    S_CONTENT VARCHAR2(3000) NOT NULL, --스터디 자세한 소개
    S_PHOTO VARCHAR2(100), --스터디 대표사진 파일이름
    CATE_NO NUMBER NOT NULL, --스터디 카테고리   [외래키]
    SI_NO NUMBER NOT NULL, --스터디 지역(시)    [외래키]
    GU_NO NUMBER NOT NULL, --스터디 지역(구)   [외래키]
    S_MAXCNT NUMBER NOT NULL, --스터디 최대 인원
    S_CURRENTCNT NUMBER DEFAULT 1 NOT NULL, --스터디 현재 인원 
    FOREIGN KEY (LEADER_NO) REFERENCES MEMBER(MEM_NO) ON DELETE CASCADE,
    FOREIGN KEY (CATE_NO) REFERENCES STUDY_CATEGORY(CATE_NO) ON DELETE SET NULL,
    FOREIGN KEY (SI_NO) REFERENCES LOCATION_SI(SI_NO) ON DELETE SET NULL,
    FOREIGN KEY (GU_NO) REFERENCES LOCATION_GU(GU_NO) ON DELETE SET NULL
 );

 INSERT INTO STUDY VALUES(STUDYSEQ.NEXTVAL,1,'토익스터디','토익 준비','토익 시험','TOEIC',05,001 ,003,3,1);

 
 
 
 
 
 
 
-- 스터디 팀원목록
CREATE TABLE STUDY_MEMBER(
    S_NO NUMBER,
    MEM_NO NUMBER,
    FOREIGN KEY(S_NO) REFERENCES STUDY(S_NO) ON DELETE CASCADE,
    FOREIGN KEY(MEM_NO) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE,
    PRIMARY KEY(S_NO, MEM_NO)    
);

--스터디 가입신청 현황
CREATE TABLE STUDY_APPLYING(
    S_NO NUMBER,
    MEM_NO NUMBER,
    AGREE VARCHAR2(1) DEFAULT 'D' CHECK(AGREE IN('Y','N','D')) NOT NULL ,-- 수락현황 Y,N,D
    INFO VARCHAR2(1000) NOT NULL, --자기소개
     FOREIGN KEY(S_NO) REFERENCES STUDY(S_NO) ON DELETE CASCADE,
    FOREIGN KEY(MEM_NO) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE,
    PRIMARY KEY(S_NO, MEM_NO)        
);

------------------ 게시판 생성 --------------------------
--------------------------------------------------------

--공지사항 게시판
CREATE TABLE NOTICE_BOARD(
    B_NO NUMBER PRIMARY KEY, --게시글 번호
    S_NO NUMBER NOT NULL,   --스터디번호 [외래키]
    B_TITLE VARCHAR2(1000) NOT NULL,--게시글 제목
    B_WRITER NUMBER NOT NULL, -- 작성자 (회원번호) [외래키]
    B_CONTENT VARCHAR2(4000) NOT NULL, --게시글 내용
    B_REGDATE DATE NOT NULL,--게시글 작성 시간
    B_IMPORTANT NUMBER DEFAULT 0 CHECK(B_IMPORTANT IN (0,1)) NOT NULL, --필수공지사항 1->필수 0->기본
    B_CNT NUMBER DEFAULT 0, -- 조회수
      FOREIGN KEY(S_NO) REFERENCES STUDY(S_NO) ON DELETE CASCADE,
    FOREIGN KEY(B_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE    
);

--공지사항 게시판 댓글
CREATE TABLE NOTICE_REPLY(
    R_NO NUMBER PRIMARY KEY, -- 댓글 번호
    B_NO NUMBER NOT NULL, --게시글 번호
    R_GROUPNO NUMBER NOT NULL, -- 댓글 그룹 번호
    R_CLASS NUMBER NOT NULL, -- 댓글 계층
    R_ORDER NUMBER NOT NULL,--댓글,답글 순서    
    R_WRITER NUMBER NOT NULL, -- 댓글 작성자 (회원번호)
    R_COMMENT VARCHAR2(1000) NOT NULL, --댓글 내용
    R_REGDATE DATE NOT NULL,--댓글 작성 시간
    FOREIGN KEY(R_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE ,
    FOREIGN KEY(B_NO) REFERENCES NOTICE_BOARD(B_NO) ON DELETE CASCADE    
);

--공지사항 게시판 사진
CREATE TABLE NOTICE_FILE(
    F_NO NUMBER PRIMARY KEY, --파일 번호
    B_NO NUMBER NOT NULL, --게시글번호
    F_NAME VARCHAR2(1000) NOT NULL, --파일 실제이름
    FOREIGN KEY(B_NO) REFERENCES NOTICE_BOARD(B_NO) ON DELETE CASCADE    
);

--자유 게시판
CREATE TABLE FREE_BOARD(
    B_NO NUMBER PRIMARY KEY, --게시글 번호
    S_NO NUMBER NOT NULL,   --스터디번호 [외래키]
    B_TITLE VARCHAR2(1000) NOT NULL,--게시글 제목
    B_WRITER NUMBER NOT NULL, -- 작성자 (회원번호) [외래키]
    B_CONTENT VARCHAR2(4000) NOT NULL, --게시글 내용
    B_REGDATE DATE NOT NULL,--게시글 작성 시간
     B_CNT NUMBER DEFAULT 0, -- 조회수
      FOREIGN KEY(S_NO) REFERENCES STUDY(S_NO) ON DELETE CASCADE,
    FOREIGN KEY(B_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE    
);

--자유 게시판 댓글
CREATE TABLE FREE_REPLY(
    R_NO NUMBER PRIMARY KEY, -- 댓글 번호
    B_NO NUMBER NOT NULL, --게시글 번호
    R_GROUPNO NUMBER NOT NULL, -- 댓글 그룹 번호
    R_CLASS NUMBER NOT NULL, -- 댓글 계층
    R_ORDER NUMBER NOT NULL,--댓글,답글 순서    
    R_WRITER NUMBER NOT NULL, -- 댓글 작성자 (회원번호)
    R_COMMENT VARCHAR2(1000) NOT NULL, --댓글 내용
    R_REGDATE DATE NOT NULL,--댓글 작성 시간
    FOREIGN KEY(R_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE ,
    FOREIGN KEY(B_NO) REFERENCES FREE_BOARD(B_NO) ON DELETE CASCADE    
);


--자유 게시판 사진
CREATE TABLE FREE_FILE(
    F_NO NUMBER PRIMARY KEY, --파일 번호
    B_NO NUMBER NOT NULL, --게시글번호
    F_NAME VARCHAR2(1000) NOT NULL, --파일 실제이름
    FOREIGN KEY(B_NO) REFERENCES FREE_BOARD(B_NO) ON DELETE CASCADE    
);
FREE_FILE,BOOK_BOARD,BOOK,PHOTO_BOARD,PHOTO_REPLY,PHOTO_FILE,SCHEDULE_BOARD
DATA_BOARD DATA_REPLY DATA_FILE MEET_BOARD MEET_VOTE MEET_REPLY



DROP TABLE LOCATION_SI CASCADE CONSTRAINTS;


-- 학습 도서 게시판
CREATE TABLE BOOK_BOARD(
    B_NO NUMBER PRIMARY KEY, --게시글 번호
    S_NO NUMBER NOT NULL,   --스터디번호 [외래키]
    B_TITLE VARCHAR2(1000) NOT NULL,--게시글 제목
    B_WRITER NUMBER NOT NULL, -- 작성자 (회원번호) [외래키]
    B_CONTENT VARCHAR2(4000) NOT NULL, --게시글 내용
    B_REGDATE DATE NOT NULL,--게시글 작성 시간
    B_CNT NUMBER DEFAULT 0, -- 조회수  
    FOREIGN KEY(S_NO) REFERENCES STUDY(S_NO) ON DELETE CASCADE,
    FOREIGN KEY(B_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE    
);

--학습 도서
CREATE TABLE BOOK(
    B_NO NUMBER PRIMARY KEY, --게시글 번호 [외래키]
    S_NO NUMBER, --스터디 번호
    BOOK_TITLE VARCHAR2(500) NOT NULL, --책 이름
    BOOK_AUTHOR VARCHAR2(500) NOT NULL, -- 책 저자
    BOOK_PUBLISH VARCHAR2(500) NOT NULL, -- 책 출판사
    BOOK_IMG VARCHAR2(1000) NOT NULL, --도서 이미지 URL
    BOOK_URL VARCHAR2(1000) NOT NULL, -- 도서 URL
    BOOK_ISMAIN VARCHAR2(1) DEFAULT 'N' CHECK (BOOK_ISMAIN IN ('Y','N')) NOT NULL, -- 대표도서 Y,N
    FOREIGN KEY (B_NO) REFERENCES BOOK_BOARD(B_NO) ON DELETE CASCADE,
    FOREIGN KEY (S_NO) REFERENCES STUDY(S_NO) ON DELETE CASCADE
);

--사진 게시판
CREATE TABLE PHOTO_BOARD(
    B_NO NUMBER PRIMARY KEY, --게시글 번호
    S_NO NUMBER NOT NULL,   --스터디번호 [외래키]
    B_TITLE VARCHAR2(1000) NOT NULL,--게시글 제목
    B_WRITER NUMBER NOT NULL, -- 작성자 (회원번호) [외래키]
    B_CONTENT VARCHAR2(4000) NOT NULL, --게시글 내용
    B_REGDATE DATE NOT NULL,--게시글 작성 시간
     B_CNT NUMBER DEFAULT 0, -- 조회수
      FOREIGN KEY(S_NO) REFERENCES STUDY(S_NO) ON DELETE CASCADE,
    FOREIGN KEY(B_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE    
);

--사진 게시판 댓글
CREATE TABLE PHOTO_REPLY(
    R_NO NUMBER PRIMARY KEY, -- 댓글 번호
    B_NO NUMBER NOT NULL, --게시글 번호
    R_GROUPNO NUMBER NOT NULL, -- 댓글 그룹 번호
    R_CLASS NUMBER NOT NULL, -- 댓글 계층
    R_ORDER NUMBER NOT NULL,--댓글,답글 순서    
    R_WRITER NUMBER NOT NULL, -- 댓글 작성자 (회원번호)
    R_COMMENT VARCHAR2(1000) NOT NULL, --댓글 내용
    R_REGDATE DATE NOT NULL,--댓글 작성 시간
    FOREIGN KEY(R_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE ,
    FOREIGN KEY(B_NO) REFERENCES PHOTO_BOARD(B_NO) ON DELETE CASCADE    
);


--사진 게시판 사진
CREATE TABLE PHOTO_FILE(
    F_NO NUMBER PRIMARY KEY, --파일 번호
    B_NO NUMBER NOT NULL, --게시글번호
    F_NAME VARCHAR2(1000) NOT NULL, --파일 실제이름
    PHOTO_ISMAIN VARCHAR2(1) DEFAULT 'N' CHECK (PHOTO_ISMAIN IN ('Y','N')) NOT NULL, -- 대표사진 Y,N
    FOREIGN KEY(B_NO) REFERENCES FREE_BOARD(B_NO) ON DELETE CASCADE    
);

--일정 게시판 
CREATE TABLE SCHEDULE_BOARD(
    SCHE_NO NUMBER PRIMARY KEY, --일정 번호
    S_NO NUMBER NOT NULL, --스터디 번호
    SCHE_TITLE VARCHAR2(1000) NOT NULL, --일정 이름
    SCHE_WRITER NUMBER NOT NULL, --일정 등록자(회원번호)
    SCHE_CONTENT VARCHAR2(4000) NOT NULL, --일정 내용
    SCHE_STARTDATE DATE NOT NULL, --일정 시작일
    SCHE_ENDDATE DATE NOT NULL, --일정 종료일
     FOREIGN KEY(S_NO) REFERENCES STUDY (S_NO) ON DELETE CASCADE ,
    FOREIGN KEY(SCHE_WRITER) REFERENCES MEMBER(MEM_NO) ON DELETE CASCADE        
);

--학습자료실 게시판
CREATE TABLE DATA_BOARD(
    B_NO NUMBER PRIMARY KEY, --게시글 번호
    S_NO NUMBER NOT NULL,   --스터디번호 [외래키]
    B_TITLE VARCHAR2(1000) NOT NULL,--게시글 제목
    B_WRITER NUMBER NOT NULL, -- 작성자 (회원번호) [외래키]
    B_CONTENT VARCHAR2(4000) NOT NULL, --게시글 내용
    B_REGDATE DATE NOT NULL,--게시글 작성 시간
     B_CNT NUMBER DEFAULT 0, -- 조회수
      FOREIGN KEY(S_NO) REFERENCES STUDY(S_NO) ON DELETE CASCADE,
    FOREIGN KEY(B_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE    
);

--학습자료실 게시판 댓글
CREATE TABLE DATA_REPLY(
    R_NO NUMBER PRIMARY KEY, -- 댓글 번호
    B_NO NUMBER NOT NULL, --게시글 번호
    R_GROUPNO NUMBER NOT NULL, -- 댓글 그룹 번호
    R_CLASS NUMBER NOT NULL, -- 댓글 계층
    R_ORDER NUMBER NOT NULL,--댓글,답글 순서    
    R_WRITER NUMBER NOT NULL, -- 댓글 작성자 (회원번호)
    R_COMMENT VARCHAR2(1000) NOT NULL, --댓글 내용
    R_REGDATE DATE NOT NULL,--댓글 작성 시간
    FOREIGN KEY(R_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE ,
    FOREIGN KEY(B_NO) REFERENCES DATA_BOARD(B_NO) ON DELETE CASCADE    
);


--학습자료실 게시판 사진
CREATE TABLE DATA_FILE(
    F_NO NUMBER PRIMARY KEY, --파일 번호
    B_NO NUMBER NOT NULL, --게시글번호
    F_NAME VARCHAR2(1000) NOT NULL, --파일 실제이름    
    FOREIGN KEY(B_NO) REFERENCES DATA_BOARD(B_NO) ON DELETE CASCADE    
);

--모임 게시판
CREATE TABLE MEET_BOARD(
    MEET_NO NUMBER PRIMARY KEY, --모임 번호
    S_NO NUMBER NOT NULL,   --스터디번호 [외래키]
    MEET_TITLE VARCHAR2(1000) NOT NULL,--모임 제목
    MEET_WRITER NUMBER NOT NULL, -- 모임 작성자 (회원번호) [외래키]
    MEET_CONTENT VARCHAR2(4000) NOT NULL, --모임 내용,설명
    MEET_ADDR VARCHAR2(1000) NOT NULL, --모임 도로명 주소
    MEET_DATE DATE NOT NULL, --모임 날짜
    MEET_TIME DATE NOT NULL, --모임 시간
    MEET_REGDATE DATE NOT NULL,--모임 작성 시간
    VOTE_STARTDATE DATE NOT NULL, -- 투표 시작일
    VOTE_ENDDATE DATE NOT NULL, --투표 마감일
      FOREIGN KEY(S_NO) REFERENCES STUDY(S_NO) ON DELETE CASCADE,
    FOREIGN KEY(MEET_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE    
);

--모임 투표 
CREATE TABLE MEET_VOTE(
    MEET_NO NUMBER, --모임번호
    MEM_NO NUMBER, --회원번호
    VOTE_ATTEND VARCHAR2(1) DEFAULT 'D' CHECK (VOTE_ATTEND IN ('D','Y','N')) NOT NULL, --참석 여부  미투표,참석,불참
    PRIMARY KEY( MEET_NO, MEM_NO),
    FOREIGN KEY(MEET_NO) REFERENCES MEET_BOARD(MEET_NO) ON DELETE CASCADE,
    FOREIGN KEY(MEM_NO) REFERENCES MEMBER(MEM_NO) ON DELETE CASCADE
);

--모임 댓글
CREATE TABLE MEET_REPLY(
    R_NO NUMBER PRIMARY KEY, -- 댓글 번호
    B_NO NUMBER NOT NULL, --게시글 번호 (MEET_NO) DTO통일때문에 B_NO로잡음   
    R_WRITER NUMBER NOT NULL, -- 댓글 작성자 (회원번호)
    R_COMMENT VARCHAR2(1000) NOT NULL, --댓글 내용
    R_REGDATE DATE NOT NULL,--댓글 작성 시간
    FOREIGN KEY(R_WRITER) REFERENCES MEMBER (MEM_NO) ON DELETE CASCADE ,
    FOREIGN KEY(B_NO) REFERENCES MEET_BOARD(MEET_NO) ON DELETE CASCADE    
);

INSERT INTO STUDY_CATEGORY VALUES(1, 'IT');
INSERT INTO STUDY_CATEGORY VALUES(2, '자격증');
INSERT INTO STUDY_CATEGORY VALUES(3, '공무원');
INSERT INTO STUDY_CATEGORY VALUES(4, '뷰티');
INSERT INTO STUDY_CATEGORY VALUES(5, '대입/수능');
INSERT INTO STUDY_CATEGORY VALUES(6, '어학/회화');
INSERT INTO STUDY_CATEGORY VALUES(7, '취업스터디');
INSERT INTO STUDY_CATEGORY VALUES(8, '기타');

SELECT * FROM STUDY_CATEGORY;






COMMIT