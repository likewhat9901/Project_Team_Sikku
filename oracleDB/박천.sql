alter session set "_ORACLE_SCRIPT"=true;
create user musthave identified by 1234;
grant connect, resource, unlimited tablespace to musthave;

/* listner 문제 */
show parameter local_listener;
show parameter service_names;
alter system set local_listener='(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))' scope=both;


/*-------------------------테이블 create-----------------------------------*/
/*member*/
CREATE TABLE members(
    userid             VARCHAR2(30)    PRIMARY KEY, 
    userpw             VARCHAR2(200)   NOT NULL,
    authority           VARCHAR2(20)    DEFAULT 'ROLE_USER',
    enabled             NUMBER(1)       DEFAULT 1,
    username  VARCHAR2(100)   UNIQUE,
    phonenumber        VARCHAR2(20)    UNIQUE,
    email               VARCHAR2(100)   UNIQUE,
    address             VARCHAR2(200),
    profileimgpath      VARCHAR2(100)
);

/* board */
CREATE TABLE hboard (
  boardidx     NUMBER          PRIMARY KEY,
  userid   NUMBER          NOT NULL,
  title        VARCHAR2(100)   NOT NULL,
  content      CLOB            NOT NULL,
  ofile        VARCHAR2(255),
  sfile        VARCHAR2(255),
  postdate     DATE            DEFAULT SYSDATE,              
  category     NUMBER(1)       DEFAULT 1 CHECK (category IN (1, 2)),
  visitcount   NUMBER          DEFAULT 0,  
  likes        NUMBER          DEFAULT 0,
  report       NUMBER          DEFAULT 0
);

/* plant dictionary */
CREATE TABLE plantdict (
  plantidx         NUMBER         PRIMARY KEY,
  name              VARCHAR2(100)  NOT NULL,
  imgpath             VARCHAR2(255),
  summary           VARCHAR2(500),
  note              VARCHAR2(1000),
  growseason       VARCHAR2(50),
  bloomingseason   VARCHAR2(50),
  humidity          VARCHAR2(50),
  sunlight          VARCHAR2(50),
  temperaturemin   NUMBER(5,2),
  temperaturemax   NUMBER(5,2),
  postdate          DATE DEFAULT SYSDATE
);

/*mbti*/
CREATE TABLE mbti (
  mbtiidx               NUMBER          PRIMARY KEY,    
  name                  VARCHAR2(50)    NOT NULL,
  imgFile               VARCHAR2(50),
  category              VARCHAR2(50)    NOT NULL,
  plants                VARCHAR2(100)    NOT NULL,
  character        VARCHAR2(100),
  growperiod            VARCHAR2(100),
  growenv               VARCHAR2(100),
  difflevel             VARCHAR2(100),
  reason                VARCHAR2(500)
);


/*------------------------------시퀀스 create--------------------------------*/


CREATE SEQUENCE board_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;


CREATE SEQUENCE comment_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;


CREATE SEQUENCE diary_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;


CREATE SEQUENCE plant_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;


CREATE SEQUENCE mbti_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

/*-----------------------------------update---------------------------------*/
/* freeboard 테이블 insert */
INSERT INTO hboard (boardidx, userid, title, content, ofile, sfile) VALUES (
  board_seq.NEXTVAL, 6, '텃밭에 상추 심기', '오늘은 상추를 심었어요. 흙 준비부터 씨앗 심기까지 완료!', 'lettuce.jpg', 'lettuce_2025.jpg'
);

INSERT INTO hboard (boardidx, userid, title, content) VALUES (
  board_seq.NEXTVAL, 7, '비가 와서 걱정이네요', '장마가 시작됐어요. 식물 뿌리 썩을까봐 걱정입니다.'
);

INSERT INTO hboard (boardidx, userid, title, content, ofile, sfile) VALUES (
  board_seq.NEXTVAL, 8, '잡초 제거 팁', '잡초는 아침 일찍 뽑는 게 제일 효과적입니다!', 'weed.jpg', 'weed_2025.jpg'
);

INSERT INTO hboard (boardidx, userid, title, content) VALUES (
  board_seq.NEXTVAL, 9, '오늘의 수확', '방울토마토랑 고추를 수확했어요. 색도 곱고 맛도 좋아요!'
);

INSERT INTO hboard (boardidx, userid, title, content) VALUES (
  board_seq.NEXTVAL, 10, '병충해 방제 질문', '잎에 점이 생겼는데 무슨 병인지 아시는 분 계신가요?'
);

/* galleryboard insert */
INSERT INTO hboard (boardidx, userid, title, content, ofile, sfile, category) VALUES (
  board_seq.NEXTVAL, 6, '토마토가 안 자라요', '물을 주고 있는데도 토마토가 잘 자라지 않아요.', 'lettuce.jpg', 'lettuce_2025.jpg', 2
);

INSERT INTO hboard (boardidx, userid, title, content, category) VALUES (
  board_seq.NEXTVAL, 7, '수확 사진 공유합니다', '오늘 수확한 오이와 가지 사진입니다!', 2
);

INSERT INTO hboard (boardidx, userid, title, content, ofile, sfile, category) VALUES (
  board_seq.NEXTVAL, 8, '새싹 채소 키우기 도전', '작은 화분에 새싹 채소 심어봤어요.', 'weed.jpg', 'weed_2025.jpg', 2
);

INSERT INTO hboard (boardidx, userid, title, content, category) VALUES (
  board_seq.NEXTVAL, 9, '텃밭 분양 정보', '서울 지역 텃밭 분양 공고가 떴습니다.', 2
);

