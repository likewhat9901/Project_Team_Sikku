alter session set "_ORACLE_SCRIPT"=true;
create user musthave identified by 1234;
grant connect, resource, unlimited tablespace to musthave;

/* listner 문제 */
show parameter local_listener;
show parameter service_names;
alter system set local_listener='(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))' scope=both;



/*-------------------------테이블 create-----------------------------------*/
/*member*/
CREATE TABLE hmember (
  memberidx     NUMBER         PRIMARY KEY,
  userid         VARCHAR2(20)   NOT NULL UNIQUE,
  password       VARCHAR2(50)   NOT NULL,
  email          VARCHAR2(30)   UNIQUE,
  address        VARCHAR2(100),
  username       VARCHAR2(20)   NOT NULL UNIQUE,
  phonenumber    VARCHAR2(20)   NOT NULL,
  role           NUMBER(2)      NOT NULL CHECK (role IN (0, 1)),
  grade          NUMBER(1)      DEFAULT 1 CHECK (grade IN (1, 2, 3)), 
  created_at     DATE DEFAULT SYSDATE
);


/*board - */
CREATE TABLE hboard (
  board_idx     NUMBER          PRIMARY KEY,
  member_idx   NUMBER          NOT NULL,
  title        VARCHAR2(100)   NOT NULL,
  content      CLOB            NOT NULL,
  ofile        VARCHAR2(255),
  sfile        VARCHAR2(255),
  postdate     DATE            DEFAULT SYSDATE,              
  category     NUMBER(1)       DEFAULT 1 CHECK (category IN (1, 2)),
  visitcount   NUMBER          DEFAULT 0,  
  likes        NUMBER          DEFAULT 0,
  report       NUMBER          DEFAULT 0,
  CONSTRAINT fk_board_member FOREIGN KEY (member_idx) REFERENCES hmember(member_idx)
);

/*comment*/
CREATE TABLE comments (
  comment_idx   NUMBER PRIMARY KEY,
  member_idx    NUMBER NOT NULL,
  board_idx      NUMBER NOT NULL,
  likes        NUMBER          DEFAULT 0,
  content       VARCHAR2(500) NOT NULL,
  postdate    DATE DEFAULT SYSDATE,
  CONSTRAINT fk_comment_board FOREIGN KEY (board_idx) REFERENCES hboard(board_idx),
  CONSTRAINT fk_comment_member FOREIGN KEY (member_idx) REFERENCES hmember(member_idx)
);


/*diary*/
CREATE TABLE diary (
  diary_idx     NUMBER          PRIMARY KEY,   
  member_idx    NUMBER          NOT NULL,
  ofile         VARCHAR2(255),     
  sfile         VARCHAR2(255),     
  postdate      DATE            DEFAULT SYSDATE,
  description   VARCHAR2(500),                  
  temperature   NUMBER(5, 2),        
  humidity      NUMBER(5, 2),      
  sunlight      NUMBER(5, 2),   
  CONSTRAINT fk_diary_member FOREIGN KEY (member_idx) REFERENCES hmember(member_idx)
);


/*info*/
CREATE TABLE info (
  plant_idx         NUMBER         PRIMARY KEY,
  name              VARCHAR2(100)  NOT NULL,
  ofile             VARCHAR2(255),
  sfile             VARCHAR2(255),
  grow_season       VARCHAR2(50),
  blooming_season   VARCHAR2(50),
  humidity          VARCHAR2(50),
  sunlight          VARCHAR2(50),
  temperature_min   NUMBER(5,2),
  temperature_max   NUMBER(5,2),
  postdate          DATE DEFAULT SYSDATE,
  member_idx        NUMBER,
  description       VARCHAR2(255),
  CONSTRAINT fk_plant_member FOREIGN KEY (member_idx) REFERENCES hmember(member_idx)
);

/*mbti*/
CREATE TABLE mbti (
  mbtiIdx           NUMBER         PRIMARY KEY,
  name              VARCHAR2(100)  NOT NULL,
  imgFile           VARCHAR2(100)  NOT NULL,
  description       VARCHAR2(500)
);


