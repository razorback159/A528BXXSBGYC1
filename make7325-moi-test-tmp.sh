#!/bin/bash

DEFAULT_DEVICE_DIRECTORY="$CROWN_KERNEL_DIRECTORY"

# Kernel Source Paths
CROWN_KERNEL_DIRECTORY=/home/moi/A528BXXSBGYC1/

TOOLCHAINS_DIRECTORY=/home/moi/aarch64-linux-android-4.9-043

TOOLCHAINS_DIRECTORY2=/home/moi/clang-r383902b1


AIK_N960=/home/moi/AnyKernel3

ZIP_MOVE="/home/moi/Zip"
ZIP_N960=/home/moi/MCK-A52S/
PERM_CROWNIMG_DIR="/home/moi/A528BXXSBGYC1/N960"


# Password for AIK sudo
PASSWORD="moi"


## Kernel Directory

	cd "$CROWN_KERNEL_DIRECTORY" || exit

#cp Makefile.moi2 Makefile

export ARCH=arm64
export SUBARCH=arm64
export HEADER_ARCH=arm64
export PROJECT_NAME=a52sxq
export PATH=/usr/local/bin/ccache:$PATH

	export BUILD_CROSS_COMPILE=$TOOLCHAINS_DIRECTORY"/bin/aarch64-linux-android-"


	export PATH=$TOOLCHAINS_DIRECTORY2"/bin:$PATH"
	export PLATFORM_VERSION=12
	export ANDROID_MAJOR_VERSION=12
	export CONFIG_SECTION_MISMATCH_WARN_ONLY=y
	export CROSS_COMPILE_ARM32=$TOOLCHAINS_DIRECTORY"/bin/aarch64-linux-android-"
	export CC=$TOOLCHAINS_DIRECTORY2"/bin/clang"
	export AR=$TOOLCHAINS_DIRECTORY2"/bin/llvm-ar"
	export NM=$TOOLCHAINS_DIRECTORY2"/bin/llvm-nm"
	export OBJCOPY=$TOOLCHAINS_DIRECTORY2"/bin/llvm-objcopy"
	export OBJDUMP=$TOOLCHAINS_DIRECTORY2"/bin/llvm-objdump"
	export STRIP=$TOOLCHAINS_DIRECTORY2"/bin/llvm-strip"
	export KERNEL_LLVM_BIN=$TOOLCHAINS_DIRECTORY2"/bin/clang"
	export REAL_CC="/usr/local/bin/ccache "$KERNEL_LLVM_BIN
	export CLANG_TRIPLE="aarch64-linux-gnu-"
	CCACHE_EXEC=/usr/local/bin/ccache
	$_CCACHE_EXEC -M 8G
	LLVM_CCACHE_BUILD=ON
	CCACHE_CPP2=yes
	export USE_CCACHE=1
	mkdir -p "$TOOLCHAINS_DIRECTORY"/bin/ccache/bin/


clear

while read -p "clean ?(y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
# modif démarrage kernel origine

#		rm -R out
		cd $(pwd)/out
		make -j64 -C $(pwd)  clean
		make -j64 -C $(pwd) M=$(PWD) clean
		make -j64 -C $(pwd)  mrproper
		echo
		echo "cleaned."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

DATE_START=$(date +"%s")


while read -p "Build LLD ?(y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
	
mkdir out						

#sed -i -e 's/#define THERMAL_MAX_TRIPS	12/#define THERMAL_MAX_TRIPS	16/g' "/home/moi/A528BXXSBGYC1/include/linux/thermal.h"


#	KERNEL_MAKE_ENV="CONFIG_BUILD_ARM64_DT_OVERLAY=y"
#		export ARCH=arm64
		set -e
		set -o pipefail

#	 PATH=/usr/local/bin/ccache:${PATH}
#	 make -j$(nproc --all) -C $(pwd) O=$(pwd)/out  PROJECT_NAME=a52sxq CONFIG_SEC_A52SXQ_PROJECT=y $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC='ccache '$KERNEL_LLVM_BIN HOSTCC="ccache clang" AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip LLVM=1 vendor/moi_a52sxq_eur_open_defconfig-tmp

#	make -j$(nproc --all) -C $(pwd) O=$(pwd)/out PROJECT_NAME=a52sxq CONFIG_SEC_A52SXQ_PROJECT=y $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC='ccache '$KERNEL_LLVM_BIN HOSTCC="ccache clang" AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip LLVM=1
		
		export ARCH=arm64
		export LLVM=1
		export CLANG_PREBUILT_BIN=$KERNEL_LLVM_BIN
		export PATH=$PATH:$CLANG_PREBUILT_BIN:/usr/local/bin/ccache
