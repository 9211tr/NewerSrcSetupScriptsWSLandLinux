#!/bin/bash

#
#  Script that you can EASILY run whenever you want to rename the compiled NewerSMBW .BIN files.
#  Script filename: RenameNewerBinFiles.sh
#  Script by 9211tr.
#
#  There is no need to do any extra commands/stuff in the script/etc., you just need to run this script, and you will be able to rename the compiled NewerSMBW .BIN files!
#  Place this script in the Kamek/NewerASM folder of the NewerSMBW sources folder.
#  This script works on Mac OS X and Linux.
#

clear
echo


if [ -d "renamed" ]
then
    rm -r renamed
fi

mkdir renamed
mv n_jpn_dlcode.bin renamed/DLCodeJP_1.bin
mv n_jpn2_dlcode.bin renamed/DLCodeJP_2.bin 
mv n_jpn_dlrelocs.bin renamed/DLRelocsJP_1.bin 
mv n_jpn2_dlrelocs.bin renamed/DLRelocsJP_2.bin
mv n_jpn_loader.bin renamed/SystemJP_1.bin
mv n_jpn2_loader.bin renamed/SystemJP_2.bin
mv n_ntsc_dlcode.bin renamed/DLCodeUS_1.bin
mv n_ntsc2_dlcode.bin renamed/DLCodeUS_2.bin
mv n_ntsc_dlrelocs.bin renamed/DLRelocsUS_1.bin
mv n_ntsc2_dlrelocs.bin renamed/DLRelocsUS_2.bin
mv n_ntsc_loader.bin renamed/SystemUS_1.bin
mv n_ntsc2_loader.bin renamed/SystemUS_2.bin
mv n_pal_dlcode.bin renamed/DLCodeEU_1.bin
mv n_pal2_dlcode.bin renamed/DLCodeEU_2.bin
mv n_pal_dlrelocs.bin renamed/DLRelocsEU_1.bin
mv n_pal2_dlrelocs.bin renamed/DLRelocsEU_2.bin
mv n_pal_loader.bin renamed/SystemEU_1.bin
mv n_pal2_loader.bin renamed/SystemEU_2.bin
