#!/bin/bash

#
#  Script for setting up the "compiling" of (and also installs/uninstalls) the NewerSMBW source code on the Microsoft Windows 10 Linux Subsystem (or "WSL subsystem").
#  Script filename: NewerSMBWSrcSetup_WindowsWSL.sh           
#  Script by 9211tr.
#
#  Requirements on PC:
#    - An internet connection.
#    - 22 GB of free disk space.
#    - Microsoft Windows 10 64-bit OS and an x64-based processor in your PC.
#    - The Windows 10 WSL subsystem installed/working (which also requires the Windows 10 Anniversary Update BUILD 14393.0 Version 1607 {or higher}).
#
#
#  DO NOT TOUCH OR MODIFY PARTS OF THIS SCRIPT, UNLESS IF YOU KNOW WHAT YOU'RE DOING!!!!
#  ALSO, I'M NOT RESPONSIBLE FOR WHAT DAMAGE IS CAUSED TO YOUR WINDOWS 10 LINUX/WSL ENVIRONMENT, YOUR PC, ETC.,
#  BECAUSE OF THIS SCRIPT. ONLY YOU ALONE ARE RESPONSIBLE FOR ANY DAMAGE CAUSED.
#
#  Estimated time for installation: 2 or 3 hours.
#  Estimated time for uninstallation: About/near 2 minutes.
#  And after uninstallation, the estimated disk space freed should be about/near 12 GB.
#
#  These estimations might be incorrect, but it all depends on your
#  computer specs, internet connection speed, etc.
#
#  Bug Reports, suggestions, comments, or any changes
#  to the script (if I approve of them) are always permitted.
#  The official repository for this script is: https://github.com/9211tr/NewerSrcSetupScriptsWSLandLinux
#    

clear
echo


#
#  Set the paths, etc. for the install or download directories for
#  the NewerSMBW sources and other tools right here, but do not add any
#  slashes (/) at the end of them, except for variable TARGET_DIR_INSTALL.
#  Also too, for path names, do not use left slashes (\).
#
#  If you don't know what you're doing, DO NOT TOUCH THESE VARIABLES AT ALL.
#
TARGET_DIR_INSTALL=/
DEVKITPPC_DOWNLOAD_DIR=${TARGET_DIR_INSTALL}
LLVM_SRC_DOWNLOAD_DIR=${TARGET_DIR_INSTALL}llvm
NEWER_PATCHED_LLVM_INSTALL_DIR=${TARGET_DIR_INSTALL}NewerSMBW-LLVM
NEWER_SRC_DOWNLOAD_DIR=${TARGET_DIR_INSTALL}NewerSMBW-no-translations

#
#  These are the download URL(s)/Link(s) and SVN checkout
#  revision variables (for downloading the NewerSMBW sources
#  and required tools).
#
#  If you don't know what you're doing, DO NOT TOUCH THESE VARIABLES AT ALL.
#
LLVM_REVISION_SVN=184655
LLVM_URL_SVN=http://llvm.org/svn/llvm-project/llvm/trunk
LLVM_CLANGEXT_URL_SVN=http://llvm.org/svn/llvm-project/cfe/trunk
LLVM_COMPILEREXT_URL_SVN=http://llvm.org/svn/llvm-project/compiler-rt/trunk
NEWER_SRC_URL_SVN=https://github.com/Treeki/NewerSMBW/branches/no-translations
DEVKITPPC_URL_DL=https://github.com/devkitPro/buildscripts/releases/download/devkitPPC_r35/devkitPPC_r35-linux.tar.xz


#
#  Main script data is below this text. DO NOT MODIFY ANYTHING HERE!!!!
#
if [ "$(uname)" = "Linux" ] && grep -qi Microsoft "/proc/sys/kernel/osrelease"
then
    if [ "$(uname -m)" != "x86_64" ]
    then
        echo "ERROR: The Windows 10 Linux subsystem"
        echo "architecture must be 64-bit (i.e. \"x86_64\"),"
        echo "not \"$(uname -m)\"."
        echo
        exit 1
    fi
else
    echo "ERROR: The Linux OS type must be the"
    echo "Windows 10 Linux subsystem (for NewerSMBW"
    echo "sources tools/compiling setup on Windows 10)."
    echo
    exit 1
