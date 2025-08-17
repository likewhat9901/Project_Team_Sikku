-- 1. 회원 데이터 생성 (10명의 도시농부들)
INSERT INTO members (userid, userpw, username, phonenumber, email, address) VALUES
('farmer001', 'password123', '김농부', '010-1111-1111', 'kimfarm@naver.com', '서울시 강남구 아파트 베란다');
INSERT INTO members (userid, userpw, username, phonenumber, email, address) VALUES
('greenthumbs', 'password123', '이초록', '010-2222-2222', 'greenlee@gmail.com', '부산시 해운대구 옥상정원');
INSERT INTO members (userid, userpw, username, phonenumber, email, address) VALUES
('plantveggie', 'password123', '박채소', '010-3333-3333', 'veggie@naver.com', '대구시 중구 텃밭');
INSERT INTO members (userid, userpw, username, phonenumber, email, address) VALUES
('herbgarden', 'password123', '최허브', '010-4444-4444', 'herb@daum.net', '인천시 남동구 베란다');
INSERT INTO members (userid, userpw, username, phonenumber, email, address) VALUES
('tomatoking', 'password123', '정토마토', '010-5555-5555', 'tomato@gmail.com', '광주시 서구 주말농장');
INSERT INTO members (userid, userpw, username, phonenumber, email, address) VALUES
('flowerlove', 'password123', '강꽃사랑', '010-6666-6666', 'flower@naver.com', '대전시 유성구 화분정원');
INSERT INTO members (userid, userpw, username, phonenumber, email, address) VALUES
('seedmaster', 'password123', '윤씨앗', '010-7777-7777', 'seed@daum.net', '울산시 남구 실내농장');
INSERT INTO members (userid, userpw, username, phonenumber, email, address) VALUES
('greenlife', 'password123', '임자연', '010-8888-8888', 'nature@gmail.com', '경기도 수원시 베란다');
INSERT INTO members (userid, userpw, username, phonenumber, email, address) VALUES
('urbanfarm', 'password123', '조도시', '010-9999-9999', 'urban@naver.com', '충북 청주시 옥상');
INSERT INTO members (userid, userpw, username, phonenumber, email, address) VALUES
('plantdoc', 'password123', '한식물', '010-1010-1010', 'plantdr@daum.net', '전남 목포시 텃밭');

-- 2. 게시판 데이터 생성 (카테고리1: 자유게시판 20개, 카테고리2: 정보게시판 20개)

