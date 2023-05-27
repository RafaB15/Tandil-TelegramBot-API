#!/bin/sh
set -e 

docker-compose up -d
docker-compose exec webapp /bin/bash
