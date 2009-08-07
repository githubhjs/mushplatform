<?php
require pathinfo(__FILE__, PATHINFO_DIRNAME).'/../base/model.php';

class User extends Model {
  public $table_name = 'users';

  function __construct() {
    parent::__construct();
    foreach ($this->columns($this->table_name) as $c) {
      $this->atts[$c] = '';
    }
  }

  function find_by_email($email) {
    $conn = $this->connect();
    $sql = "select * from users where email = '%s'";
    $query = sprintf($sql, mysql_real_escape_string($email,$conn));
    $data = $this->query($query, array_keys($this->atts), $conn);
    if (count($data)>0) {
      $user = $data[0];
    } else {
      $user = null;
    }
//    $this->close($conn);
    return $user;
  }

  function create($data) {
    $conn = $this->connect();
    foreach ($data as $key=>$value) {
      $data[$key] = mysql_real_escape_string($value,$conn);
    }

    $name = $data['name'];
    $salt = uniqid(mt_rand());
    $salted_password = sha1(md5($data['password']).$salt);
    $email = $data['email'];
    $created_at = date('Y-m-d H:i:s');
    $sql = "insert into users(name, salt, salted_password, email, created_at) values ('%s', '%s', '%s', '%s', '%s')";
    $create = sprintf($sql,$name, $salt, $salted_password, $email, $created_at);
    $result =  $this->insert($create);
//    $this->close($conn);
    return $result;
  }

  function authenticate($email, $password) {
    $user = $this->find_by_email($email);
    if($user != NULL) {
      $input_salted_password = sha1(md5($password).$user['salt']);
      if ($input_salted_password == $user['salted_password']) {
        return $user;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

}

?>
