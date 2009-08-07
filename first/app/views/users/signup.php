<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>用户注册</title>
<style>
input {width:150px;}
</style>
<head>

<body>

<h1>用户注册</h1>

<div style="color:red"><?=$notice?></div>

<form method="post" action="/first/index.php/users/signup">
<div>邮件：<input type="text" name="email" /></div>
<div>昵称：<input type="text" name="name" /></div>
<div>密码：<input type="password" name="password" /></div>
<div>验证：<input type="text" name="scode" /></div>
<div>　　　<img id="captcha" src="/first/captcha.php" onclick="document.getElementById('captcha').src='/first/captcha.php?'+Math.random();" style="cursor:pointer" ></div>
<div>　　　点击图片刷新验证码</div>
<div>　　　<input type="submit" name="submit" value="注册" /> <a href="/first/index.php/users/signon">登录</a></div>
</form>

</body>
</html>