/*------------------------------시퀀스 create--------------------------------*/
CREATE SEQUENCE member_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;


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
/* member 테이블 insert */
/* 사용자 - 8 */
INSERT INTO hmember (member_idx, userid, password, email, address, username, phonenumber, role) VALUES (
  member_seq.NEXTVAL, 'user01', '1234', 'user01@example.com', '서울특별시 강남구 테헤란로 1', '홍길동', '010-1111-1111', 0
);
INSERT INTO hmember (member_idx, userid, password, email, address, username, phonenumber, role) VALUES (
  member_seq.NEXTVAL, 'user02', '1234', 'user02@example.com', '부산광역시 해운대구 우동 123', '김철수', '010-2222-2222', 0
);
INSERT INTO hmember (member_idx, userid, password, email, address, username, phonenumber, role) VALUES (
  member_seq.NEXTVAL, 'user03', '1234', 'user03@example.com', '대구광역시 수성구 범어동 456', '이영희', '010-3333-3333', 0
);
INSERT INTO hmember (member_idx, userid, password, email, address, username, phonenumber, role) VALUES (
  member_seq.NEXTVAL, 'user04', '1234', 'user04@example.com', '인천광역시 연수구 송도동 789', '박민수', '010-4444-4444', 0
);
INSERT INTO hmember (member_idx, userid, password, email, address, username, phonenumber, role) VALUES (
  member_seq.NEXTVAL, 'user05', '1234', 'user05@example.com', '서울특별시 강남구 테헤란로 1', '이한이', '010-1111-1111', 0
);
INSERT INTO hmember (member_idx, userid, password, email, address, username, phonenumber, role) VALUES (
  member_seq.NEXTVAL, 'user06', '1234', 'user06@example.com', '부산광역시 해운대구 우동 123', '김동수', '010-2222-2222', 0
);
INSERT INTO hmember (member_idx, userid, password, email, address, username, phonenumber, role) VALUES (
  member_seq.NEXTVAL, 'user07', '1234', 'user07@example.com', '대구광역시 수성구 범어동 456', '박천', '010-3333-3333', 0
);
INSERT INTO hmember (member_idx, userid, password, email, address, username, phonenumber, role) VALUES (
  member_seq.NEXTVAL, 'user08', '1234', 'user08@example.com', '인천광역시 연수구 송도동 789', '박진경', '010-4444-4444', 0
);
/* 관리자 - 2 */
INSERT INTO hmember (member_idx, userid, password, email, address, username, phonenumber, role) VALUES (
  member_seq.NEXTVAL, 'admin01','1234', 'admin01@example.com', '광주광역시 북구 일곡동 101', '가나디', '010-5555-5555', 1
);
INSERT INTO hmember (member_idx, userid, password, email, address, username, phonenumber, role) VALUES (
  member_seq.NEXTVAL, 'admin02','1234', 'admin02@example.com', '광주광역시 북구 일곡동 101', '하츄핑', '010-5555-5555', 1
);


/* freeboard 테이블 insert */
INSERT INTO hboard (board_idx, member_idx, title, content, ofile, sfile) VALUES (
  board_seq.NEXTVAL, 6, '텃밭에 상추 심기', '오늘은 상추를 심었어요. 흙 준비부터 씨앗 심기까지 완료!', 'lettuce.jpg', 'lettuce_2025.jpg'
);

INSERT INTO hboard (board_idx, member_idx, title, content) VALUES (
  board_seq.NEXTVAL, 7, '비가 와서 걱정이네요', '장마가 시작됐어요. 식물 뿌리 썩을까봐 걱정입니다.'
);

INSERT INTO hboard (board_idx, member_idx, title, content, ofile, sfile) VALUES (
  board_seq.NEXTVAL, 8, '잡초 제거 팁', '잡초는 아침 일찍 뽑는 게 제일 효과적입니다!', 'weed.jpg', 'weed_2025.jpg'
);

INSERT INTO hboard (board_idx, member_idx, title, content) VALUES (
  board_seq.NEXTVAL, 9, '오늘의 수확', '방울토마토랑 고추를 수확했어요. 색도 곱고 맛도 좋아요!'
);

INSERT INTO hboard (board_idx, member_idx, title, content) VALUES (
  board_seq.NEXTVAL, 10, '병충해 방제 질문', '잎에 점이 생겼는데 무슨 병인지 아시는 분 계신가요?'
);

/* galleryboard insert */
INSERT INTO hboard (board_idx, member_idx, title, content, ofile, sfile, category) VALUES (
  board_seq.NEXTVAL, 6, '토마토가 안 자라요', '물을 주고 있는데도 토마토가 잘 자라지 않아요.', 'lettuce.jpg', 'lettuce_2025.jpg', 2
);

INSERT INTO hboard (board_idx, member_idx, title, content, category) VALUES (
  board_seq.NEXTVAL, 7, '수확 사진 공유합니다', '오늘 수확한 오이와 가지 사진입니다!', 2
);

INSERT INTO hboard (board_idx, member_idx, title, content, ofile, sfile, category) VALUES (
  board_seq.NEXTVAL, 8, '새싹 채소 키우기 도전', '작은 화분에 새싹 채소 심어봤어요.', 'weed.jpg', 'weed_2025.jpg', 2
);

INSERT INTO hboard (board_idx, member_idx, title, content, category) VALUES (
  board_seq.NEXTVAL, 9, '텃밭 분양 정보', '서울 지역 텃밭 분양 공고가 떴습니다.', 2
);

