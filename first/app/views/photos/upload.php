<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>照片上传</title>
<head>

<body>

<h1>照片上传 
  <span style="font-size: 14px;">
    <a href="/first/index.php/photos/upload">上传</a>
    <a href="/first/index.php/photos/browse">浏览</a>
    <a href="/first/index.php/users/signoff">登出</a>
  </span>
</h1>

<div style="color:red"><?=$notice?></div>

<form method="post" action="/first/index.php/photos/upload" enctype="multipart/form-data">
<div>图片：<input type="file" name="photo[]" /></div>
<div>图片：<input type="file" name="photo[]" /></div>
<div>图片：<input type="file" name="photo[]" /></div>
<div>　　　<input type="submit" name="submit" value="上传" /> <a href="/first/index.php/photos/browse">浏览</a></div>
</form>

</body>
</html>
