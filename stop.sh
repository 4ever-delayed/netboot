#!/usr/bin/env bash
source .env
cp -r netbootxyz-config/menus/local/* ./custom-menus/
	docker-compose stop

for DIR in $WIN_10_DIR/*
  do	
	[ -d "$DIR" ] &&  sudo umount "${DIR}"  && sudo rm -rf "$DIR" && echo "succesfully unmounted $DIR"

  done 

  sudo losetup -D
