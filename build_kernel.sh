#!/usr/bin/env bash
# Copyright ©2021 - 2022 XSans02
# Docker Kernel Build Script

# Installing some dep
sudo apt-get install cpio libtinfo5

git clone --depth=1 https://github.com/kdrag0n/proton-clang clang
 
# Setup Environtment
KERNEL_DIR=$PWD
DEVICE=a71
DEFCONFIG="$DEVICE"_defconfig
export ARCH="arm64"
export SUBARCH="arm64"
export KBUILD_BUILD_USER="Geekmaster21"
export KBUILD_BUILD_HOST="OVH"
CLANG_DIR="$KERNEL_DIR/clang"
export PATH="$KERNEL_DIR/clang/bin:$PATH"
export KBUILD_COMPILER_STRING="$("$CLANG_DIR"/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"


make O=out ARCH=arm64 "$DEFCONFIG"

make O=out  ARCH=arm64 KERNEL_MAKE_ENV="DTC_EXT=/workspace/cafa12/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y" \
            SUBARCH=arm64 \
            LD_LIBRARY_PATH="${CLANG_DIR}/lib:${LD_LIBRARY_PATH}" \
            CC=clang \
            AR=llvm-ar \
            NM=llvm-nm \
            OBJCOPY=llvm-objcopy \
            OBJDUMP=llvm-objdump \
            STRIP=llvm-strip \
            LD=ld.lld \
            CLANG_TRIPLE=aarch64-linux-gnu- \
            CROSS_COMPILE=aarch64-linux-gnu- \
            CROSS_COMPILE_ARM32=arm-linux-gnueabi-
