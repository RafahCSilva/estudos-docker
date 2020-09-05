<?php

// config
ini_set('log_errors', 'On');
ini_set('error_log', '/proc/self/fd/2');
//ini_set('error_log', '/dev/stderr');
error_reporting(E_ALL);

// fuck daemon
for ($i = 0; $i < 10; $i++) {
    echo "Tick ".date('H:i:s').PHP_EOL;
    sleep(2);
    error_log("Tok ".date('H:i:s'));
}

// throws
throw new \Exception('e acabou...');
