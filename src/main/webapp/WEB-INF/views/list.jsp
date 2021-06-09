<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>게시판목록</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
<style>
.redRow{color:red;}
.blueRow{color:#364967;}
table {width: 70%; margin-top:10px;text-align:center; margin-bottom:10px; border-top: 1px solid #364967; border-collapse: collapse;}
tr, td {border-bottom: 1px solid #444444; text-align:center; padding: 10px;}
.title {border-bottom: 1px solid #444444; text-align:center; padding: 10px; background:#364967; color:white;}
.btnStyle, button, input[type="button"],input[type="submit"],input[type="reset"]{width: 100px;
              padding: .5em .5em;
              border: 1px solid #364967;
              background: #364967;
              color: white;    
              font-weight:bold;
   	}
a .active {font-weight:bold; color:#364967;}
#pagination{text-align:center;}
a{text-decoration:none; color:#364967;font-size:20px;}
a:hover{font-weight:bold; }
span{color:#364967;font-size:20px;}
.keyword, input[type="text"]{width: 200px;
  padding: .5em .5em;
  font-weight: 800;
  border: 1px solid #364967;
  background: white;
  color:black;        
}
 textarea{width: 400px;
  padding: .5em .5em;
  font-weight: 800;
  border: 1px solid #364967;
  background: white;
  color:black;  }
#divHeader{margin-bottom:10px;}
select { width: 130px;
            padding: .5em .5em;
            border: 1px solid #364967;
            font-family: inherit;
            background: no-repeat 95% 50%;
            border-radius: 0px;
            }               
select::-ms-expand {display: none;}
#container{width:800; overflow:hidden;}
.box{width:220px; height: 200px; float:left;box-shadow:5px 5px 5px gray;margin:10px;}
img{text-align:center;}
</style>
</head>
<body>
   <h1>[상품목록]</h1>
   <div>
   		<button onClick="location.href='insert'">상품등록</button>
   		<span>상품갯수:</span>
      	<span id="totalCount"></span>
   </div>   
   <div id="container">
      <c:forEach items="${list}" var="vo">
         <div class="box" pcode="${vo.pcode}">
	         <c:if test="${vo.image==null}">
	         <div><img src="http://placehold.it/200x130"/></div>
	         </c:if>
	         <c:if test="${vo.image!=null}">
	            <div><img src="/displayFile?fullName=${vo.image}" width=200 height=130/></div>
	         </c:if>
	          <div class="pcode">${vo.pcode}</div>
	          <div class="pname">${vo.pname}</div>
	          <div class="price"><fmt:formatNumber value="${vo.price}" pattern="#,###원"/></div>
         </div>
      </c:forEach>
   </div>
  <div id="pagination">
	   <c:if test="${pm.prev}">
	      <span page="${pm.startPage-1}">◀</span>
	   </c:if>
	   <c:forEach begin="${pm.startPage}" end="${pm.endPage}" var="i">
	      <c:if test="${i==page}">	      	
	       	<span page="${i}" class="active">${i} </span>	       
	      </c:if>
	      <c:if test="${i!=page}">	      	
	       	<span page="${i}">${i} </span>	
	      </c:if>
	   </c:forEach>
	   <c:if test="${pm.next}">
	      <span page="${pm.endPage+1}">▶</span>
	   </c:if>
   </div>
</body>
<script>
   var totalCount=${pm.totalCount};
   $("#totalCount").html(totalCount);   
   $("#container").on("click",".box",function(){
	  var pcode=$(this).attr("pcode");
	  location.href="read?pcode="+pcode; 
   });
   $("#pagination").on("click","span",function(){
      var page=$(this).attr("page");
      location.href="list?page="+page;
   });
</script>
</html>