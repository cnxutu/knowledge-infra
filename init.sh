#!/bin/bash
set -euo pipefail

cd middleware
bash ./initdir.sh
echo "Middleware init done"

cd nginx
bash ./sync-frontend.sh
echo "Frontend sync done"

cd ../../

cd microsystem
bash ./sync-and-restart.sh --download-only
echo "Apps download done"

cd ../

bash ./replace_ip.sh