-- 카테고리 1 게시물 (자유게시판 - 일상, 후기, 소통)
INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(1, 'farmer001', '베란다 텃밭 시작 3개월 후기', '아파트 베란다에서 상추와 토마토를 키우기 시작한지 3개월이 되었어요. 처음엔 걱정이 많았는데 지금은 매일 성장하는 모습을 보는 재미가 쏠쏠합니다!', 1, 45, 12);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(2, 'greenthumbs', '오늘 첫 수확한 방울토마토', '드디어 제가 키운 방울토마토를 수확했어요! 작지만 너무 달고 맛있네요. 옥상 정원에서 키우길 정말 잘한 것 같아요.', 1, 38, 15);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(3, 'plantveggie', '상추가 너무 잘 자라요', '씨앗부터 키운 상추가 이렇게 무성하게 자랄 줄 몰랐어요. 매일 샐러드로 먹을 수 있을 정도로 많이 났습니다.', 1, 23, 8);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(4, 'herbgarden', '허브 키우는 재미에 푹 빠졌어요', '바질, 로즈마리, 민트를 키우고 있는데 요리할 때마다 따서 쓸 수 있어서 너무 좋아요. 향도 진짜 좋고요!', 1, 31, 9);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(5, 'tomatoking', '주말농장 1년차 소감', '주말마다 농장에 가는 게 이렇게 힐링이 될 줄 몰랐어요. 땀 흘리며 일하는 것도 좋고, 수확의 기쁨도 큽니다.', 1, 52, 18);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(6, 'flowerlove', '꽃 키우기 vs 채소 키우기', '처음엔 꽃만 키웠는데 요즘은 채소도 키워보고 있어요. 둘 다 각각의 매력이 있는 것 같아요.', 1, 27, 6);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(7, 'seedmaster', '씨앗 발아 성공률 높이는 나만의 방법', '지금까지 여러 가지 씨앗을 키워보면서 터득한 발아 방법들을 공유해볼게요. 특히 온도와 습도 관리가 중요해요.', 1, 67, 22);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(8, 'greenlife', '아이와 함께 식물 키우기', '6살 딸과 함께 콩나물, 새싹채소를 키우고 있어요. 아이가 매일 물주는 걸 도와주면서 책임감도 기르고 있네요.', 1, 41, 14);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(9, 'urbanfarm', '옥상 정원 만들기 도전기', '옥상에 작은 정원을 만들어보고 있어요. 바람이 많이 불어서 걱정했는데 의외로 식물들이 잘 자라네요.', 1, 35, 10);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(10, 'plantdoc', '도시농부 1년차의 실패담과 교훈', '처음 시작할 때 많은 실수들이 있었어요. 물을 너무 많이 주거나, 햇빛을 잘못 계산하거나... 이런 경험들을 나누고 싶어요.', 1, 58, 16);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(11, 'farmer001', '겨울철 실내 재배 도전', '겨울에도 포기할 수 없어서 실내에서 LED 조명으로 키워보고 있어요. 생각보다 잘 되고 있어서 신기해요.', 1, 44, 11);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(12, 'greenthumbs', '이웃과 나누는 수확의 기쁨', '너무 많이 수확해서 이웃들과 나눠먹었어요. 다들 너무 좋아하셔서 뿌듯했습니다.', 1, 29, 13);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(13, 'plantveggie', '유기농 비료 직접 만들어 쓰기', '음식물쓰레기로 퇴비를 만들어서 사용하고 있어요. 환경도 생각하고 식물도 건강하게 키울 수 있어서 좋아요.', 1, 36, 8);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(14, 'herbgarden', '허브티 만들어 마시는 재미', '직접 키운 허브로 차를 우려마시면 향이 정말 좋아요. 스트레스도 풀리고 건강에도 좋은 것 같아요.', 1, 33, 9);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(15, 'tomatoking', '토마토 품종별 키워본 후기', '방울토마토, 일반토마토, 대추토마토를 모두 키워봤는데 각각 특징이 달라서 재미있었어요.', 1, 47, 15);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(16, 'flowerlove', '화분 DIY로 만든 나만의 정원', '예쁜 화분이 너무 비싸서 직접 만들어봤어요. 의외로 쉽고 예쁘게 나와서 만족해요.', 1, 25, 7);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(17, 'seedmaster', '다양한 씨앗 교환하고 싶어요', '여러 품종의 씨앗을 키워보고 싶은데 너무 많이 사기엔 부담스러워서... 서로 교환하실 분 계신가요?', 1, 62, 20);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(18, 'greenlife', '식물 키우며 달라진 생활 패턴', '식물을 키우기 시작하면서 일찍 일어나서 물주고, 상태 확인하는 게 습관이 되었어요. 생활이 더 규칙적이고 건강해진 느낌이에요.', 1, 39, 12);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(19, 'urbanfarm', '도시에서 농부되기의 어려움', '공간의 한계, 일조량 부족 등 여러 어려움이 있지만 그래도 포기할 수 없는 매력이 있어요.', 1, 51, 14);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(20, 'plantdoc', '올 한해 키운 식물들 총정리', '올해 키워본 식물들을 정리해보니 정말 많은 종류를 시도해봤네요. 내년엔 더 체계적으로 계획을 세워볼 예정이에요.', 1, 43, 17);

