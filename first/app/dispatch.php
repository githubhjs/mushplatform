<?php

// parse uri to mapping controller class ans method
$uri = $_SERVER['REQUEST_URI'];
$relative_path = substr($uri, strripos($uri,'index.php') + 10);
if (($end = strripos($relative_path, '?')) > 0) {
  $relative_path = substr($relative_path, 0, $end);
}
$parsed_uri = explode('/', $relative_path);

$class_name = $parsed_uri[0];
$function_name = $parsed_uri[1];

// import controller class file
require APP_PATH.'/base/controller.php';
require APP_PATH.'/controllers/'.$class_name.'_controller.php';

try{
  // initialize controller instance
  $controller = new ReflectionClass(ucwords($class_name).'Controller');
  $instance = $controller->newInstance();
  if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $instance->params = $_GET;
  } elseif ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $instance->params = $_POST;
  }
  #if($_SESSION == NULL) 
  session_start();
  $instance->session = $_SESSION;

  // invoke specified fucntion
  $function = $controller->getMethod($function_name);
  $function->invoke($instance);

  //$out = ob_end_clean();
  //echo $out;
} catch (Exception $e) {
  echo "Nothing happended ...";
}

?>
