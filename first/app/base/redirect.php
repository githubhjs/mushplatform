<?php

ob_start();
header("Location: /first/index.php/" . $url);
ob_flush();

?> 
