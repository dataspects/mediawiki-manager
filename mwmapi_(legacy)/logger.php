<?php

class Logger {

    function __construct() {
        $this->logFile = "/var/www/html/dsmwm.log";
    }

    public function write(string $item) {
        $entry = $this->timestamp()." ".$item;
        file_put_contents($this->logFile, $entry."\n", FILE_APPEND);
        return $entry;
    }

    public function viewLog() {
        return array(
            "file" => $this->logFile,
            "content" => file_get_contents($this->logFile)
        );
    }

    private function timestamp() {
        $date = new DateTime();
        return $date->format('Y-m-d H:i:s');
    }

}

// error_log("_______________________________________".$mediaWikiVersion."_______________________________________");