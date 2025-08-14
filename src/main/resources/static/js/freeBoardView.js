

/**
 댓글 수정을 위한 JS
 */
 
 // 댓글 수정 폼을 토글하는 함수
 function toggleEditForm(commentIdx) {
     console.log('Toggle edit form for comment:', commentIdx);
     
     // 해당 commentIdx에 맞는 폼 요소를 찾아 변수에 담음
     const form = document.getElementById(`editForm-${commentIdx}`);
     const contentDiv = document.getElementById(`content-${commentIdx}`);
     const editBtn = document.getElementById(`editBtn-${commentIdx}`);
     const actionsDiv = document.getElementById(`actions-${commentIdx}`); // 새로 추가된 부분
     
     // 폼 요소가 제대로 찾아졌는지 확인합니다.
     if (form && contentDiv && editBtn && actionsDiv) {
         if (form.style.display === "none" || form.style.display === "") {
             // 수정 모드로 전환
             form.style.display = "block";
             contentDiv.style.display = "none";
             
             // 수정/삭제 버튼을 포함하는 div 숨기기
             actionsDiv.style.display = "none"; 
         } else {
             // 일반 모드로 전환
             form.style.display = "none";
             contentDiv.style.display = "block";
             
             // 수정/삭제 버튼을 포함하는 div 다시 보이기
             actionsDiv.style.display = "flex"; // flexbox 사용 시 flex로, block 사용 시 block으로
         }
     } else {
         console.error(`Error: Elements not found for commentIdx: ${commentIdx}`);
         console.error('Form:', form);
         console.error('Content div:', contentDiv);
         console.error('Edit button:', editBtn);
         console.error('Actions div:', actionsDiv); // 에러 메시지 추가
     }
 }

 // 수정 폼 제출 전 검증
 function validateEditForm(commentIdx) {
     const form = document.getElementById(`editForm-${commentIdx}`);
     const textarea = form.querySelector('textarea[name="content"]');
     
     if (!textarea.value.trim()) {
         alert('댓글 내용을 입력해주세요.');
         textarea.focus();
         return false;
     }
     
     return confirm('댓글을 수정하시겠습니까?');
 }

 // 댓글 삭제 확인
 function confirmDeleteWithLink(url) {
     if (confirm("정말로 삭제하시겠습니까?")) {
         window.location.href = url;
         return true;
     }
     return false;
 }

 // 댓글 작성 폼 검증
 function validateCommentForm() {
     const textarea = document.querySelector('form[action="/boards/free/freeBoardCommentWriteProc.do"] textarea[name="content"]');

	      if (textarea.value.trim() == '' ) {
         alert('댓글 내용을 입력해주세요.');
         textarea.focus();
         return false;
     }
     
     return true;
 }

 // 페이지 로드 시 초기화
 document.addEventListener('DOMContentLoaded', function() {
     console.log('Page loaded, initializing comment system');
     
     // 모든 수정 폼을 숨김 상태로 초기화
     const editForms = document.querySelectorAll('[id^="editForm-"]');
     editForms.forEach(form => {
         form.style.display = 'none';
     });
 });
 
 
 /**
  좋아요 비동기 방식을 위한 JS
  */
 /* 'DOMContentLoaded'
 	-> HTML 문서가 완전히 로드되고 DOM 트리가 완성된 후 스크립트를 실행 */
  document.addEventListener('DOMContentLoaded', function() {
      const likeButton = document.getElementById('board-like-btn');
      const likesCountSpan = document.getElementById('likes-count');
      const heartIcon = document.getElementById('heart-icon');

      if (likeButton) {
          const boardIdx = likeButton.getAttribute('data-board-idx');
		  
		  // 좋아요 상태 갱신 함수
          function updateLikeStatus() {
              fetch(`/boards/free/getLikeStatus.do?boardIdx=${boardIdx}`)
                  .then(response => response.json())
                  .then(data => {
                      if (data.success) {
                          likesCountSpan.textContent = data.likesCount;
                          heartIcon.textContent = data.isLiked ? '🧡' : '🤍';
                          console.log('페이지 로드 시 좋아요 상태 반영 완료');
                      } else {
                          console.error('서버 에러:', data.message);
                      }
                  })
                  .catch(error => {
                      console.error('좋아요 상태 불러오기 실패:', error);
                  });
          }
		  
          likeButton.addEventListener('click', function() {

			  // Fetch API를 사용해 서버에 POST 요청
			  fetch('/boards/free/toggleLike.do', {
			      method: 'POST',
			      headers: {
			          'Content-Type': 'application/x-www-form-urlencoded' // 폼 데이터 형식
			      },
			      body: `boardIdx=${boardIdx}`  // 문자열로 key=value 전달
			  })
			  // 서버 응답을 JSON 형식으로 변환
			  .then(response => {
			                  console.log('서버 응답 상태:', response.status);
			                  return response.json();
			              })
			  .then(data => {
				console.log('서버 응답 데이터:', data);
			      if (data.success) {
			          likesCountSpan.textContent = data.likesCount;
					  if(data.isLiked) {
                          heartIcon.textContent = '🧡';
						  console.log('좋아요 추가됨 - 개수:', data.likesCount);
                      } else {
                          heartIcon.textContent = '🤍';
						  console.log('좋아요 취소됨 - 개수:', data.likesCount);
                      }
			      } else {
					console.error('서버 에러:', data.message);
			          alert(data.message);
			      }
			  })
              .catch(error => {
                  console.error('Error:', error);
                  alert('좋아요 요청에 실패했습니다.');
              });
          });
		  
		  updateLikeStatus();
      }
  });
 
 
 
 
 
 
 