fi

while [ "$(expr substr $RESPONSE 1 1)" != "I" ] && [ "$(expr substr $RESPONSE 1 1)" != "i" ] && [ "$(expr substr $RESPONSE 1 1)" != "U" ] && [ "$(expr substr $RESPONSE 1 1)" != "u" ] && [ "$(expr substr $RESPONSE 1 1)" != "A" ] && [ "$(expr substr $RESPONSE 1 1)" != "a" ]
do
  clear
  echo "######################################################"
  echo
  echo "     NewerSMBW Sources Compiling Setup Installer      "
  echo "         and Uninstaller Script for Microsoft         "
  echo "             Windows 10 Linux subsystem.              "
  echo "                     by 9211tr                        "
  echo
  echo "               Revision 3 (12/22/2019)                "
  echo
  echo "######################################################"
  echo
  echo
  read -p "Do you want to (i)nstall, (u)ninstall, or (a)bort?: " RESPONSE
  clear
done

if [ "$(expr substr $RESPONSE 1 1)" = "A" ] || [ "$(expr substr $RESPONSE 1 1)" = "a" ]
then
    echo
    exit 0
elif [ "$(expr substr $RESPONSE 1 1)" = "I" ] || [ "$(expr substr $RESPONSE 1 1)" = "i" ]
then
    echo "[1: SET INSTALL DIRECTORY TO $TARGET_DIR_INSTALL AND"
    echo "INSTALL REQUIRED TOOLS (GCC/MAKE, CMAKE, PYELFTOOLS/PYYAML, AND SVN]:"
    echo
    cd $TARGET_DIR_INSTALL
    apt-get install -y gcc
    apt-get install -y make
    apt-get install -y cmake
    apt-get install -y subversion
    apt-get install -y python-pip
    pip install pyelftools
    pip install pyyaml


    clear
    echo "[2: DOWNLOADING THE \"WORKING\" NEWERSMBW SOURCES TO $NEWER_SRC_DOWNLOAD_DIR/]:"
    echo
    svn co $NEWER_SRC_URL_SVN $NEWER_SRC_DOWNLOAD_DIR


    clear
    echo "[3: DOWNLOADING DEVKITPPC REVISION 35 TO $DEVKITPPC_DOWNLOAD_DIR]:"
    echo
    wget -O devkitPPC.tar.xz $DEVKITPPC_URL_DL  
    tar -xvf devkitPPC.tar.xz -C $DEVKITPPC_DOWNLOAD_DIR
    rm devkitPPC.tar.xz
    cd $TARGET_DIR_INSTALL


    clear
    echo "[4: DOWNLOADING LLVM COMPILER (MAIN DATA) REVISION $LLVM_REVISION_SVN TO $LLVM_SRC_DOWNLOAD_DIR/]:"
    echo
    svn co -r $LLVM_REVISION_SVN $LLVM_URL_SVN $LLVM_SRC_DOWNLOAD_DIR
    clear
    echo "[4B: DOWNLOADING LLVM COMPILER (CLANG EXTENSION) REVISION"
    echo "$LLVM_REVISION_SVN TO $LLVM_SRC_DOWNLOAD_DIR/tools/clang/]:"
    echo
    svn co -r $LLVM_REVISION_SVN $LLVM_CLANGEXT_URL_SVN $LLVM_SRC_DOWNLOAD_DIR/tools/clang
    clear
    echo "[4C: DOWNLOADING LLVM COMPILER (COMPILER EXTENSION) REVISION"
    echo "$LLVM_REVISION_SVN TO $LLVM_SRC_DOWNLOAD_DIR/projects/compiler-rt/]:"
    echo
    svn co -r $LLVM_REVISION_SVN $LLVM_COMPILEREXT_URL_SVN $LLVM_SRC_DOWNLOAD_DIR/projects/compiler-rt


    clear
    echo "[5: PATCHING NEWERSMBW SETTINGS TO LLVM (CLANG EXTENSION) REVISION $LLVM_REVISION_SVN]:"
    echo
    cd $LLVM_SRC_DOWNLOAD_DIR/tools/clang
    patch -p0 -i $NEWER_SRC_DOWNLOAD_DIR/ClangPatches/clang_cw_patches_r184655.diff


    clear
    echo "[6: BUILDING NEWER-PATCHED LLVM REVISION"
    echo "$LLVM_REVISION_SVN TO $NEWER_PATCHED_LLVM_INSTALL_DIR/]:"
    echo
    mkdir $NEWER_PATCHED_LLVM_INSTALL_DIR
    mkdir $LLVM_SRC_DOWNLOAD_DIR/build
    cd $LLVM_SRC_DOWNLOAD_DIR/build
    cmake -DLLVM_DEFAULT_TARGET_TRIPLE=powerpc-unknown-unknown-unknown -DPYTHON_EXECUTABLE=/usr/bin/python -DLLVM_TARGETS_TO_BUILD="PowerPC" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$NEWER_PATCHED_LLVM_INSTALL_DIR" $LLVM_SRC_DOWNLOAD_DIR
    make
    make install
    cd $TARGET_DIR_INSTALL
    rm -r $LLVM_SRC_DOWNLOAD_DIR


    clear
    echo "[7: TEST COMPILE NEWER SOURCES TO .BIN & RENAME THEM (IF SUCCESSFUL, IN"
    echo "$NEWER_SRC_DOWNLOAD_DIR/Kamek/NewerASM/renamed/, YOU'LL SEE .BIN FILES)]:"
    echo
    cd $NEWER_SRC_DOWNLOAD_DIR/Kamek
    mv src/heapbar.S src/heapbar2.S
    sed -e '129d' src/heapbar2.S > src/heapbar.S
    rm src/heapbar2.S
    mkdir processed
    mkdir NewerASM
    python tools/mapfile_tool.py
    python tools/kamek.py NewerProjectKP.yaml --show-cmd --no-rels --use-clang --gcc-type=${DEVKITPPC_DOWNLOAD_DIR}devkitPPC/bin/powerpc-eabi --llvm-path=${NEWER_PATCHED_LLVM_INSTALL_DIR}/bin
    cd NewerASM
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
    cd $TARGET_DIR_INSTALL


    clear
    echo "[8: FINISHING INSTALLATION]:"
    echo
    echo "" > ${TARGET_DIR_INSTALL}newersmbw_compile2.sh
    sed -e "1i#\!/bin/bash\n\n#\n#  This is the necessary script that you can EASILY run whenever you want to compile the NewerSMBW Sources.\n#  There is no need to do any extra commands/stuff in the script/etc., you just need to run this script, and you will be able to compile NewerSMBW\!\n#\n#  P.S.: You can use the  --autorename  option (when you run the script), to auto-rename the kamek-compiled .BIN files to their NewerSMBW-readable names.\n#  Script by 9211tr.\n#\n\nclear\necho\n\n\ncd $NEWER_SRC_DOWNLOAD_DIR/Kamek\nif [ -d \"NewerASM/renamed\" ]; then rm -r NewerASM/renamed; fi\nif [ -f \"NewerASM/n_jpn_dlcode.bin\" ]; then rm NewerASM/n_jpn_dlcode.bin; fi\nif [ -f \"NewerASM/n_jpn2_dlcode.bin\" ]; then rm NewerASM/n_jpn2_dlcode.bin; fi\nif [ -f \"NewerASM/n_jpn_dlrelocs.bin\" ]; then rm NewerASM/n_jpn_dlrelocs.bin; fi\nif [ -f \"NewerASM/n_jpn2_dlrelocs.bin\" ]; then rm NewerASM/n_jpn2_dlrelocs.bin; fi\nif [ -f \"NewerASM/n_jpn_loader.bin\" ]; then rm NewerASM/n_jpn_loader.bin; fi\nif [ -f \"NewerASM/n_jpn2_loader.bin\" ]; then rm NewerASM/n_jpn2_loader.bin; fi\nif [ -f \"NewerASM/n_ntsc_dlcode.bin\" ]; then rm NewerASM/n_ntsc_dlcode.bin; fi\nif [ -f \"NewerASM/n_ntsc2_dlcode.bin\" ]; then rm NewerASM/n_ntsc2_dlcode.bin; fi\nif [ -f \"NewerASM/n_ntsc_dlrelocs.bin\" ]; then rm NewerASM/n_ntsc_dlrelocs.bin; fi\nif [ -f \"NewerASM/n_ntsc2_dlrelocs.bin\" ]; then rm NewerASM/n_ntsc2_dlrelocs.bin; fi\nif [ -f \"NewerASM/n_ntsc_loader.bin\" ]; then rm NewerASM/n_ntsc_loader.bin; fi\nif [ -f \"NewerASM/n_ntsc2_loader.bin\" ]; then rm NewerASM/n_ntsc2_loader.bin; fi\nif [ -f \"NewerASM/n_pal_dlcode.bin\" ]; then rm NewerASM/n_pal_dlcode.bin; fi\nif [ -f \"NewerASM/n_pal2_dlcode.bin\" ]; then rm NewerASM/n_pal2_dlcode.bin; fi\nif [ -f \"NewerASM/n_pal_dlrelocs.bin\" ]; then rm NewerASM/n_pal_dlrelocs.bin; fi\nif [ -f \"NewerASM/n_pal2_dlrelocs.bin\" ]; then rm NewerASM/n_pal2_dlrelocs.bin; fi\nif [ -f \"NewerASM/n_pal_loader.bin\" ]; then rm NewerASM/n_pal_loader.bin; fi\nif [ -f \"NewerASM/n_pal2_loader.bin\" ]; then rm NewerASM/n_pal2_loader.bin; fi\n\npython tools/mapfile_tool.py\npython tools/kamek.py NewerProjectKP.yaml --show-cmd --no-rels --use-clang --gcc-type=${DEVKITPPC_DOWNLOAD_DIR}devkitPPC/bin/powerpc-eabi --llvm-path=${NEWER_PATCHED_LLVM_INSTALL_DIR}/bin\n\nif [ \"\$(echo \${1} | tr \\\'[A-Z]\\\' \\\'[a-z]\\\')\" = \"--autorename\" ]\nthen\n    cd NewerASM\n    if [ \! -d \"renamed\" ]; then mkdir renamed; fi\n    if [ -f \"renamed/DLCodeJP_1.bin\" ]; then rm renamed/DLCodeJP_1.bin; fi\n    if [ -f \"renamed/DLCodeJP_2.bin\" ]; then rm renamed/DLCodeJP_2.bin; fi\n    if [ -f \"renamed/DLRelocsJP_1.bin\" ]; then rm renamed/DLRelocsJP_1.bin; fi\n    if [ -f \"renamed/DLRelocsJP_2.bin\" ]; then rm renamed/DLRelocsJP_2.bin; fi\n    if [ -f \"renamed/SystemJP_1.bin\" ]; then rm renamed/SystemJP_1.bin; fi\n    if [ -f \"renamed/SystemJP_2.bin\" ]; then rm renamed/SystemJP_2.bin; fi\n    if [ -f \"renamed/DLCodeUS_1.bin\" ]; then rm renamed/DLCodeUS_1.bin; fi\n    if [ -f \"renamed/DLCodeUS_2.bin\" ]; then rm renamed/DLCodeUS_2.bin; fi\n    if [ -f \"renamed/DLRelocsUS_1.bin\" ]; then rm renamed/DLRelocsUS_1.bin; fi\n    if [ -f \"renamed/DLRelocsUS_2.bin\" ]; then rm renamed/DLRelocsUS_2.bin; fi\n    if [ -f \"renamed/SystemUS_1.bin\" ]; then rm renamed/SystemUS_1.bin; fi\n    if [ -f \"renamed/SystemUS_2.bin\" ]; then rm renamed/SystemUS_1.bin; fi\n    if [ -f \"renamed/DLCodeEU_1.bin\" ]; then rm renamed/DLCodeEU_1.bin; fi\n    if [ -f \"renamed/DLCodeEU_2.bin\" ]; then rm renamed/DLCodeEU_2.bin; fi\n    if [ -f \"renamed/DLRelocsEU_1.bin\" ]; then rm renamed/DLRelocsEU_1.bin; fi\n    if [ -f \"renamed/DLRelocsEU_2.bin\" ]; then rm renamed/DLRelocsEU_1.bin; fi\n    if [ -f \"renamed/SystemEU_1.bin\" ]; then rm renamed/SystemEU_1.bin; fi\n    if [ -f \"renamed/SystemEU_2.bin\" ]; then rm renamed/SystemEU_2.bin; fi\n\n    mv n_jpn_dlcode.bin renamed/DLCodeJP_1.bin\n    mv n_jpn2_dlcode.bin renamed/DLCodeJP_2.bin\n    mv n_jpn_dlrelocs.bin renamed/DLRelocsJP_1.bin\n    mv n_jpn2_dlrelocs.bin renamed/DLRelocsJP_2.bin\n    mv n_jpn_loader.bin renamed/SystemJP_1.bin\n    mv n_jpn2_loader.bin renamed/SystemJP_2.bin\n    mv n_ntsc_dlcode.bin renamed/DLCodeUS_1.bin\n    mv n_ntsc2_dlcode.bin renamed/DLCodeUS_2.bin\n    mv n_ntsc_dlrelocs.bin renamed/DLRelocsUS_1.bin\n    mv n_ntsc2_dlrelocs.bin renamed/DLRelocsUS_2.bin\n    mv n_ntsc_loader.bin renamed/SystemUS_1.bin\n    mv n_ntsc2_loader.bin renamed/SystemUS_2.bin\n    mv n_pal_dlcode.bin renamed/DLCodeEU_1.bin\n    mv n_pal2_dlcode.bin renamed/DLCodeEU_2.bin\n    mv n_pal_dlrelocs.bin renamed/DLRelocsEU_1.bin\n    mv n_pal2_dlrelocs.bin renamed/DLRelocsEU_2.bin\n    mv n_pal_loader.bin renamed/SystemEU_1.bin\n    mv n_pal2_loader.bin renamed/SystemEU_2.bin\nfi" ${TARGET_DIR_INSTALL}newersmbw_compile2.sh > ${TARGET_DIR_INSTALL}newersmbw_compile.sh
    rm ${TARGET_DIR_INSTALL}newersmbw_compile2.sh
    chmod +x ${TARGET_DIR_INSTALL}newersmbw_compile.sh
    clear
    echo "OK, the installation is finished. To compile NewerSMBW at any time,"
    echo "please type these commands in the Linux subsystem:"
    echo
    echo "    cd $TARGET_DIR_INSTALL"
    echo "    ./newersmbw_compile.sh"
    echo
    echo "Once you've typed those in, you should be able to compile NewerSMBW!"
    echo
    echo "P.S.: You can also do  './newersmbw_compile.sh --autorename'"
    echo "instead of  './newersmbw_compile.sh'  to auto-rename the"
    echo "kamek-compiled .BIN files to their NewerSMBW-readable"
    echo "names. The renamed files will be placed in"
    echo "$NEWER_SRC_DOWNLOAD_DIR/Kamek/NewerASM/renamed/"
    echo   
