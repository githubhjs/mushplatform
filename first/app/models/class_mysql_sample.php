<?php

    include("class_mysql.php");

    //===== set up sql connection
    $mysql=new MYSQL("server", "mysql userid", "mysql passwd", "mysql DB");

    //==== Extract Result
    $status = $mysql->RunDB("select * from user;");
    if ($status != "OK")
    {   echo "<HR>DB Error: $status.<HR>";
        die;
    }
    for ($i = 0; $i < $mysql->no_rows; $i ++)
    {
        echo "Record No: " . ($i + 1) ."<HR>";
        for ($j = 0; $j < $mysql->no_fields; $j ++)
        {
            $field_name = $mysql->field[$j];
            echo "Field: ".$field_name."  ----- Value: ".
                $mysql->row[$i][$field_name]."<BR>";
        }
    }

    //==== Use the built-in ShowHTML format
    $status = $mysql->RunDB("select * from user;");
    if ($status != "OK")
    {   echo "<HR>DB Error: $status.<HR>";
        die;
    }
    $mysql->ShowHTML("","","CENTER");

    //==== Run some query not expecting results
    $stmt = ("FILL IN YOUR STAEMENT eg. INSERT INTO");
    $status = $myql->RunDB($stmt, 0);
    if ($status
    if ($status != "OK")
    {   echo "<HR>DB Fail: $status.<HR>";
        die;
    }
    else
    {   echo "<HR>Success: $status.<HR>";
        die;
    }

?>
