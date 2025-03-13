<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style type="text/css">
 
@font-face {
    font-family: 'NEXON Lv1 Gothic OTF';
    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-04@2.1/NEXON Lv1 Gothic OTF.woff') format('woff');
    font-weight: normal;
    font-style: normal;
}

.recent-products, .recent-products-long {
    font-family: 'NEXON Lv1 Gothic OTF', sans-serif;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
}

.recent-products {
    background-color: #FBFBFB;
    border: 1px solid #D9D9D9;
   	height: 30px;
   	padding-top: 10px; 
   
    
}
    .recent-products h3 {
    color: #222; 
    font-size: 14px;
}

  .recent-products-long {
    background-color: #FBFBFB;
    border: 1px solid #D9D9D9;
    margin-bottom: 20px;
    height: 450px; 
    padding-top: 10px; 
}
  
  .recent-products-long h3 {
    color: #7F7F7F; 
    font-size: 12px;
}

.container-r {
    float: right;
    top: 50%;
    width: 150px;
}
  
</style>
</head>
<body>
	<div class="container-r">
	<div class="recent-products">
    <h3>즐겨찾기</h3>
 	</div>
  
   <div class="recent-products">
        <h3>최근 본 상품</h3>
    </div>
  
  <div class="recent-products-long">
        <h3>최근 본 상품이 없습니다.</h3>
    </div>
   </div>
    
</body>
</html>