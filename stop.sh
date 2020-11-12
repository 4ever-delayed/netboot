#!/usr/bin/env bash
. ./conf
docker-compose stop

for DIR in $WIN_10_DIR/*
  do
  sudo umount "$DIR" 2>/dev/null && sudo rm -rf "$DIR" && echo "succesfully unmounted $DIR"
  done

  sudo losetup -D
