<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="se"
	uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<!-- bootstrap css-->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" />
<!-- bootstrap js cdn-->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- boxicons js cdn -->
<script src="https://unpkg.com/boxicons@2.1.4/dist/boxicons.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.7.0/css/all.css"
	integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ"
	crossorigin="anonymous">
<link
	href="${pageContext.request.contextPath }/resources/css/global.css"
	rel="stylesheet" type="text/css">
<title>커뮤니티게시판</title>
<style>
* {
	box-sizing: border-box;
	padding: 0px;
	margin: 0px;
}

box-icon {
	vertical-align: -5px;
}
</style>
</head>
<body>
	<div class="listContainer container">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<se:authentication property="name" var="LoginUser" />
		<input id="login_id" type="hidden" value="${LoginUser}">
		<div class="main py-5">
			<!-- 검색버튼 시작 -->
			<div class="container">
				<div class="form-group">
					<div class="row">
						<!-- 총 게시물 출력 시작 -->
						<div id="totalcount" class="totalPostContainer my-3">총
							${requestScope.total}건의 게시물</div>
						<!-- 총 게시물 출력 끝 -->
						<div id="ps" class="col-sm-12 col-md-6 my-2">
							<div class="form-group d-flex align-items-center">
								<div class="col-sm-1" style="padding-left: 0">
									<form name="list">
										<select name="ps" class="form-control form-select-sm"
											onchange="submit()">
											<c:forEach var="i" begin="5" end="20" step="5">
												<c:choose>
													<c:when test="${ps == i }">
														<option value="${i}" selected>${i}</option>
													</c:when>
													<c:otherwise>
														<option value="${i}">${i}</option>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</select>
									</form>
								</div>
								<div class=""></div>
								<label for="" style="margin-bottom: 0">개씩 보기</label>
							</div>
						</div>
						<div class="col-sm-12 col-md-6">
							<div class="d-flex justify-content-end">
								<div class="col-sm-4">
									<select id="selectBox" class="form-control col-md-2 pt-1 pb-1">
										<option value="comm_title" selected>제목</option>
										<option value="comm_content">내용</option>
										<option value="user_id">글쓴이</option>
										<option value="comm_category">카테고리</option>
ㄴ									</select>
								</div>
								<div class="searchText">
									<input type="text" id="search" placeholder="검색어를 입력하세요" />
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 검색 끝 -->



			<!-- 테이블 시작 -->
			<table class="table">
				<thead class="table-light">
					<tr>
						<td>순번</td>
						<td>카테고리</td>
						<td>제목</td>
						<td>글쓴이</td>
						<td>작성날짜</td>
						<td>조회수</td>
					</tr>
				</thead>
				<tbody id="communityBody">
					<!-- 상세보기 이동 -->
					<c:set var="list" value="${requestScope.list}" />
					<c:forEach var="list2" items="${list}">
						<tr>
							<td>${list2.comm_seq}</td>
							<td>${list2.comm_category}</td>
							<c:choose>
								<c:when test="${fn:contains(list2.comm_content, '<img')}">
									<td></box-icon><a href="detail.do?comm_seq=${list2.comm_seq}">${list2.comm_title}</a>
										<box-icon name='photo-album'></box-icon></td>
								</c:when>
								<c:otherwise>
									<td><a href="detail.do?comm_seq=${list2.comm_seq}">${list2.comm_title}</a></td>
								</c:otherwise>
							</c:choose>
							<td>${list2.user_id}</td>
							<td>${list2.comm_writen_date}</td>
							<td>${list2.comm_view_count}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<!-- 테이블 끝 -->
			<!-- 글쓰기 버튼 시작 -->
	 	<div>${cpage}</div>
			<div class="writeContainer">
				<button type="button" class="btn btn-secondary left"
					onclick="location.href='write.do?cp=${cp}&ps=${ps}'">글 작성</button>
			</div>

			<!-- 글쓰기 버튼 끝 -->
			<!-- 페이징 시작 -->
			<div id="communityPaging" class="d-flex justify-content-center mt-4">
				<nav>
					<ul class="pagination">
						<li class="page-item ${cp == 1 ? 'disabled' : ''}"><a
							class="page-link" href="list.do?cp=${cp-1}&ps=${ps}"
							tabindex="-1" aria-disabled="true">이전</a></li>
						<c:forEach var="i" begin="1" end="${pagecount}" step="1">
							<li class="page-item ${cp == i ? 'active' : ''}"><a
								class="page-link" href="list.do?cp=${i}&ps=${ps}">${i}</a>
							</li>
						</c:forEach>
						<li class="page-item ${cp == pagecount ? 'disabled' : ''}">
							<a class="page-link" href="list.do?cp=${cp+1}&ps=${ps}">다음</a>
						</li>
					</ul>
				</nav>
			</div>
			<!-- 페이징 끝 -->
		</div>
	</div>
	<!-- footer 영역 -->
	<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
</body>
<script>
        $(document).ready(function () {
            console.log("여기옴?");
            getList();
     
            function getList() {
                let keyword = $("#selectBox option:selected").val();
                $("#selectBox").change(function () {
                    keyword = $("#selectBox option:selected").val();
                });
                
                $("#search").keyup(function () {
                    const CommunitySearchData = {
                        "field": keyword,
                        "query": $(this).val(),
                        "cp": ${cp},
                        "ps"  : ${ps} 
                    };
                    if($(this).val().length < 1){
                    	window.location.href="/sspl_finance/community/list.do";
                    	return;
                    }
                    $.ajax({
                        url: "/sspl_finance/restcommunity/listSearch",
                        type: "POST",
                        dataType: "json",
                        data: JSON.stringify(CommunitySearchData),
                        contentType: "application/json",
                        success: function (result) {
                            $("#communityBody").empty();
                            $("#ps").css('visibility','hidden');  
                            $("#totalcount").css('visibility','hidden');
                            $("#communityPaging").css('visibility','hidden');
                            console.log(result);
                            let ajaxTable = "";

                            $.each(result, function (key, value) {
                                ajaxTable += "<tr>";
                                ajaxTable += "<td>" + value.comm_seq + "</td>";
                                ajaxTable += 
                                    "<td>" + value.comm_category + "</td>";
                                    "<td>" + value.comm_title + "</td>";
                                ajaxTable += "<td>" + value.user_id + "</td>";
                                ajaxTable +=
                                    "<td>"+ value.comm_writen_date + "</td>";
                                    
                                ajaxTable +=
                                    "<td>" + value.comm_view_count + "</td>";
                                ajaxTable += "</tr>";
                            });

                            $("#communityBody").append(ajaxTable);                     
                        },
                        error: function (xhr) {
                            console.log("안불러와짐");
                            console.log(xhr.status);
                        },
                    }); //ajax
                }); //keyup
            }
        });
    </script>
</html>
