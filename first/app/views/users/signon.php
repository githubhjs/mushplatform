<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>用户登录</title>
<head>

<body>

<h1>用户登录</h1>

<div style="color:red"><?=$notice?></div>

<form method="post" action="/first/index.php/users/signon">
<div>邮件：<input type="text" name="email" /></div>
<div>密码：<input type="password" name="password" /></div>
<div>验证：<input type="text" name="scode" /></div>
<div>　　　<img id="captcha" src="/first/captcha.php" onclick="document.getElementById('captcha').src='/first/captcha.php?'+Math.random();" style="cursor:pointer" ></div>
<div>　　　点击图片刷新验证码</div>
<div>　　　<input type="submit" name="submit" value="登录" /> <a href="/first/index.php/users/signup">注册</a></div>
</form>

</body>
</html>