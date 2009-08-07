<?php
require APP_PATH.'/models/photo.php';

class PhotosController extends Controller {
  function upload() {
    $this->is_signon();
    if ($this->is_get()) {
      $data = $this->params;
      $this->render('photos/upload', $data);
    } elseif ($this->is_post()) { 
      $data = $this->params;

      $exts = array('.gif','.jpg','.png', '.bmp', '.GIF', '.JPG', '.PNG', 'BMP');
      $max_size = 20000000;
      
      if(in_array("0", $this->files['photo']['error'])){
        $count = count($this->files['photo']['name']);
        for ($i = 0; $i < $count; $i++){
          $file_name = $this->files['photo']['name'][$i];
          if ($file_name != NULL) {
            $file_ext = substr($file_name,strrpos($file_name,"."));
            if(!in_array($file_ext, $exts)){
              die('文件格式不允许！'.$file_ext);
            }
            if($this->files['photo']['size'][$i] > $max_size){
              die('文件大小超出允许范围！');
            }
            $filename = date("YmdHis").rand(10000,1000000).$file_ext;
            $upload_file = UPLOAD_PATH.'/'.$filename;
            if (move_uploaded_file($this->files['photo']['tmp_name'][$i], $upload_file)) {
              $photo = new Photo();
              $photo->create(array('filename' => $filename, 'title' => $filename, 'user_id' => $this->session['user']['id']));
              $photo->thumbnail($filename, 200, 200);
              $photo->thumbnail($filename, 480, 360);
              $photo->thumbnail($filename, 1024, 768);
            } else {
              die('上传失败！');
            }
          }
        }
      }
      $this->redirect('photos/browse');
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
    
    $photo = new Photo();
    $data['photos'] = $photo->find_by_user_id($this->session['user']['id']);
    foreach ($data['photos'] as &$photo) {
      $this->_set_thumbnail(&$photo);
    }

    $this->render('photos/browse', $data);
  }

  function single() {
    $this->is_signon();
    $data = $this->params;
    $photo = new Photo();
    $data['photo'] = $photo->find_by_id($this->params['id']);
    $this->_set_thumbnail(&$data['photo']);
    $this->render('photos/single', $data);
  }

  function _set_thumbnail(&$photo) {
    $photo['200'] = $this->_thumbnail($photo['filename'], 200, 200);
    $photo['480'] = $this->_thumbnail($photo['filename'], 480, 360);
    $photo['1024'] = $this->_thumbnail($photo['filename'], 1024, 768);
  }

  function _thumbnail($filename, $width, $height) {
    $ext = substr($filename, strlen($file)-4);
    $filename_without_ext = substr($filename, 0, strripos($filename, '.'));
    $thumbnail_file_name = $filename_without_ext.'-'.$width.'x'.$height.$ext;
    return $thumbnail_file_name;
  }
}

?>
