#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
logPath="$CURRENT_DIR/log_tomcat"

log_message() {
        sudo echo -e $1 >> $logPath
}

sudo echo "======================================================================================================================================================================="
sudo echo "================================================================================$(date)================================================================================"

log_message "======================================================================================================================================================================="
log_message "================================================================================$(date)================================================================================"

sudo systemctl status tomcat >> $logPath 2>&1
log_message " "

log_message "============================================================= Execute job reload servie tomcat is running ============================================================="

status_tomcat=$(systemctl status tomcat | grep running | grep -v not | wc -l)
echo "--- value_tomcat = $status_tomcat -------- value tomcat > 0 kill and start or value tomcat = 0 start"

        if [ "$status_tomcat" -ne 1 ]
                then
                                sudo echo "--- value_tomcat = $status_tomcat -------- start service tomcat"
                        sudo systemctl start tomcat
                sleep 2
        else
                                sudo echo "--- value_tomcat = $status_tomcat -------- kill and start service tomcat"
                PID_tomcat_old=$(ps -ef | grep tomcat | grep java | awk '{print $2}')
                sudo echo "Get pid service tomcat is running $PID_tomcat_old"
                log_message "Get pid service tomcat is running $PID_tomcat_old"
                sudo sleep 1
                kill -9 $PID_tomcat_old
                echo "Stoped pid service tomcat $PID_tomcat_old"
                log_message "Stoped pid service tomcat $PID_tomcat_old"
                sudo sleep 3
                sudo systemctl start tomcat
                sudo sleep 2
        fi

PID_tomcat_new=$(ps -ef | grep tomcat | grep java | awk '{print $2}')
echo "Service tomcat is running with new pid $PID_tomcat_new"
log_message "Service tomcat is running with new pid $PID_tomcat_new"

sudo systemctl status tomcat >> $logPath 2>&1


