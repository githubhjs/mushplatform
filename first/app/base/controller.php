<?php

class Controller {

  public $params;
  public $session;
  
  function render($template, $data) {
    // render content
    extract($data, EXTR_SKIP);
    ob_start();
//    @include APP_PATH.'/views/'.$class_name.'/'.$function_name.'.php';
    @include APP_PATH.'/views/'.$template.'.php';
    ob_flush();
  }

  function redirect($url) {
    extract(array($url), EXTR_SKIP);
    @include APP_PATH.'/base/redirect.php';
  }

  function is_signon() {
    if ($this->session['user'] == NULL) {
      $this->redirect('users/signon');
    }
  }

  function is_get() {
    if ($_SERVER['REQUEST_METHOD'] == 'GET') {
      return true;
    } else {
      return false;
    }
  }

  function is_post() {
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
      return true;
    } else {
      return false;
    }
  }
}

?>
