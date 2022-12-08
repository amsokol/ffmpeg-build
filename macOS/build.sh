# echo '♻️ ' Create Ramdisk

if df | grep Ramdisk > /dev/null ; then tput bold ; echo ; echo ⏏ Eject Ramdisk ; tput sgr0 ; fi

if df | grep Ramdisk > /dev/null ; then diskutil eject Ramdisk ; sleep 1 ; fi

DISK_ID=$(hdid -nomount ram://70000000)

newfs_hfs -v tempdisk ${DISK_ID}

diskutil mount ${DISK_ID}

sleep 1

SOURCE="/Volumes/tempdisk/sw"

COMPILED="/Volumes/tempdisk/compile"

mkdir ${SOURCE}

mkdir ${COMPILED}

export PATH=${SOURCE}/bin:$PATH

export CC=clang && export PKG_CONFIG_PATH="${SOURCE}/lib/pkgconfig"

echo '♻️ ' Start compiling FFMPEG

cd ${COMPILED}

cd ffmpeg

export LDFLAGS="-L${SOURCE}/lib"

export CFLAGS="-I${SOURCE}/include"

export LDFLAGS="$LDFLAGS -framework VideoToolbox"

./configure --prefix=${SOURCE} --extra-cflags="-fno-stack-check" --arch=arm64 --cc=/usr/bin/clang \
#./configure --prefix=${SRC} --extra-cflags="-fno-stack-check" --arch=x86_64 --cc=/usr/bin/clang \
--enable-gpl \
--enable-version3 \
--pkg-config-flags=--static \
--disable-ffplay \
--enable-postproc \
--enable-nonfree \
--enable-neon \
--enable-runtime-cpudetect \
--disable-indev=qtkit \
--disable-indev=x11grab_xcb

make -j 10

make install
