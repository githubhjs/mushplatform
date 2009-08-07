<?php

class Model {

  private $db_host = 'localhost';
  private $db_username = 'root';
  private $db_password = '';
  private $db_name = 'first';

  function connect() {
    $conn = mysql_connect($this->db_host, $this->db_username, $this->db_password);
    if (!$conn) {
        die('Server connection problem: ' . mysql_error($conn));
    }

    if (!mysql_select_db($this->db_name, $conn)) {
        die('Database connection problem: ' . mysql_error($conn));
    }
    return $conn;
  }

  function close($conn) {
    if ($conn != NULL) {
      mysql_close($conn);
    }
  }

  function columns($table) {
    $columns = array();
    $conn = $this->connect();
    $result = mysql_query("SHOW COLUMNS FROM ".$table, $conn);
    if (!$result) {
        die('Query execution problem: ' . mysql_error($conn));
    }
    if (mysql_num_rows($result) > 0) {
        while ($row = mysql_fetch_assoc($result)) {
            $columns[] = $row['Field'];
        }
    }
    $this->close($conn);
    return $columns;
  }

  function query($sql, $columns) {
    $data = array();
    $conn = $this->connect();
    $result = mysql_query($sql, $conn);
    if (!$result) {
      die('Query execution problem: ' . mysql_error($conn));
    }

    while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
      $row_data = array();
      foreach ($columns as $c) {
        $row_data[$c] = $row[$c];
      }
      $data[] = $row_data;
    }
    $this->close($conn);
    return $data;
  }

  function insert($sql) {
    $this->_execute($sql);
  }

  function update($sql) {
    $this->_execute($sql);
  }

  function remove($sql) {
    $this->_execute($sql);
  }

  private function _execute($sql) {
    $conn = $this->connect();
    $result = mysql_query($sql, $conn);
    if (!$result) {
     die('Query execution problem: ' . mysql_error($conn));
    }
    $this->close($conn);
  }

}

?>
