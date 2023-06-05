#!/bin/bash

source backup_restore.sh

read -p "Please enter the source directory for the file you want to backup: " source_dir
read -p "Please enter the distination for the backup directory: " dist_dir
read -p "Please enter the number of days to backup: " num_days
read -p "Please enter the encryption key: " encryption_key
read -p "Please enter the remote server address: " remote_server_address
read -p "Please enter the remote server username: " remote_username
read -p "Please enter the distination path for the remote server directory: " remote_destination_dir


validate_backup "$source_dir" "$dist_dir" "$num_days" "$encryption_key" "$remote_server_address" "$remote_username" "$remote_destination_dir"

backup "$source_dir" "$dist_dir" "$num_days" "$encryption_key" "$remote_server_address" "$remote_username" "$remote_destination_dir"

