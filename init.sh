#!/bin/bash

cd middleware
bash ./initdir.sh
echo "Middleware init done"

cd nginx
bash ./sync-frontend.sh

cd ../../

cd microsystem
bash ./sync-and-restart.sh --download-only
echo "Apps download done"

cd ../

bash ./replace_ip.sh