-- 카테고리 2 게시물 (정보게시판 - 재배법, 팁, 질문답변)
INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(21, 'plantdoc', '상추 재배법 완벽 가이드', '상추를 처음 키우시는 분들을 위한 상세한 재배법입니다. 파종부터 수확까지 단계별로 설명드릴게요. 1) 종자 선택 2) 파종 방법 3) 물주기 4) 수확 시기', 2, 89, 35);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(22, 'tomatoking', '토마토 지주대 설치하는 올바른 방법', '토마토가 자라면서 쓰러지지 않도록 지주대를 설치하는 방법을 알려드려요. 적절한 높이와 고정 방법이 중요합니다.', 2, 76, 28);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(23, 'seedmaster', '씨앗 보관법과 발아율 높이는 팁', '씨앗을 올바르게 보관하고 발아율을 높이는 방법들을 정리해봤습니다. 온도, 습도, 빛 조건이 모두 중요해요.', 2, 92, 41);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(24, 'herbgarden', '베란다에서 키우기 좋은 허브 종류', '공간이 한정된 베란다에서도 잘 자라는 허브들을 추천드려요. 바질, 파슬리, 민트, 로즈마리 등의 특징과 재배법을 설명합니다.', 2, 67, 24);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(25, 'greenthumbs', '물주기 타이밍 판단하는 방법', '식물별로 다른 물주기 주기와 물이 필요한 시점을 판단하는 방법을 알려드려요. 흙의 상태, 잎의 변화 등을 관찰하세요.', 2, 84, 32);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(26, 'urbanfarm', '햇빛 부족한 곳에서 키울 수 있는 식물들', '일조량이 부족한 환경에서도 잘 자라는 식물들을 소개합니다. 실내나 반그늘에서도 건강하게 키울 수 있어요.', 2, 73, 26);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(27, 'flowerlove', '천연 살충제 만들어 사용하기', '화학 농약 대신 사용할 수 있는 천연 살충제 제조법을 알려드려요. 마늘, 계피, 비누 등을 활용한 방법들입니다.', 2, 95, 38);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(28, 'farmer001', '겨울철 식물 관리 요령', '추운 겨울철에 식물들을 건강하게 관리하는 방법들을 정리했습니다. 온도, 습도, 환기 등에 주의해야 할 점들이 있어요.', 2, 81, 30);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(29, 'plantveggie', '유기농 비료 종류와 사용법', '화학비료 대신 사용할 수 있는 다양한 유기농 비료들을 소개하고 올바른 사용법을 알려드려요. 깻묵, 계분, 퇴비 등의 특징을 설명합니다.', 2, 88, 33);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(30, 'greenlife', '아이와 함께 할 수 있는 쉬운 원예 활동', '어린이들과 함께 할 수 있는 간단하고 재미있는 식물 키우기 활동들을 소개합니다. 콩나물, 새싹채소부터 시작해보세요.', 2, 71, 25);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(31, 'plantdoc', '식물 병충해 진단과 대처법', '자주 발생하는 식물 병충해의 증상과 대처법을 정리했습니다. 조기 발견과 적절한 처치가 중요해요.', 2, 97, 42);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(32, 'tomatoking', '토마토 순따기와 곁순제거 방법', '토마토의 생산량을 늘리고 건강하게 키우기 위한 순따기 방법을 사진과 함께 설명드려요.', 2, 79, 29);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(33, 'seedmaster', '씨앗부터 키우기 vs 모종 심기 비교', '씨앗부터 키우는 것과 모종을 구입해서 키우는 것의 장단점을 비교해봤습니다. 상황에 맞는 선택을 해보세요.', 2, 86, 31);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(34, 'herbgarden', '허브 수확 시기와 보관 방법', '허브별로 최적의 수확 시기와 수확 후 보관하는 방법을 알려드려요. 신선하게 오래 보관하는 팁도 포함되어 있습니다.', 2, 74, 27);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(35, 'greenthumbs', '화분 크기 선택하는 기준', '식물의 종류와 성장 단계에 따른 적절한 화분 크기 선택법을 알려드려요. 너무 크거나 작으면 성장에 방해가 될 수 있어요.', 2, 68, 23);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(36, 'urbanfarm', '베란다 텃밭 설계하는 방법', '한정된 베란다 공간을 효율적으로 활용해서 텃밭을 만드는 방법을 소개합니다. 동선과 채광을 고려한 배치가 중요해요.', 2, 91, 36);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(37, 'flowerlove', '계절별 심을 수 있는 채소 달력', '봄, 여름, 가을, 겨울 각 계절에 심을 수 있는 채소들을 달력 형태로 정리했습니다. 파종 시기를 놓치지 마세요.', 2, 105, 45);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(38, 'farmer001', '실내 공기정화 식물 추천', '실내 공기를 정화하는 효과가 좋은 식물들을 소개합니다. 키우기 쉽고 관리가 간편한 품종들로 선별했어요.', 2, 82, 34);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(39, 'plantveggie', '연작 피해 방지하는 방법', '같은 자리에서 계속 같은 작물을 키울 때 발생하는 연작 피해를 방지하는 방법들을 설명드려요. 작물 순환의 중요성을 알아보세요.', 2, 77, 28);

INSERT INTO hboard (boardidx, userid, title, content, category, visitcount, likes) VALUES
(40, 'greenlife', '초보자를 위한 필수 원예 도구', '식물 키우기를 시작할 때 꼭 필요한 기본 도구들을 소개합니다. 처음엔 이 정도면 충분해요.', 2, 93, 39);

