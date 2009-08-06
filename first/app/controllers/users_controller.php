<?php

class UsersController extends Controller {
  function signup() {
    $salt = uniqid(mt_rand());
    $password = '123456';
    echo sha1(md5($password).$salt);
    return $this->params;
  }

  function signon() {
    return $this->params;
  }
}

?>
