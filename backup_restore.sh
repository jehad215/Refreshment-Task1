#!/bin/bash

validate_backup() {
    local source_dir=$1
    local dist_dir=$2
    local num_days=$3
    local encryption_key=$4
    local remote_server_address=$5
    local remote_username=$6
    local remote_destination_dir=$7

    if [ ! -d "$source_dir" ]; then
        echo "Source directory '$source_dir' not exist."
        exit 1
    fi

    if [ ! -d "$dist_dir" ] && ! mkdir -p "$dist_dir"; then
        echo "Backup directory '$dist_dir' not exist."
        exit 1
    fi

    if ! [[ "$num_days" =~ ^[1-9][0-9]*$ ]]; then
        echo "Number of days must be integer."
        exit 1
    fi

    if [ -z "$encryption_key" ]; then
        echo "You must enter encryption key to encrypt your file."
        exit 1
    fi
}

validate_restore() {
    local backup_file_path=$1
    local encryption_key=$2
    local restore_destination_dir=$3

    if [ ! -f "$backup_file_path" ]; then
        echo "Backup file '$backup_file_path' not exist."
        exit 1
    fi

    if [ -z "$encryption_key" ]; then
        echo "You must enter encryption key."
        exit 1
    fi

    if [ ! -d "$restore_destination_dir" ] && ! mkdir -p "$restore_destination_dir"; then
        echo "Restore destination '$restore_destination_dir' not exist."
        exit 1
    fi
}

backup() {
    local source_dir=$1
    local dist_dir=$2
    local num_days=$3
    local encryption_key=$4
    local remote_server_address=$5
    local remote_username=$6
    local remote_destination_dir=$7

    local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

    local backup_path="$dist_dir/$timestamp"
    mkdir -p "$backup_path"

    find "$source_dir" -type f -mtime -$num_days -exec cp {} "$backup_path" \;

    tar -czf "$backup_path.tar.gz" "$backup_path"

    gpg --symmetric --cipher-algo AES256 --passphrase "$encryption_key" "$backup_path.tar.gz"

    rm "$backup_path.tar.gz"

    scp "$backup_path.tar.gz.gpg" "$remote_username@$remote_server_address:$remote_destination_dir"

    rm -r "$backup_path"

    echo "Voilaa, backup process completed successfully"
}

restore() {
    local backup_file_path=$1
    local encryption_key=$2
    local restore_destination_dir=$3

    gpg --decrypt --passphrase "$encryption_key" "$backup_file_path" > backup.tar.gz

    tar -xzf backup.tar.gz -C "$restore_destination_dir"

    rm backup.tar.gz

    echo "Congratulations, restore done successfully"
}