INSERT INTO hboard (boardidx, userid, title, content, category) VALUES (
  board_seq.NEXTVAL, 10, '병충해 방제 질문', '잎에 점이 생겼는데 무슨 병인지 아시는 분 계신가요?', 2
);

/* plantdict */ 
-- 1. 상추
INSERT INTO plantdict (
 plantidx, name, imgpath, growseason, bloomingseason, humidity, sunlight,
  temperaturemin, temperaturemax, summary
) VALUES (
  plant_seq.NEXTVAL, '상추', 'lettuce.jpg',
  '봄~여름', NULL, '보통', '햇빛 많은 곳',
  15.0, 25.0, '잎채소의 대표주자로 초보자에게 적합하며 빠르게 수확 가능'
);

-- 2. 방울토마토
INSERT INTO plantdict (
 plantidx, name, imgpath, growseason, bloomingseason, humidity, sunlight,
  temperaturemin, temperaturemax, summary
) VALUES (
  plant_seq.NEXTVAL, '방울토마토', 'tomato.jpg',
  '봄~초여름', '6~7월', '보통~약간 건조', '햇빛 매우 많은 곳',
  20.0, 30.0, '달콤한 열매가 인기 많은 작물로 일조량이 매우 중요함'
);

-- 3. 바질
INSERT INTO plantdict (
 plantidx, name, imgpath, growseason, bloomingseason, humidity, sunlight,
  temperaturemin, temperaturemax, summary
) VALUES (
  plant_seq.NEXTVAL, '바질', 'basil.jpg',
  '여름', '7~8월', '높음', '반양지~햇빛 많은 곳',
  18.0, 30.0, '허브의 일종으로 물 빠짐 좋은 흙과 따뜻한 온도를 선호'
);

-- 4. 고추
INSERT INTO plantdict (
 plantidx, name, imgpath, growseason, bloomingseason, humidity, sunlight,
  temperaturemin, temperaturemax, summary
) VALUES (
  plant_seq.NEXTVAL, '고추', 'pepper.jpg',
  '봄~여름', '6~9월', '보통', '햇빛 많은 곳',
  18.0, 30.0, '한 번 심으면 오랫동안 수확 가능한 대표적인 열매채소'
);

-- 5. 애플민트
INSERT INTO plantdict (
 plantidx, name, imgpath, growseason, bloomingseason, humidity, sunlight,
  temperaturemin, temperaturemax, summary
) VALUES (
  plant_seq.NEXTVAL, '애플민트', 'applemint.jpg',
  '봄~가을', '6~8월', '높음', '반그늘~햇빛',
  15.0, 28.0,'실내에서도 잘 자라며 상쾌한 향으로 인기가 높음'
);
-- 8.9 추가
-- 6. 루꼴라
INSERT INTO plantdict (
 plantidx, name, imgpath, growseason, bloomingseason, humidity, sunlight,
  temperaturemin, temperaturemax, summary
) VALUES (
  plant_seq.NEXTVAL, '루꼴라', 'arugula.jpg',
  '봄~가을', '5~7월', '중간', '햇빛',
  10.0, 25.0, '샐러드나 파스타에 활용되며 특유의 향과 맛이 있음'
);
-- 7. 스테비아
INSERT INTO plantdict (
 plantidx, name, imgpath, growseason, bloomingseason, humidity, sunlight,
  temperaturemin, temperaturemax, summary
) VALUES (
  plant_seq.NEXTVAL, '스테비아', 'stevia.jpg',
  '봄~가을', '7~9월', '중간', '햇빛',
  15.0, 30.0, '천연 감미료로 사용되며 달콤한 잎을 가짐'
);
-- 8. 애플수박
INSERT INTO plantdict (
 plantidx, name, imgpath, growseason, bloomingseason, humidity, sunlight,
  temperaturemin, temperaturemax, summary
) VALUES (
  plant_seq.NEXTVAL, '애플수박', 'apple_watermelon.jpg',
  '봄~여름', '7~8월', '중간', '햇빛',
  20.0, 35.0, '작은 크기와 달콤한 맛으로 가정 재배에 적합'
);
-- 9. 무
INSERT INTO plantdict (
 plantidx, name, imgpath, growseason, bloomingseason, humidity, sunlight,
  temperaturemin, temperaturemax, summary
) VALUES (
  plant_seq.NEXTVAL, '무', 'radish.jpg',
  '봄~가을', '4~11월', '중간', '햇빛',
  5.0, 25.0,'재배가 쉽고 다양한 요리에 활용되는 뿌리채소'
);
-- 10. 대파
INSERT INTO plantdict (
 plantidx, name, imgpath, growseason, bloomingseason, humidity, sunlight,
  temperaturemin, temperaturemax, summary
) VALUES (
  plant_seq.NEXTVAL, '대파', 'green_onion.jpg',
  '봄~가을', '5~10월', '중간', '햇빛',
  10.0, 28.0,  '요리에 필수적인 향채로 사계절 재배 가능'
);


/*----------------------------delete----------------------------------------*/
/* 테이블 삭제 */
DROP TABLE comments CASCADE CONSTRAINTS;
DROP TABLE hboard CASCADE CONSTRAINTS;
DROP TABLE diary CASCADE CONSTRAINTS;
DROP TABLE plantdict CASCADE CONSTRAINTS;
DROP TABLE members CASCADE CONSTRAINTS;
DROP TABLE mbti CASCADE CONSTRAINTS;

/* 시퀀스 삭제 */
DROP SEQUENCE plant_seq;
DROP SEQUENCE diary_seq;
DROP SEQUENCE board_seq;
DROP SEQUENCE comment_seq;
DROP SEQUENCE mbti_seq;

/*----------------------------commit----------------------------------------*/
commit;


