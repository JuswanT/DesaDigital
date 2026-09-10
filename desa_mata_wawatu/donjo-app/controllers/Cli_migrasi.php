<?php

class Cli_migrasi extends CI_Controller {
    public function index() {
        if (!is_cli()) {
            echo "Only CLI allowed\n";
            exit;
        }
        $db = new \App\Libraries\Database();
        $db->setShowProgress(1);
        echo "Starting migrations...\n";
        
        $doesntHaveMigrasiConfigId = ! \Illuminate\Support\Facades\Schema::hasColumn('migrasi', 'config_id');
        \App\Models\Migrasi::when($doesntHaveMigrasiConfigId, static fn ($q) => $q->withoutConfigId())->whereNotNull('id')->delete();

        $db->migrateDatabase(true);
        echo "Migrations finished.\n";
    }
}
