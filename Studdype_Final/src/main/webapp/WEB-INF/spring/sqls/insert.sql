-- 규칙: 테이블명 주석달기
-- 예시: -- 모임 --모임댓글

--스터디 카테고리 
INSERT INTO STUDY_CATEGORY VALUES(CATEGORYSEQ.NEXTVAL, 'IT');
INSERT INTO STUDY_CATEGORY VALUES(CATEGORYSEQ.NEXTVAL, '자격증');
INSERT INTO STUDY_CATEGORY VALUES(CATEGORYSEQ.NEXTVAL, '공무원');
INSERT INTO STUDY_CATEGORY VALUES(CATEGORYSEQ.NEXTVAL, '뷰티');
INSERT INTO STUDY_CATEGORY VALUES(CATEGORYSEQ.NEXTVAL, '대입/수능');
INSERT INTO STUDY_CATEGORY VALUES(CATEGORYSEQ.NEXTVAL, '어학/회화');
INSERT INTO STUDY_CATEGORY VALUES(CATEGORYSEQ.NEXTVAL, '취업스터디');
INSERT INTO STUDY_CATEGORY VALUES(CATEGORYSEQ.NEXTVAL, '기타');

SELECT * FROM STUDY_CATEGORY;

COMMIT;