INSERT INTO hboard (board_idx, member_idx, title, content, category) VALUES (
  board_seq.NEXTVAL, 10, '병충해 방제 질문', '잎에 점이 생겼는데 무슨 병인지 아시는 분 계신가요?', 2
);


/* comment 테이블 insert */
INSERT INTO comments (comment_idx, member_idx, board_idx, content) VALUES (
  comment_seq.NEXTVAL, 6, 1, '좋은 정보 감사합니다! 저도 상추 심어볼게요.'
);

INSERT INTO comments (comment_idx, member_idx, board_idx, content) VALUES (
  comment_seq.NEXTVAL, 7, 2, '비 많이 오면 흙 배수 잘 되게 해야 해요!'
);

INSERT INTO comments (comment_idx, member_idx, board_idx, content) VALUES (
  comment_seq.NEXTVAL, 8, 3, '잡초 제거 팁 유용하네요. 저도 새벽에 해봐야겠어요.'
);

INSERT INTO comments (comment_idx, member_idx, board_idx, content) VALUES (
  comment_seq.NEXTVAL, 9, 5, '저도 같은 병 있었는데 칼슘 부족일 수 있어요.'
);

INSERT INTO comments (comment_idx, member_idx, board_idx, content) VALUES (
  comment_seq.NEXTVAL, 10, 7, '분양 정보 감사합니다. 신청해볼게요!'
);


/* info 테이블 insert */
-- 1. 상추 (봄, 여름용 채소)
INSERT INTO info (
  plant_idx, name, ofile, sfile, grow_season, blooming_season, humidity, sunlight,
  temperature_min, temperature_max, member_idx, description
) VALUES (
  plant_seq.NEXTVAL, '상추', 'lettuce.jpg', 'lettuce_2025.jpg', 
  '봄~여름', NULL, '보통', '햇빛 많은 곳',
  15.0, 25.0, 10, '잎채소의 대표주자로 초보자에게 적합하며 빠르게 수확 가능'
);

-- 2. 방울토마토
INSERT INTO info (
  plant_idx, name, ofile, sfile, grow_season, blooming_season, humidity, sunlight,
  temperature_min, temperature_max, member_idx, description
) VALUES (
  plant_seq.NEXTVAL, '방울토마토', 'tomato.jpg', 'tomato_2025.jpg',
  '봄~초여름', '6~7월', '보통~약간 건조', '햇빛 매우 많은 곳',
  20.0, 30.0, 10, '달콤한 열매가 인기 많은 작물로 일조량이 매우 중요함'
);

-- 3. 바질
INSERT INTO info (
  plant_idx, name, ofile, sfile, grow_season, blooming_season, humidity, sunlight,
  temperature_min, temperature_max, member_idx, description
) VALUES (
  plant_seq.NEXTVAL, '바질', 'basil.jpg', 'basil_2025.jpg',
  '여름', '7~8월', '높음', '반양지~햇빛 많은 곳',
  18.0, 30.0, 10, '허브의 일종으로 물 빠짐 좋은 흙과 따뜻한 온도를 선호'
);

-- 4. 고추
INSERT INTO info (
  plant_idx, name, ofile, sfile, grow_season, blooming_season, humidity, sunlight,
  temperature_min, temperature_max, member_idx, description
) VALUES (
  plant_seq.NEXTVAL, '고추', 'pepper.jpg', 'pepper_2025.jpg',
  '봄~여름', '6~9월', '보통', '햇빛 많은 곳',
  18.0, 30.0, 10, '한 번 심으면 오랫동안 수확 가능한 대표적인 열매채소'
);

