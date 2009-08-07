<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>照片描述</title>
<head>

<body>

<h1>照片描述 
  <span style="font-size: 14px;">
    <a href="/first/index.php/photos/upload">上传</a>
    <a href="/first/index.php/photos/browse">浏览</a>
    <a href="/first/index.php/users/signoff">登出</a>
  </span>
</h1>

<div style="color:red"><?=$notice?></div>

<form method="post" action="/first/index.php/photos/process" enctype="multipart/form-data">
<div>图片：<input type="file" name="photo_1" /></div>
<div>图片：<input type="file" name="photo_2" /></div>
<div>图片：<input type="file" name="photo_3" /></div>
<div>　　　<input type="submit" name="submit" value="上传" /> <a href="/first/index.php/photos/browse">浏览</a></div>
</form>

</body>
</html>
