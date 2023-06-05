#!/bin/bash

source backup_restore.sh

read -p "Please enter the path for the file you want to restore: " backup_file_path
read -p "Please enter the encryption key: " encryption_key
read -p "Please enter the destination directory: " restore_destination_dir


validate_restore "$backup_file_path" "$encryption_key" "$restore_destination_dir"

restore "$backup_file_path" "$encryption_key" "$restore_destination_dir"
