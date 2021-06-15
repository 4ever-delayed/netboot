#!/usr/bin/env bash
source .env
if [ ! -d "$WIN_10_DIR" ]; then
  mkdir -p $WIN_10_DIR && echo "created netbootxyz dir"
fi

if [ ! -d "$WIN_10_ISO_DIR" ]; then
  mkdir -p $WIN_10_ISO_DIR && echo "created Windows10_orig dir" &&
  echo "will download Win10 original ISO now" &&
  bash download-windows-10.sh
fi

if [ ! -d "$WIN_PE_DIR" ]; then
  mkdir -p $WIN_PE_DIR && echo "created WinPE dir"
fi
if [ ! -f "${WIN_PE_DIR}/HBCD_PE_x64.iso" ]; then
  echo "downloading WinPE ISO..." &&  wget https://www.hirensbootcd.org/files/HBCD_PE_x64.iso -P $WIN_PE_DIR
fi


if [ ! -d "${WIN_10_DIR}/win" ]; then
  mkdir -p "${WIN_10_DIR}/win" && echo "created netbootxyz/win dir"
fi

#for FILE in ${WIN_PE_DIR}/*
#  do
#  DEST_DIR=$(basename "${FILE%.*}")
#  [ ! -d "${WIN_10_DIR}/$DEST_DIR" ] && mkdir -p "${WIN_10_DIR}/${DEST_DIR}"  || echo "dir for $FILE already exists"
#  sudo mount -o loop  "$FILE"  "${WIN_10_DIR}/$DEST_DIR" 2>/dev/null && echo "mounted $FILE"
#  done

for FILE in  $(ls ${WIN_PE_DIR}/*)
  do
  DEST_DIR=$(basename "${FILE%.*}")
  [ ! -d "${WIN_10_DIR}/$DEST_DIR" ] && mkdir -p "${WIN_10_DIR}/${DEST_DIR}"  || echo "dir for $FILE already exists"
  sudo mount -o loop  "$FILE"  "${WIN_10_DIR}/$DEST_DIR"  && echo "mounted $FILE"
  done



sudo mount -o loop ${WIN_10_ISO_DIR}/* ${WIN_10_DIR}/win  && 
docker-compose up -d --build --force-recreate && cp -r ./custom-menus/* ./netbootxyz-config/menus/local/ && cp -r ./custom-menus/* ./netbootxyz-config/menus/remote/
cp ./custom-menus/wimboot ${WIN_10_DIR}/wimboot 
cp  winpeshl.ini install.bat ${WIN_10_DIR}/