#		KERNEL_LLVM_BIN=/root/Desktop/clang/bin/clang
		CLANG_TRIPLE=aarch64-linux-gnu-
		KERNEL_MAKE_ENV="CONFIG_BUILD_ARM64_DT_OVERLAY=y"



	 make -j8 -C $(pwd) O=$(pwd)/out DTC_EXT=$(pwd)/tools/dtc $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC='ccache '$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y vendor/a52sxq_eur_open_defconfig

		make -j8 -C $(pwd) O=$(pwd)/out DTC_EXT=$(pwd)/tools/dtc $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC='ccache '$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y
#		make -j8 -C $(pwd) O=$(pwd)/out DTC_EXT=$(pwd)/tools/dtc $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC='ccache '$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y techpack/
		make -j8 -C $(pwd) O=$(pwd)/out DTC_EXT=$(pwd)/tools/dtc $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC='ccache '$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y modules_install INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=kernel_modules
		

		set +e
		set +o pipefail
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done



while read -p "create zip mkbootimg ?(y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
	RAMFS_TMP=../mkbootimg-dir2
	rm "$RAMFS_TMP"/mesa.zip
		rm "$RAMFS_TMP"/zip/mesa/eur/dtbo.img
		rm "$RAMFS_TMP"/zip/mesa/eur/boot.img
		cp "$CROWN_KERNEL_DIRECTORY"out/arch/arm64/boot/Image "$RAMFS_TMP"/Image
#		cp "$CROWN_KERNEL_DIRECTORY"out/arch/arm64/boot/dtbo.img "$RAMFS_TMP"/zip/mesa/eur/dtbo.img
		rm "$RAMFS_TMP"/zip/vendor/lib/modules/*.ko
		cp $(find ./out/kernel_modules/lib/modules/*/kernel/* -name '*.ko') "$RAMFS_TMP"/zip/vendor/lib/modules
		find "$RAMFS_TMP"/zip/vendor/lib/modules -type f -name "*.ko" -print0 | xargs -0 -n1 "${BUILD_CROSS_COMPILE}strip" --strip-unneeded
		cp ./out/kernel_modules/lib/modules/*/modules.{alias,dep,softdep} "$RAMFS_TMP"/zip/vendor/lib/modules
		cp ./out/kernel_modules/lib/modules/*/modules.order "$RAMFS_TMP"/zip/vendor/lib/modules/modules.load
		sed -i 's/\(kernel\/[^: ]*\/\)\([^: ]*\.ko\)/\/vendor\/lib\/modules\/\2/g' "$RAMFS_TMP"/zip/vendor/lib/modules/modules.dep
		sed -i 's/.*\///g' "$RAMFS_TMP"/zip/vendor/lib/modules/modules.load

python3 /home/moi/android_system_tools_mkbootimg/mkbootimg.py \
    --kernel "$RAMFS_TMP"/Image \
    --ramdisk "$RAMFS_TMP"/boot.img-ramdisk.cpio.gz \
    --cmdline 'console=null androidboot.hardware=qcom androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=0 loop.max_part=7 cgroup.memory=nokmem,nosocket firmware_class.path=/vendor/firmware_mnt/image pcie_ports=compat loop.max_part=7 iptable_raw.raw_before_defrag=1 ip6table_raw.raw_before_defrag=1 printk.devkmsg=on' \
    --dtb "$RAMFS_TMP"/dtb \
    --base           0x00000000 \
    --pagesize       4096 \
    --kernel_offset  0x00008000 \
    --ramdisk_offset 0x02000000 \
    --tags_offset    0x01e00000 \
    --os_version     '11.0.0'\
    --os_patch_level '2025-06-00' \
    --header_version '3' \
    --dtb_offset      0x01f00000 \
    -o "$RAMFS_TMP"/boot.img		
	


		cp "$RAMFS_TMP"/boot.img "$RAMFS_TMP"/zip/mesa/eur/boot.img
		cd "$RAMFS_TMP"/zip || exit
		echo "$PASSWORD" | zip -r9 ../mesa.zip * 
		cd "$CROWN_KERNEL_DIRECTORY"
		cp "$RAMFS_TMP"/mesa.zip "$ZIP_N960"TEST_SBGYF1_KSU-moi-mod12.zip



		echo
		echo "created."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done












