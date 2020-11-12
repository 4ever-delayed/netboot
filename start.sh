#!/usr/bin/env bash
WIN_10_DIR=/media/d1/Dist/OS/netbootxyz
WIN_10_ISO_DIR=/media/d1/Dist/OS/Windows10_orig
WIN_PE_DIR=/media/d1/Dist/OS/WinPE
if [ ! -d "$WIN_10_DIR" ]; then
  mkdir -p $WIN_10_DIR && echo "created netbootxyz dir"
fi

if [ ! -d "$WIN_10_ISO_DIR" ]; then
  mkdir -p $WIN_10_ISO_DIR && echo "created Windows10_orig dir"
fi

if [ ! -d "$WIN_PE_DIR" ]; then
  mkdir -p $WIN_PE_DIR && echo "created WinPE dir"
fi

if [ ! -d "${WIN_10_DIR}/win" ]; then
  mkdir -p "${WIN_10_DIR}/win" && echo "created netbootxyz/win dir"
fi

for FILE in $WIN_PE_DIR/*.iso
  do
  DEST_DIR=$(basename "${FILE%.*}")
  [ ! -d "${WIN_10_DIR}/$DEST_DIR" ] && mkdir -p "${WIN_10_DIR}/${DEST_DIR}"  || echo "dir for $FILE already exists"
  sudo mount -o loop  "$FILE"  "${WIN_10_DIR}/$DEST_DIR"  && echo "mounted $FILE"
  done

for FILE in $WIN_PE_DIR/*.ISO
  do
  DEST_DIR=$(basename "${FILE%.*}")
  [ ! -d "${WIN_10_DIR}/$DEST_DIR" ] && mkdir -p "${WIN_10_DIR}/${DEST_DIR}"  || echo "dir for $FILE already exists"
  sudo mount -o loop  "$FILE"  "${WIN_10_DIR}/$DEST_DIR"  && echo "mounted $FILE"
  done



sudo mount -o loop ${WIN_10_ISO_DIR}/*.iso $WIN_10_DIR/win  &&  echo "mounted Win 10 ISO" || echo "already mounted"

sudo docker-compose up -d
