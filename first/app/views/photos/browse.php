<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>照片列表</title>
<head>

<body>

<h1>照片列表
  <span style="font-size: 14px;">
    <a href="/first/index.php/photos/upload">上传</a>
    <a href="/first/index.php/photos/browse">浏览</a>
    <a href="/first/index.php/users/signoff">登出</a>
  </span>
</h1>

<div style="color:red"><?=$notice?></div>

<?php foreach ($photos as $photo) { ?>

<div style="float:left;margin:10px;text-align:center;">
  <div style="width:220px;height:210px;"><a href="/first/index.php/photos/single?id=<?=$photo['id']?>"><img src="/first/images/upload/<?=$photo['200']?>" style="border:solid 1px #ccc;"></a></div>
  <div><a href="/first/index.php/photos/single?id=<?=$photo['id']?>"><?=$photo['title']?></a></div>
</div>

<?php } ?>

</body>
</html>
