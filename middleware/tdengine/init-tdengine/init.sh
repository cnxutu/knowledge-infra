#!/bin/sh
docker exec tdengine taos -s "CREATE DATABASE IF NOT EXISTS iot;"
docker exec tdengine taos -s "show databases" | grep iot && echo "OK: iot database created" || echo "FAIL: iot database not found"