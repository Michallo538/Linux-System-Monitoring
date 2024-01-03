#!/bin/bash

#Creating all the variables and the directory to where they are.
HTML_FILE="Automation.html"
AUDIT_LOG="/var/log/audit/audit.log"
PACKAGE_LOG="./package.log"


#This echoes/prints a date and time of each commands that is being printed below. 
log_html() {
	echo "<p style=\"font-family: Arial, sans-serif;\">$(date '+%Y-%m-%d %H:%M:%S') - $1</p>" >> "$HTML_FILE"
}
#Logs all the users that are currently logged-in
log_users_html(){
	log_html "<strong>Currently Logged in users:</strong>"
	who >> "$HTML_FILE"
}
#This logs all the processes in the html file.
log_processes_html() {
	log_html "<strong>Current processes:</strong>"
	ps aux  >> "$HTML_FILE"
}
#This runs ps aux command which is responsible for fetching all the processes, by that it reduces these to be the top 4 that utilize the processor.
log_top_cpu_processes_html() {
	log_html "<strong>Top 4 CPU utilizing processes:</strong>"
	ps aux --sort=-%cpu | head -n 5 >> "$HTML_FILE"
}

log_devices_html() {
	log_html "<strong>Devices plugged in (USB):</strong>"
	lsusb >> "$HTML_FILE"
}
log_disk_usage_html() {
	log_html "<stong>Disk usage:</strong>"
	df -h >> "$HTML_FILE"
}
log_network_interfaces_html() {
	log_html "<strong>Network interfaces and their states:</strong>"
	ifconfig >> "$HTML_FILE"
}

#Extra features/information
log_system_file_changes_html() {
	log_html "<strong> OS System file changes:</strong>"
	cat "$AUDIT_LOG" | grep "type=PATH msg=audit" >> "$HTML_FILE"
}
log_installed_applications_html(){
	log_html "<strong> OS System file changes: </strong>"

	if [ -e "$PACKAGE_LOG" ]; then
	   cat "$PACKAGE_LOG" >> "$HTML_FILE"
	else
	   log_html "Package log file not found."
	 fi
}

echo "<html><head><title>System Monitoring</title></head><body style=\"background-color: #f4f4f4; margin: 20px;\">" >> "$HTML_FILE"
echo "<div style=\"max-width: 800px; margin: auto;\">" >> "$HTML_FILE"


#Main Processes - these scripts are calling above scripts and running them inside of the HTML Page.
log_users_html
log_processes_html
log_top_cpu_processes_html
log_devices_html
log_disk_usage_html
log_network_interfaces_html

echo "<strong>Additional/Extra Information</strong>" >> "$HTML_FILE"

log_system_file_changes_html
log_installed_applications_html

echo "</div></body></html>" >> "$HTML_FILE"


if [ $? -eq 0 ]; then
	echo "Script executed successfully."
else
	echo "Script encountered an error"
fi


