<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" />
    <script src="https://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
	<meta charset="UTF-8">
	<link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
	<link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.0/css/line.css">
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
	<script src="//code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
	<title>Admin</title>
	<link href="${path}/resources/css/admin_css.css" rel="stylesheet"/>
	<link href="${path}/resources/css/adminProduct.css" rel="stylesheet"/>
</head>
<body>
	<div class="sidebar">
		<div class="logo-details">
			<i class='bx bxl-c-plus-plus'></i> <span class="logo_name">SWAN</span>
		</div>
		<ul class="nav-links">
			<li><a href="/swan"> <i class='bx bx-grid-alt'></i> <span
					class="links_name">HOME</span>
			</a></li>
			<li><a href="/admin/admin"> <i class='bx bx-box'></i> <span
					class="links_name">상품 관리</span>
			</a></li>
			<li><a href="/admin/orderList"> <i class='bx bx-list-ul'></i>
					<span class="links_name">주문 관리</span>
			</a></li>
			<li><a href="/admin/adminMember"> <i
					class='bx bx-pie-chart-alt-2'></i> <span class="links_name">회원
						관리</span>
			</a></li>
			<li><a href="/admin/adminQuestion"> <i
					class='bx bx-coin-stack'></i> <span class="links_name">문의사항
						관리</span>
			</a></li>
			<li class="log_out"><a href="/member/logout.me"> <i
					class='bx bx-log-out'></i> <span class="links_name">로그아웃</span>
			</a></li>
		</ul>
	</div>
	<section class="home-section">
		<nav>
			<div class="sidebar-button">
				<i class='bx bx-menu sidebarBtn'></i> <span class="dashboard">상품
					수정</span>
			</div>
		</nav>
		<form action="/admin/product_update" method="post" id="modifyForm">
			<div class="home-content">
				<div class="recent-sales box">
					<div class="container">
						<div class="content">
							<div class="user-details">
								<div class="input-box">
									<span class="details">상품 명</span> <input type="text"
										placeholder="Product's name" name="product_title"
										value="${productsInfo.product_title}">
								</div>
								<div class="input-box">
									<span class="details">상품 가격</span> <input type="text"
										placeholder="Product's price" name="product_price"
										value="${productsInfo.product_price}">
								</div>
								<div class="input-box">
									<span class="details">상품 재고</span> <input type="text"
										placeholder="Product's stock" name="product_stock"
										value="${productsInfo.product_stock}">
								</div>
							</div>
							<div class="input-box">
								<span class="details">상품 설명</span>
								<textarea placeholder="About Product" name="product_content">${productsInfo.product_content}</textarea>
							</div>
							<div>
								<input type="file" class="upload-name" value="첨부파일"
									id="fileItem" placeholder="첨부파일" name="uploadFile">
								<div id="uploadResult"></div>
							</div>
							<br>
							<div class="form_section">
                    			<div class="input-box bit">
                    				<span class="details">상품 카테고리</span>
                    			</div>
                    			<div class="form_section_content">
                    				<div class="cate_wrap">
                    					<span>대분류</span>
                    					<select class="cate1">
                    						<option selected value="none">선택</option>
                    					</select>
                    				</div>
                    				<div class="cate_wrap">
                    					<span>중분류</span>
                    					<select class="cate2" name="kind_id">
                    						<option selected value="none">선택</option>
                    					</select>
                    				</div>
                    				<span class="ck_warn cateCode_warn">카테고리를 선택해주세요.</span>                  				                    				
                    			</div>
                    		</div>
							<input type="hidden" name='product_id'
								value="${productsInfo.product_id}">
							<div class="button">
								<input type="button" value="취소" id="cancelBtn" /> <input
									type="button" value="수정" id="modifyBtn" /> <input
									type="button" value="삭제" id="deleteBtn" />
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
		<form id="moveForm" action="/admin/admin" method="get">
			<input type="hidden" name="pageNum" value="${cri.pageNum}"> <input
				type="hidden" name="amount" value="${cri.amount}"> <input
				type="hidden" name="keyword" value="${cri.keyword}"> <input
				type="hidden" name='product_id' value="${productsInfo.product_id}">
		</form>
	</section>

	<script>
		$(document).ready(function(){
			/* 기존 이미지 출력 */
			let product_id = '<c:out value="${productsInfo.product_id}"/>';
			let uploadResult = $("#uploadResult");
			
			$.getJSON("/getAttachList", {product_id : product_id}, function(arr){
				
				console.log(arr);
				
				if(arr.length === 0){
					
					
					let str = "";
					str += "<div id='result_card'>";
					str += "<img src='/resources/img/goodsNoImage.png'>";
					str += "</div>";
					
					uploadResult.html(str);				
					return;
				}
				
				let str = "";
				let obj = arr[0];
				
				let fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
				str += "<div id='result_card'";
				str += "data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "'";
				str += ">";
				str += "<img src='/display?fileName=" + fileCallPath +"'>";
				str += "<div class='imgDeleteBtn' data-file='" + fileCallPath + "'>x</div>";
				str += "<input type='hidden' name='imageList[0].fileName' value='"+ obj.fileName +"'>";
				str += "<input type='hidden' name='imageList[0].uuid' value='"+ obj.uuid +"'>";
				str += "<input type='hidden' name='imageList[0].uploadPath' value='"+ obj.uploadPath +"'>";				
				str += "</div>";
				
				uploadResult.html(str);			
				
			});// GetJSON	
			
			/* 카테고리 */
			let cateList = JSON.parse('${cateList}');
			let cate1Array = new Array();
			let cate2Array = new Array();
			
			let cate1Obj = new Object();
			let cate2Obj = new Object();
			
			let cateSelect1 = $(".cate1");		
			let cateSelect2 = $(".cate2");
			
			/* 카테고리 배열 초기화 메서드 */
			function makeCateArray(obj,array,cateList, tier){
				for(let i = 0; i < cateList.length; i++){
					if(cateList[i].tier === tier){
						obj = new Object();
						
						obj.kind_name = cateList[i].kind_name;
						obj.kind_id = cateList[i].kind_id;
						obj.cateparent = cateList[i].cateparent;
						
						array.push(obj);				
						
					}
				}
			}	
			
			/* 배열 초기화 */
			makeCateArray(cate1Obj,cate1Array,cateList,1);
			makeCateArray(cate2Obj,cate2Array,cateList,2);
			
			let targetCate1 = '';
			let targetCate2 = '${productsInfo.kind_id}';		
					
			for(let i = 0; i < cate2Array.length; i++){
				if(targetCate2 === cate2Array[i].kind_id){
					targetCate2 = cate2Array[i];
				}
			}// for
			
			for(let i = 0; i < cate2Array.length; i++){
				if(targetCate2.cateparent === cate2Array[i].cateparent){
					cateSelect2.append("<option value='"+cate2Array[i].kind_id+"'>" + cate2Array[i].kind_name + "</option>");
				}
			}		
			
			$(".cate2 option").each(function(i,obj){
				if(targetCate2.kind_id=== obj.value){
					$(obj).attr("selected", "selected");
				}
			});				
			
			for(let i = 0; i < cate1Array.length; i++){
				if(targetCate2.cateparent === cate1Array[i].kind_id){
					targetCate1 = cate1Array[i];	
				}
			}// for	
			
			
			for(let i = 0; i < cate1Array.length; i++){
				cateSelect1.append("<option value='"+cate1Array[i].kind_id+"'>" + cate1Array[i].kind_name + "</option>");
			}	
			
			$(".cate1 option").each(function(i,obj){
				if(targetCate1.cateparent === obj.value){
					$(obj).attr("selected", "selected");
				}
			});				
			
			
		}); // document ready
	
		let enrollForm = $("#enrollForm")

		/* 취소 버튼 */
		$("#cancelBtn").on("click", function(e) {
			e.preventDefault();
			$("#moveForm").submit();
		});

		/* 수정 버튼 */
		$("#modifyBtn").on("click", function(e) {
			e.preventDefault();
			$("#modifyForm").submit();
		});
		
		/* 삭제 버튼 */
		$("#deleteBtn").on("click", function(e){
			e.preventDefault();
			let moveForm = $("#moveForm");
			moveForm.find("input").remove();
			moveForm.append('<input type="hidden" name="product_id" value="${productsInfo.product_id}">');
			moveForm.attr("action", "/admin/productsDelete");
			moveForm.attr("method", "post");
			moveForm.submit();
		});

		/* 이미지 업로드 */
		$("input[type='file']").on("change", function(e) {
			
			/* 이미지 존재시 삭제 */
			if($("#result_card").length > 0){
				deleteFile();
			}
			// alert("동작");
			let formData = new FormData();
			let fileInput = $('input[name="uploadFile"]');
			let fileList = fileInput[0].files;
			let fileObj = fileList[0];

			if (!fileCheck(fileObj.name, fileObj.size)) {
				return false;
			}

			formData.append("uploadFile", fileObj);

			// 사용자가 여러 개의 파일을 선택할 수 있게 하는 코드
			/* for(let i = 0; i < fileList.length; i++){
				formData.append("uploadFile", fileList[i]);
			} */

			// alert("통과");
			console.log("fileList : " + fileList);
			console.log("fileObj : " + fileObj);

			// 첨부파일 서버 전송
			$.ajax({
				url : '/admin/uploadAjaxAction',
				processData : false,
				contentType : false,
				data : formData,
				type : 'POST',
				dataType : 'json',
				success : function(result){
		    		console.log(result);
		    		showUploadImage(result);
		    	},
		    	error : function(result){
		    		alert("이미지 파일이 아닙니다.");
		    	}
			});

		});

		/* 파일 체크(JavaScript) */
		let regex = new RegExp("(.*?)\.(jpg|png|PNG|JPG)$");
		let maxSize = 1048576; //1MB	

		function fileCheck(fileName, fileSize) {

			if (fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}

			if (!regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}

			return true;

		}
		
		/* 이미지 삭제 버튼 동작 */
		$("#uploadResult").on("click", ".imgDeleteBtn", function(e){
			
			deleteFile();
			
		});
		
		/* 파일 삭제 메서드 */
		function deleteFile(){
			
			$("#result_card").remove();
		}
		
		/* 이미지 출력 */
		function showUploadImage(uploadResultArr){
			
			/* 전달받은 데이터 검증 */
			if(!uploadResultArr || uploadResultArr.length == 0){return}
			
			let uploadResult = $("#uploadResult");
			
			let obj = uploadResultArr[0];
			
			let str = "";
			
			let fileCallPath = encodeURIComponent(obj.uploadPath.replace(/\\/g, '/') + "/s_" + obj.uuid + "_" + obj.fileName);
			//replace 적용 하지 않아도 가능
			//let fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
			
			str += "<div id='result_card'>";
			str += "<img src='/display?fileName=" + fileCallPath +"'>";
			str += "<div class='imgDeleteBtn' data-file='" + fileCallPath + "'>x</div>";
			str += "<input type='hidden' name='imageList[0].fileName' value='"+ obj.fileName +"'>";
			str += "<input type='hidden' name='imageList[0].uuid' value='"+ obj.uuid +"'>";
			str += "<input type='hidden' name='imageList[0].uploadPath' value='"+ obj.uploadPath +"'>";		
			str += "</div>";		
			
	   		uploadResult.append(str);     
	        
		}
		
		
	</script>

	<script>
		let sidebar = document.querySelector(".sidebar");
		let sidebarBtn = document.querySelector(".sidebarBtn");
		sidebarBtn.onclick = function() {
			sidebar.classList.toggle("active");
			if (sidebar.classList.contains("active")) {
				sidebarBtn.classList.replace("bx-menu", "bx-menu-alt-right");
			} else
				sidebarBtn.classList.replace("bx-menu-alt-right", "bx-menu");
		};

		$("#file").on('change', function() {
			var fileName = $("#file").val();
			$(".upload-name").val(fileName);
		});
	</script>
</body>
</html>