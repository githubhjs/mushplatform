<?php
require pathinfo(__FILE__, PATHINFO_DIRNAME).'/../base/model.php';

class User extends Model {
  public $atts;

  function __construct() {
    $this->atts = $this->columns('users');
  }
}

$m = new User();
//foreach ($m->query('select * from users', $m->atts) as $d) {
//  print $d['email']; 
//}

$m->add("insert into users values (6,'pawa',12312,13123,'pxawadmaba@gmauil.com',null,null)");
?>
