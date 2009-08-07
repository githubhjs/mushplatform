<?php
require pathinfo(__FILE__, PATHINFO_DIRNAME).'/../base/model.php';

class User extends Model {
  public $table_name = 'users';
  public $atts;

  function __construct() {
    foreach ($this->columns('users') as $c) {
      $this->atts[$c] = '';
    }
  }

  function create($data) {
    foreach ($data as $key=>$value) {
      $data[$key] = mysql_real_escape_string($value, $this->connect());
    }

    $name = $data['name'];
    $salt = uniqid(mt_rand());
    $salted_password = sha1(md5($data['password']).$salt);
    $email = $data['email'];
    $created_at = date('Y-m-d H:i:s');
    $sql = "insert into users(name, salt, salted_password, email, created_at) values ('%s', '%s', '%s', '%s', '%s')";
    $create = sprintf($sql,$name, $salt, $salted_password, $email, $created_at);
    $this->insert($create);
  }

  function authenticate($email, $password) {
    $sql = "select * from users where email = '%s'";
    $query = sprintf($sql, $email);
    $data = $this->query($query, array_keys($this->atts));
    if(count($data) > 0) {
      $data = $data[0];
      $input_salted_password = sha1(md5($password).$data['salt']);
      if ($input_salted_password == $data['salted_password']) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

}

$m = new User();
$values = array('name' => 'xixi', 'password' => 'xixixixi', 'email' => 'didid@sixi');
#echo $values['name'];
echo $m->authenticate('didid@sixi', 'xixixixi');
//foreach (array_keys($m->atts) as $a) {
//  print $a;
//}
//foreach ($m->find('select * from users', array_keys($m->atts)) as $d) {
  #print_r($d['email']); 
//}

#echo date('Y-m-d H:i:s');
#$m->create("insert into users values (6,'pawa',12312,13123,'pxawadmaba@gmauil.com',null,null)");
?>
