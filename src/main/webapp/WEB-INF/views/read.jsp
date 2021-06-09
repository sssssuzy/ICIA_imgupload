<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<title>상품정보</title>
<style>
.redRow{color:red;}
.blueRow{color:#364967;}
table {width: 70%; margin-top:10px; margin-bottom:10px; border-top: 1px solid #364967; border-collapse: collapse;}
tr, td {border-bottom: 1px solid #444444; padding: 10px;}
.title {border-bottom: 1px solid #444444; text-align:center; padding: 10px; background:#364967; color:white;}
.btnStyle, button, input[type="button"],input[type="submit"],input[type="reset"]{width: 100px;
              padding: .5em .5em;
              border: 1px solid #364967;
              background: #364967;
              color: white;    
              font-weight:bold;
   	}
.active { font-weight:bold; color:#364967;}
#pagination{text-align:center;}
a{text-decoration:none; color:#364967;font-size:20px;}
a:hover{font-weight:bold;}
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
#listFile img{width:150px; margin:10px}
</style>
</head>
<body>
	<h1>상품정보</h1>
	<form name="frm" enctype="multipart/form-data">
		<table>
			<tr>
				<td class="title">상품코드</td>
				<td><input type="text" name="pcode" value="${vo.pcode}"/></td>
			</tr>
			<tr>
				<td class="title">상품이름</td>
				<td><input type="text" name="pname" value="${vo.pname}"/></td>
			</tr>
			<tr>
				<td class="title">상품가격</td>
				<td><input type="text" name="price" value="${vo.price}"/></td>
			</tr>
			<tr>
				<td class="title">상품이미지</td>
				<td>
					<c:if test="${vo.image==null}">
					<img src="http://placehold.it/150x120" id="image" width=150/>
					</c:if>	
					<c:if test="${vo.image!=null}">
					<img src="/displayFile?fullName=${vo.image}" id="image" width=150/>
					</c:if>				
					<input type="file" name="file"/>
				</td>
			</tr>
			<tr>
				<td class="title"><input type="button" id="btnImage" value="첨부이미지"/></td>	
				<td style="height:150px;padding:10px;">
              		<input type="file" name="files" accept="image/*" multiple style="display:none"/>
              		<div id="uploaded">
                 		<ul id="uploadFiles"></ul>
                		<script id="temp" type="text/x-handlebars-template">
                  			<li>
                    			<img src="/displayFile?fullName=${vo.pcode}/{{fullName}}" width=150/>
                    			<input type="text" name="images" value="{{fullName}}"/>
                    			<input class="del" type="button" value="삭제" fullName={{fullName}}/>
                			</li>
                  		</script>
              		</div>
          	 	</td>
			</tr>
		</table>
		<input type="submit" value="수정">
		<input type="reset" value="취소">
		<input type="button" value="삭제" id="btnDel">
		<input type="button" value="목록" onClick="location.href='list'">
	</form>
</body>
<script>
	var pcode="${vo.pcode}";
	//상품삭제하기
	$("#btnDel").on("click",function(){		
		if(!confirm("삭제하실래요?")) return;
		frm.action="delete";
	    frm.method="get";
	    frm.submit();	    
	});
	getAttach();
	//첨부파일들 불러오기
	function getAttach(){
		$.ajax({
			type:"get",
			url:"getAttach",
			dataType:"json",
			data:{"pcode":pcode},
			success:function(data){
				$(data).each(function(){
					 var temp=Handlebars.compile($("#temp").html());
			         var tempData={"fullName":this};
			         $("#uploadFiles").append(temp(tempData));
				});
			}
		});
	}
	//첨부이미지 버튼 눌렀을때
	$("#btnImage").on("click",function(){
		$(frm.files).click();
	});
	//사진 여러장 선택한경우
   $(frm.files).on("change", function(){
      var files=$(frm.files)[0].files;
      $.each(files, function(index, file){
         uploadFile(file);
      });
   });
	//첨부파일 업로드
	function uploadFile(file){
      if(file == null) return;
      var formData=new FormData();
      formData.append("file", file);
      formData.append("pcode", pcode);
      $.ajax({
         type:"post",
         url:"/uploadFile",
         processData:false,
         contentType:false,
         data:formData,
         success:function(data){
            var temp=Handlebars.compile($("#temp").html());
            var tempData={"fullName":data};
            $("#uploadFiles").append(temp(tempData));
         }
      });
   }
	$("#uploadFiles").on("click","li .del",function(){
		var li = $(this).parent();
		var fullName = $(this).attr("fullName");
		if(!confirm(fullName + "파일을 삭제하실래요?")) return;
		$.ajax({
			type:"get",
			url:"/deleteFile",
			data:{"fullName":pcode+"/"+fullName},
			success:function(){
				alert("삭제완료");
				li.remove();
			}
		});		
	});
	//상품등록하기
	$(frm).on("submit",function(e){
	    e.preventDefault();
	    var pname=$(frm.pname).val();
	    if(pname==""){
	       alert("상품명을 입력하세요!");
	       return;
	    }
	    if(!confirm("상품을 수정하실래요?"))return;
	    frm.action="update";
	    frm.method="post";
	    frm.submit();
	 });
	 //이미지클릭하면 파일불러오기
	 $("#image").on("click", function(){
	    $(frm.file).click();	    
	 });
	 //이미지 미리보기
	 $(frm.file).on("change",function(){
	    var file=$(frm.file)[0].files[0];
	    $("#image").attr("src", URL.createObjectURL(file));
	 });
</script>
</html>