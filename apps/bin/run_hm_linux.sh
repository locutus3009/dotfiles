#!/usr/bin/env bash

export T=virt-hyp
export E=dev
export VM_IMAGE=/home/locutus/dev/hm-grc-scripts/files/guest_virt.img
export IMAGE_ROOTFS_MANIFEST=/home/locutus/dev/lotto//src/hm-lotto/lotto.manifest
export UVMM_VM_IMAGE=/home/locutus/dev/hm-grc-scripts/hm-uvmm/tests/build/guest/guestpayload.img
export SDK_VM_IMAGE=/home/locutus/dev/hm-grc-scripts/SDK/sysroots/x86_64-eulersdk-linux/../../sysroots/aarch64-euler-elf/usr/bin/guestpayload.img
./scripts/run-hm.sh
