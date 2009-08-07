<?php
require pathinfo(__FILE__, PATHINFO_DIRNAME).'/../models/user.php';

class UsersController extends Controller {
  function signup() {
    if ($this->is_get()) {
      $data = $this->params;
      $this->render('users/signup', $data);
    } elseif ($this->is_post()) { 
      $data = $this->params;
      $user = new User();
      $scode = strtolower($this->params['scode']);
      if(($this->session['scode'] == $scode) && (!empty($this->session['scode']))) {
        if ($user->create($data)) {
          $this->redirect('users/signon?new=true');
        } else {
          $data['notice'] = '注册失败，请重试！';
          $this->render('users/signup', $data);
        }
      } else {
        $data['notice'] = '验证码不正确，请重试！';
        $this->render('users/signup', $data);
      } 
    }
  }

  function signon() {
    if ($this->is_get()) {
      $data = $this->params;
      if($data['new']){
        $data['notice'] = '恭喜您，注册成功，请登录！';
      }
      $this->render('users/signon', $data);
    } elseif ($this->is_post()) { 
      $data = $this->params;
      $user = new User();
      $scode = strtolower($this->params['scode']);
      if(($this->session['scode'] == $scode) && (!empty($this->session['scode']))) {
        unset($this->session['scode']);
        if ($user = $user->authenticate($data['email'], $data['password'])) {
          $_SESSION['user'] = $user;
          $this->redirect('photos/browse');
        } else {
          $data['notice'] = '用户名密码不正确，请重试！';
          $this->render('users/signon', $data);
        }
      } else {
        $data['notice'] = '验证码不正确，请重试！';
        $this->render('users/signon', $data);
      } 
    }
  }

  function signoff() {
    $_SESSION['user'] = null;
    $this->redirect('users/signon');
  }

}

?>