-- 3. 댓글 데이터 생성 (일부 게시물에)
INSERT INTO comments (commentidx, userid, boardidx, content, likes) VALUES
(1, 'greenthumbs', 1, '저도 베란다 텃밭 시작해보고 싶어요! 혹시 어떤 화분 사용하셨나요?', 5);
INSERT INTO comments (commentidx, userid, boardidx, content, likes) VALUES
(2, 'plantveggie', 1, '3개월이면 정말 많이 자랐을 것 같아요. 사진 올려주세요!', 3);
INSERT INTO comments (commentidx, userid, boardidx, content, likes) VALUES
(3, 'farmer001', 2, '방울토마토 진짜 달죠! 저도 키우고 있는데 수확할 때마다 뿌듯해요.', 4);
INSERT INTO comments (commentidx, userid, boardidx, content, likes) VALUES
(4, 'herbgarden', 21, '상추 재배법 정말 자세하네요. 초보자에게 큰 도움이 됩니다!', 8);
INSERT INTO comments (commentidx, userid, boardidx, content, likes) VALUES
(5, 'tomatoking', 21, '물주기 부분 특히 유용했어요. 감사합니다!', 6);
INSERT INTO comments (commentidx, userid, boardidx, content, likes) VALUES
(6, 'seedmaster', 22, '지주대 높이를 몰라서 고민이었는데 해결됐어요!', 4);
INSERT INTO comments (commentidx, userid, boardidx, content, likes) VALUES
(7, 'urbanfarm', 23, '발아율이 낮아서 고민이었는데 이 방법 써보겠어요.', 7);
INSERT INTO comments (commentidx, userid, boardidx, content, likes) VALUES
(8, 'flowerlove', 24, '로즈마리 키우고 싶었는데 베란다에서도 가능한가 봐요!', 3);
INSERT INTO comments (commentidx, userid, boardidx, content, likes) VALUES
(9, 'greenlife', 27, '천연 살충제 레시피 정말 유용해요. 바로 만들어봐야겠어요.', 9);
INSERT INTO comments (commentidx, userid, boardidx, content, likes) VALUES
(10, 'plantdoc', 37, '계절별 달력 정말 필요했어요. 저장해둘게요!', 11);

-- 4. 좋아요 데이터 생성 (일부 게시물에)
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (1, 'greenthumbs');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (1, 'plantveggie');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (1, 'herbgarden');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (2, 'farmer001');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (2, 'tomatoking');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (21, 'herbgarden');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (21, 'tomatoking');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (21, 'seedmaster');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (22, 'seedmaster');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (23, 'urbanfarm');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (37, 'plantdoc');
INSERT INTO hlike (BOARD_IDX, USER_ID) VALUES (37, 'flowerlove');

-- 5. 게시물 이미지 데이터 생성 (일부 게시물에)
INSERT INTO BOARD_IMAGE (BOARD_IDX, ORIGINAL_NAME, SAVED_NAME, FILEPATH) VALUES
(1, 'tomato_harvest.jpg', '20240801_tomato_001.jpg', '/uploads/images/');
INSERT INTO BOARD_IMAGE (BOARD_IDX, ORIGINAL_NAME, SAVED_NAME, FILEPATH) VALUES
(2, 'cherry_tomato.jpg', '20240802_cherry_001.jpg', '/uploads/images/');
INSERT INTO BOARD_IMAGE (BOARD_IDX, ORIGINAL_NAME, SAVED_NAME, FILEPATH) VALUES
(21, 'lettuce_guide.jpg', '20240803_lettuce_001.jpg', '/uploads/images/');
INSERT INTO BOARD_IMAGE (BOARD_IDX, ORIGINAL_NAME, SAVED_NAME, FILEPATH) VALUES
(22, 'tomato_support.jpg', '20240804_support_001.jpg', '/uploads/images/');

-- 6. 신고 데이터 생성 (일부 게시물에)
INSERT INTO BOARD_REPORT (BOARD_IDX, USER_ID, CONTENT) VALUES
(15, 'plantdoc', '스팸성 게시물로 보임');
INSERT INTO BOARD_REPORT (BOARD_IDX, USER_ID, CONTENT) VALUES
(28, 'farmer001', '부적절한 내용 포함');