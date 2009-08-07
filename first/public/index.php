<?php

define('BASE_PATH', pathinfo(__FILE__, PATHINFO_DIRNAME).'/..');
define('APP_PATH', BASE_PATH.'/app');
define('UPLOAD_PATH', BASE_PATH.'/public/images/upload');

require APP_PATH.'/dispatch.php';
?>