-- 5. 애플민트
INSERT INTO info (
  plant_idx, name, ofile, sfile, grow_season, blooming_season, humidity, sunlight,
  temperature_min, temperature_max, member_idx, description
) VALUES (
  plant_seq.NEXTVAL, '애플민트', 'applemint.jpg', 'applemint_2025.jpg',
  '봄~가을', '6~8월', '높음', '반그늘~햇빛',
  15.0, 28.0, 10, '실내에서도 잘 자라며 상쾌한 향으로 인기가 높음'
);
-- 8.9 추가
-- 6. 루꼴라
INSERT INTO info (
  plant_idx, name, ofile, sfile, grow_season, blooming_season, humidity, sunlight,
  temperature_min, temperature_max, member_idx, description
) VALUES (
  plant_seq.NEXTVAL, '루꼴라', 'arugula.jpg', 'arugula_2025.jpg',
  '봄~가을', '5~7월', '중간', '햇빛',
  10.0, 25.0, 10, '샐러드나 파스타에 활용되며 특유의 향과 맛이 있음'
);
-- 7. 스테비아
INSERT INTO info (
  plant_idx, name, ofile, sfile, grow_season, blooming_season, humidity, sunlight,
  temperature_min, temperature_max, member_idx, description
) VALUES (
  plant_seq.NEXTVAL, '스테비아', 'stevia.jpg', 'stevia_2025.jpg',
  '봄~가을', '7~9월', '중간', '햇빛',
  15.0, 30.0, 10, '천연 감미료로 사용되며 달콤한 잎을 가짐'
);
-- 8. 애플수박
INSERT INTO info (
  plant_idx, name, ofile, sfile, grow_season, blooming_season, humidity, sunlight,
  temperature_min, temperature_max, member_idx, description
) VALUES (
  plant_seq.NEXTVAL, '애플수박', 'apple_watermelon.jpg', 'apple_watermelon_2025.jpg',
  '봄~여름', '7~8월', '중간', '햇빛',
  20.0, 35.0, 10, '작은 크기와 달콤한 맛으로 가정 재배에 적합'
);
-- 9. 무
INSERT INTO info (
  plant_idx, name, ofile, sfile, grow_season, blooming_season, humidity, sunlight,
  temperature_min, temperature_max, member_idx, description
) VALUES (
  plant_seq.NEXTVAL, '무', 'radish.jpg', 'radish_2025.jpg',
  '봄~가을', '4~11월', '중간', '햇빛',
  5.0, 25.0, 10, '재배가 쉽고 다양한 요리에 활용되는 뿌리채소'
);
-- 10. 대파
INSERT INTO info (
  plant_idx, name, ofile, sfile, grow_season, blooming_season, humidity, sunlight,
  temperature_min, temperature_max, member_idx, description
) VALUES (
  plant_seq.NEXTVAL, '대파', 'green_onion.jpg', 'green_onion_2025.jpg',
  '봄~가을', '5~10월', '중간', '햇빛',
  10.0, 28.0, 10, '요리에 필수적인 향채로 사계절 재배 가능'
);




/* diary 테이블 insert */
INSERT INTO diary (diary_idx, member_idx, ofile, sfile, description, temperature, humidity, sunlight) VALUES (
  diary_seq.NEXTVAL, 6, 'lettuce_day1.jpg', 'lettuce_day1_2025.jpg', '상추를 처음 심은 날. 기대된다!', 22.5, 65.0, 300.0
);

INSERT INTO diary (diary_idx, member_idx, ofile, sfile, description, temperature, humidity, sunlight) VALUES (
  diary_seq.NEXTVAL, 7, 'watering.jpg', 'watering_2025.jpg', '아침 일찍 물을 듬뿍 줬다.', 21.0, 70.5, 280.0
);

INSERT INTO diary (diary_idx, member_idx, ofile, sfile, description, temperature, humidity, sunlight) VALUES (
  diary_seq.NEXTVAL, 8, 'tomato_growth.jpg', 'tomato_growth_2025.jpg', '토마토가 조금씩 열리기 시작했다.', 25.2, 60.0, 350.0
);

INSERT INTO diary (diary_idx, member_idx, ofile, sfile, description, temperature, humidity, sunlight) VALUES (
  diary_seq.NEXTVAL, 9, 'rainy_day.jpg', 'rainy_day_2025.jpg', '오늘은 하루종일 비가 내려서 물주기는 쉬었다.', 20.0, 80.0, 100.0
);

INSERT INTO diary (diary_idx, member_idx, ofile, sfile, description, temperature, humidity, sunlight) VALUES (
  diary_seq.NEXTVAL, 10, 'harvest_day.jpg', 'harvest_day_2025.jpg', '첫 수확! 토마토와 고추가 탐스럽다.', 26.7, 55.5, 400.0
);


/* mbti 테이블 insert */
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'intj', 'intj.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'intp', 'intp.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'entj', 'entj.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'entp', 'entp.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'infj', 'infj.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'infp', 'infp.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'enfj', 'enfj.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'enfp', 'enfp.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'istj', 'istj.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'isfj', 'isfj.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'estj', 'estj.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'esfj', 'esfj.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'istp', 'istp.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'isfp', 'isfp.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'estp', 'estp.jpg', '성격별 Description');
INSERT INTO mbti VALUES (
  mbti_seq.NEXTVAL, 'esfp', 'esfp.jpg', '성격별 Description');

/*----------------------------delete----------------------------------------*/
/* 테이블 삭제 */
DROP TABLE comments CASCADE CONSTRAINTS;
DROP TABLE hboard CASCADE CONSTRAINTS;
DROP TABLE diary CASCADE CONSTRAINTS;
DROP TABLE info CASCADE CONSTRAINTS;
DROP TABLE hmember CASCADE CONSTRAINTS;

/* 시퀀스 삭제 */
DROP SEQUENCE plant_seq;
DROP SEQUENCE diary_seq;
DROP SEQUENCE board_seq;
DROP SEQUENCE comment_seq;
DROP SEQUENCE member_seq;

/*----------------------------delete----------------------------------------*/
commit;
