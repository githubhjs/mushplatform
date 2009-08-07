<?php
require pathinfo(__FILE__, PATHINFO_DIRNAME).'/../base/model.php';

class Photo extends Model {
  public $table_name = 'photos';

  function __construct() {
    parent::__construct();
    foreach ($this->columns($this->table_name) as $c) {
      $this->atts[$c] = '';
    }
  }

  function find_by_user_id($user_id) {
    $conn = $this->connect();
    $sql = "select * from photos where user_id = '%d'";
    $query = sprintf($sql, mysql_real_escape_string($user_id,$conn));
    $photos = $this->query($query, array_keys($this->atts), $conn);
//    $this->close($conn);
    return $photos;
  }

  function find_by_id($id) {
    $photo = self::$cache->get('photo_'.$id);
    if ($photo != NULL) return $photo;
    echo 'not from cache';
    $conn = $this->connect();
    $sql = "select * from photos where id = %d";
    $query = sprintf($sql, mysql_real_escape_string($id,$conn));
    $data = $this->query($query, array_keys($this->atts), $conn);
    if (count($data)>0) {
      $photo = $data[0];
      self::$cache->set('photo_'.$photo['id'], $photo, false, 600);
    } else {
      $photo = null;
    }
//    $this->close($conn);
    return $photo;
  }

  function create($data) {
    $conn = $this->connect();
    foreach ($data as $key=>$value) {
      $data[$key] = mysql_real_escape_string($value,$conn);
    }
    
    $created_at = date('Y-m-d H:i:s');
    $sql = "insert into photos(filename, title, user_id, created_at) values ('%s', '%s', '%d', '%s')";
    $create = sprintf($sql, $data['filename'], $data['title'], $data['user_id'], $created_at);
    $result =  $this->insert($create);
//    $this->close($conn);
    return $result;
  }

  function thumbnail($filename, $width, $height) {
    $file = UPLOAD_PATH.'/'.$filename;
    $ext = substr($file, strlen($file)-4);
    $file_without_ext = substr($file, 0, strripos($file, '.'));
    $thumbnail_file = $file_without_ext.'-'.$width.'x'.$height.$ext;
    copy($file, $thumbnail_file);

    $image = new Imagick($thumbnail_file);
    if ($width == $height) {
      $image->cropThumbnailImage($width, $height);
    } else {
      $image->scaleImage($width, $height, true);
    }
    $image->writeImage();
    $image->destroy();
  }

}

?>
