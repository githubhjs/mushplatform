<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>照片</title>
<head>

<body>

<h1>照片 
  <span style="font-size: 14px;">
    <a href="/first/index.php/photos/upload">上传</a>
    <a href="/first/index.php/photos/browse">浏览</a>
    <a href="/first/index.php/users/signoff">登出</a>
  </span>
</h1>

<div style="color:red"><?=$notice?></div>

<h3><?=$photo['title']?></h3>

<div>
  <a href="/first/images/upload/<?=$photo['1024']?>">
  <img src="/first/images/upload/<?=$photo['480']?>" style="border:solid 1px #ccc;">
  </a>
</div>

</body>
</html>
