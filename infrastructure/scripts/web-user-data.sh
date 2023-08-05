#!/bin/bash
set -euo pipefail #script will fail quickly if there is an error and gets better outputs 

sudo apt-get update
sudo apt-get install -yq python3-pip
sudo pip install psycopg2-binary flask

echo "installed all successfully" 

#git clone https://github.com/yovelchen/Terraform.git 

#echo "git cloned successfully"

sudo chmod +x /var/lib/waagent/custom-script/download/0/terraform/application/flaskApp/flaskApp.py

# the crontab does not work yet... 
#sudo (crontab -l 2>/dev/null; echo "@reboot /usr/bin/python3 /var/lib/waagent/custom-script/download/0/Final_project/Terraform/flaskApp/flaskApp.py") | crontab -

#echo "inserted data to crontab successfully"

sudo python3 /var/lib/waagent/custom-script/download/0/terraform/application/flaskApp/flaskApp.py > output.log 2>&1 &

echo "python is running successfully"

APP_PATH="/var/lib/waagent/custom-script/download/0/terraform/application/flaskApp"
APP_PYTHON="/usr/bin/python3"
APP_USER="azureuser"
SERVICE_NAME="my_flask_app_service"
cat << EOF | sudo tee /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=My Flask Application
After=network.target

[Service]
User=$APP_USER
WorkingDirectory=$APP_PATH
ExecStart=$APP_PYTHON $APP_PATH/flaskApp.py

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable $SERVICE_NAME.service
sudo systemctl start $SERVICE_NAME.service

echo "A service for the application was created. the app will run if the VM restarts"
