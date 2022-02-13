#!/usr/bin/env bash
. ./.env
cp -r ${CONFIG_PATH}/menus/local/* ./custom-menus/
	docker-compose stop

for DIR in $NETBOOT_ROOT_DIR/*
  do
  sudo umount "$DIR" 2>/dev/null && sudo rm -rf "$DIR" && echo "succesfully unmounted $DIR"
  done

  sudo losetup -D