elif [ "$(expr substr $RESPONSE 1 1)" = "U" ] || [ "$(expr substr $RESPONSE 1 1)" = "u" ]
then
    echo "[1: REMOVE THE REQUIRED TOOLS (GCC/MAKE, CMAKE, PYYAML/PYELFTOOLS, AND SVN)]:"
    echo
    cd $TARGET_DIR_INSTALL
    apt-get purge -y gcc
    apt-get purge -y make
    apt-get purge -y cmake
    apt-get purge -y subversion
    pip uninstall -y pyelftools
    pip uninstall -y pyyaml
    apt-get purge -y python-pip


    clear
    echo "[2: REMOVE NEWERSMBW SOURCES]:"
    echo
    rm -r $NEWER_SRC_DOWNLOAD_DIR


    clear
    echo "[3: REMOVE DEVKITPPC REVISION 35]:"
    echo
    rm -r ${DEVKITPPC_DOWNLOAD_DIR}devkitPPC


    clear
    echo "[4: REMOVE NEWER-PATCHED LLVM, REVISION $LLVM_REVISION_SVN]:"
    echo
    rm -r $NEWER_PATCHED_LLVM_INSTALL_DIR


    clear
    echo "[5: FINISHING UNINSTALLATION]:"
    echo
    rm ${TARGET_DIR_INSTALL}newersmbw_compile.sh
    clear
    echo "OK, the uninstallation is finished."
    echo
fi
