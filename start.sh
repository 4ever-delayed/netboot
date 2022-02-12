#!/usr/bin/env bash
. ./.env
if [ ! -d "${WIN_10_DIR}" ]; then
  mkdir -p ${WIN_10_DIR} && echo "created netbootxyz dir"
fi

if [ ! -d "${WIN_10_ISO_DIR}" ]; then
  mkdir -p ${WIN_10_ISO_DIR} && echo "created Windows10_orig dir" &&
  echo "will download Win10 original ISO now" &&
 # curl -s https://gist.githubusercontent.com/hongkongkiwi/15a5bf16437315df256c118c163607cb/raw/71cc4bdc43d8c3d8fd2e1aefde710c9e7481d7f7/download-windows-10.sh | bash
  bash download-windows-10.sh
fi

if [ ! -d "${WIN_PE_DIR}" ]; then
  mkdir -p ${WIN_PE_DIR} && echo "created WinPE dir"
fi

#if [ ! -d "$WIN_SERV_2019" ]; then
#  mkdir -p $WIN_SERV_2019 && echo "created Windows_serv_2019 dir"
#fi

#if [ ! -d "$WIN_SERV_2012" ]; then
#  mkdir -p $WIN_SERV_2012 && echo "created Windows_serv_2012r2 dir"
#fi



if [ ! -d "$WIN_PE_DIR" ]; then
  mkdir -p $WIN_PE_DIR && echo "created WinPE dir"
fi
if [ ! -f "${WIN_PE_DIR}/HBCD_PE_x64.iso" ]; then
  echo "downloading WinPE ISO..." &&  wget https://www.hirensbootcd.org/files/HBCD_PE_x64.iso -P ${WIN_PE_DIR}
fi

if [ ! -d "${WIN_10_DIR}/win" ]; then
  mkdir -p "${WIN_10_DIR}/win" && echo "created netbootxyz/win dir"
fi

#if [ ! -d "${WIN_10_DIR}/win_serv" ]; then
#  mkdir -p "${WIN_10_DIR}/win_serv" && echo "created netbootxyz/win_serv dir" || echo "failed to create ${WIN_10_DIR}/win_serv dir"
#fi

#if [ ! -d "${WIN_10_DIR}/win_serv2012r2" ]; then
#  mkdir -p "${WIN_10_DIR}/win_serv2012r2" && echo "created netbootxyz/win_serv2012r2 dir" || echo "failed to create ${WIN_10_DIR}/win_serv2012r2 dir"
#fi



#for FILE in ${WIN_PE_DIR}/*
#  do
#  DEST_DIR=$(basename "${FILE%.*}")
#  [ ! -d "${WIN_10_DIR}/$DEST_DIR" ] && mkdir -p "${WIN_10_DIR}/${DEST_DIR}"  || echo "dir for $FILE already exists"
#  sudo mount -o loop  "$FILE"  "${WIN_10_DIR}/$DEST_DIR" 2>/dev/null && echo "mounted $FILE"
#  done

for FILE in  $(ls ${WIN_PE_DIR}/*)
  do
  DEST_DIR=$(basename "${FILE%.*}")
  [ ! -d "${WIN_10_DIR}/$DEST_DIR" ] && mkdir -p "${WIN_10_DIR}/${DEST_DIR}"  || echo "dir for ${FILE} already exists"
  sudo mount -o loop  "${FILE}"  "${WIN_10_DIR}/${DEST_DIR}"  && echo "mounted $FILE"
  done





sudo mount -o loop ${WIN_10_ISO_DIR}/* ${WIN_10_DIR}/win || echo "failed to mount win10 iso,are ISO downloaded?If automatic downloads from ms servers failed, please download win 10 iso manually and place to Windows10orig folder which samba share, then execute restart.sh"
docker-compose up -d --build --force-recreate && 
cp -r ./custom-menus/* ${CONFIG_PATH}/menus/local/ &&
cp -r ./custom-menus/* ${CONFIG_PATH}/menus/remote/ &&
cp ./custom-menus/wimboot ${WIN_10_DIR}/wimboot  &&
cp  winpeshl.ini install.bat ${WIN_10_DIR}/
