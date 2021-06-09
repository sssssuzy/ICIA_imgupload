<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<title>상품등록</title>
<style>
.redRow{color:red;}
.blueRow{color:#364967;}
table {width: 70%; margin-top:10px; margin-bottom:10px; border-top: 1px solid #364967; border-collapse: collapse;}
tr, td {border-bottom: 1px solid #444444;   padding: 10px;}
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
</style>
</head>
<body>
	<h1>상품등록</h1>
	<form name="frm" enctype="multipart/form-data">
		<table>
			<tr>
				<td>상품코드</td>
				<td><input type="text" name="pcode" value="${code}"/></td>
			</tr>
			<tr>
				<td>상품이름</td>
				<td><input type="text" name="pname"/></td>
			</tr>
			<tr>
				<td>상품가격</td>
				<td><input type="text" name="price"/></td>
			</tr>
			<tr>
				<td>상품이미지</td>
				<td>
					<div id="upload">
						<input type="file" id="file">
					</div>
					<div id="uploaded">
						<ul id="uploadFiles"></ul>
					</div>
				</td>
			</tr>
		</table>
		<input type="submit" value="저장">
		<input type="reset" value="취소">
		<input type="button" value="목록" onClick="location.href='list'">
	</form>
</body>
<script>
	//상품등록하기
	$(frm).on("submit",function(e){
	    e.preventDefault();
	    var pname=$(frm.pname).val();
	    if(pname==""){
	       alert("상품명을 입력하세요!");
	       return;
	    }
	    if(!confirm("상품을 등록하실래요?"))return;
	    frm.action="insert";
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
	//파일추가 + 파일출력
		$("#file").on("change", function() {
			var file = $("#file")[0].files[0];
			if (file == null)
				return;
			var formData = new FormData();
			formData.append("file", file);

			$.ajax({
				type : "post",
				url : "uploadFile",
				processData : false,
				contentType : false,
				data : formData,
				success : function(data) {
					var str = "<li fullName="+data+">";
					str += "<img src='displayFile?fullName=" + data + "' width=200>";
					str += "<br/><a href='/downloadFile?fullName=" + data +"'>" + data + "</a>"
					str += "<button>삭제</button>";
					str += "</li>";
					$("#uploadFiles").append(str);
				}
			});
		});
		$("#uploadFiles").on("click","li button",function(){
			var li = $(this).parent();
			var fullName = li.attr("fullName");
			if(!confirm(fullName + "파일을 삭제하실래요?")) return;
			$.ajax({
				type:"get",
				url:"deleteFile",
				data:{"fullName":fullName},
				success:function(){
					alert("삭제완료");
					li.remove();
				}
			});		
		});
</script>
</html>