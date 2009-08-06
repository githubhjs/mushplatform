<?php

//######################################################################
//##### TITLE       :: CLASS MYSQL
//##### FILE        :: class_mysql.php
//##### PROJECT	    :: WebVision
//##### RELATED DOCUMENT :: None
//##### DESCRIPTION   ::
//#####     To provide access utility for MySQL access
//#####     RunDB is used to run SQL query with the result
//#####     grouped into array.
//##### AUTHOR      :: Mark Quah
//##### REVISION 	::
//######################################################################

class MYSQL
{
    var $no_rows=0, $row=array();
    var $no_fields=0, $field=array();

    //#-----------------------------------------------------------------
    //#---- FUNCTION :: MYSQL($p_host, $p_user, $p_passwd, $p_db="mysql")
    //#---- DESCRIPTION  ::
    //#----      Initialize class with information to access server
    //#----      No connection will be made at this point.
    //#---- INPUT ::
    //#----      p_host      : server hostname|IP address
    //#----      p_user      : user name to log into server
    //#----      p_passwd    : passwd for the user
    //#----      p_db        : database to be used
    //#---- OUTPUT ::
    //#----      none
    //#-----------------------------------------------------------------
    function MYSQL($p_host, $p_user, $p_passwd, $p_db="mysql")
    {
        $this->sql_host = $p_host;
        $this->sql_user= $p_user;
        $this->sql_passwd = $p_passwd;
        $this->sql_db = $p_db;
    } // end MYSQL

    //#-----------------------------------------------------------------
    //#---- FUNCTION :: RunDB($statement, $exp_result = "")
    //#---- DESCRIPTION ::
    //#----      Execute a MySQL statement in a non-persistant mode
    //#---- INPUT    ::
    //#----      p_statement : statement to be executed
    //#----      exp_result  : is result expected?
    //#----           value 1 (default): result stored in row array
    //#----           value 0: result not stored in row array
    //#---- OUTPUT   ::
    //#----      return "OK"        : succesful
    //#----      return err_message from mysql_connect
    //#----      exp_result==1: additional result stored into array row
    //#----          no_row contains no. of record retrieved
    //#----      	  row[recno][ "field" ] contains value of recno record
    //#----          field["fieldname"] contains the field list
    //#-----------------------------------------------------------------
    function RunDB($p_statement, $exp_result = 1)
    {
        //--- Connect to the Database
        $link=mysql_connect($this->sql_host, $this->sql_user, $this->sql_passwd);
        if (!$link)
            return sprintf("error connecting to host %s, by user %s",
                           $this->sql_host, $this->sql_user) ;
        //--- Select the Database
        if (!mysql_select_db($this->sql_db, $link))
        {   $err_msg=sprintf("Error in selecting %s database",
                     $this->sql_db);
            $err_msg .= sprintf("error:%d %s", mysql_errno($link),
                     mysql_error($link));
            return $err_msg;
	  }
        //--- Execute the Statement
        if (!($this->result=mysql_query($p_statement, $link)))
        {   $err_msg=sprintf("Error in selecting %s database\n",
                     $this->sqldb);
            $err_msg .= sprintf("\terror:%d\t\nerror message %s",
                        mysql_errno($link), mysql_error($link));
            return $err_msg;
        }
        //--- Organize the result
        if ($exp_result == 1)
        {   $this->no_rows = mysql_num_rows($this->result);
            $this->GroupResult();
        }
        //--- SUCCESS RETURN
        return OK;
    } // end function RunDB


    //#-----------------------------------------------------------------
    //#---- FUNCTION :: GroupResult( )
    //#---- DESCRIPTION ::
    //#----      To group the raw result retrieved in an associative array
    //#----      A query has to be made using RunDB prior to this execution
    //#----      The handle is storedin $result
    //#---- INPUT    :: None
    //#---- OUTPUT   :
    //#----      return none
    //#----      additional result stored into array
    //#----          no_row, row[recno]["field"] = value
    //#----          no_field, field["fieldname"]
    //#-----------------------------------------------------------------
    function GroupResult()
    {
        //--- Get RESULT
        $is_header = FALSE;
        for ( $recno = 0; $recno < $this->no_rows; $recno ++ )
        {   $row = mysql_fetch_object($this->result);
            //--- Get Field List
            if ( ! $is_header )
            {   $no_fields = 0;
                $t_row = $row;
                while ( $item = each($t_row) )
                {   $this->field[$no_fields] = $item["key"];
                    $no_fields ++;
                }
                $this->no_fields = $no_fields;
                $is_header = TRUE;
            }
            //---- GET DATA
            while ( $item = each($row))
                $this->row[$recno][$item["key"]] = $item["value"];
        }
        //--- END CONNECTION
        mysql_free_result($this->result);
    } // GroupResult

    //#-----------------------------------------------------------------
    //#---- FUNCTION :: ShowHTML($p_table="", $p_header = "", $p_cell = "")
    //#---- DESCRIPTION ::
    //#----      To return the result in HTML Table format
    //#---- INPUT    ::
    //#----      p_table    : HTML <Table> format
    //#----      p_header   : First row format
    //#----      p_cell     : Individual cell format
    //#---- OUTPUT   ::
    //#----      "OK"        : succesful
    //#----      err_message from mysql_connect
    //#-----------------------------------------------------------------
    function ShowHTML($p_table="", $p_header="", $p_cell="" )
    {
        //--- DEFAULT OPTION
        $p_table=($p_table=="")?"BGCOLOR=#BB9999 BORDER=1": $p_table;
        $p_header=($p_header=="")? "BGCOLOR=#9999BB" : $p_header;
        $p_cell=($p_cell=="")?"BGCOLOR=#99BB99":$p_cell;
        //--- DISPLAY TABLE
        echo "<TABLE ".$p_table.">";
        //--- DISPLAY HEADER LINE
        echo "<TR ".$p_header.">";
        echo "<TD>recno";
        for ($i = 0; $i < $this->no_fields; $i ++)
            printf("<TD>%s", $this->field[$i]);
        //--- DISPLAY DATA
        for ( $i = 0; $i < $this->no_rows; $i ++)
        {   echo "<TR $p_cell>";
            printf("<TD>%-3s", $i);
            for ($f = 0; $f < $this->no_fields; $f ++)
            {   $f_name = $this->field[$f];
                $f_value = $this->row[$i][$f_name];
                if ( $f_value=="" )
                    $f_value="&nbsp;";
                printf("<TD>%s", $f_value);
            }
        }
        //--- THE END
        echo "</TABLE>";
    } // ShowHTML

} // end class MYSQL
?>