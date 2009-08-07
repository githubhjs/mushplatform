<?php
default('UPLOAD_PATH', BASE_PATH.'/public/images/upload')
require pathinfo(__FILE__, PATHINFO_DIRNAME).'/../models/photo.php';

class PhotosController extends Controller {
  function upload() {
    $this->is_signon();
    if ($this->is_get()) {
      $data = $this->params;
      $this->render('photos/upload', $data);
    } elseif ($this->is_post()) { 
    }
  }

  function describe() {
    $this->is_signon();
    $data = $this->params;
    $this->render('photos/describe', $data);
  }

  function browse() {
    $this->is_signon();
    $data = $this->params;
    $this->render('photos/browse', $data);
  }
}

?>
