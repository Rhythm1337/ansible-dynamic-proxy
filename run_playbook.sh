#!/bin/bash

# Change to the directory containing the playbook
cd /home/ansible/files || exit 1  # Exit if cd fails

# Get the current date and time and log it
#echo "Running playbook at: $(date)" >> run_playbook.log  # Append the timestamp to the log

# Run the ansible-playbook command and capture output with timestamps
/home/ansible/.local/bin/ansible-playbook playbook.yml 2>&1 | \
while IFS= read -r line; do
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $line" >> run_playbook.log
done

