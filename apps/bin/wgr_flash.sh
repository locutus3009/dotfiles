#!/usr/bin/env bash

export T=kirin9000ohwgr
cd /home/locutus/dev/hm-grc-scripts
scp locutus@workstation:/home/locutus/dev/hm-grc-scripts/hm-yocto/ng/build/tmp/deploy/images/bootimage-kirin9000ohwgr/Image /home/locutus/dev/hm-grc-scripts/hm-yocto/ng/build/tmp/deploy/images/bootimage-kirin9000ohwgr/Image
./scripts/wgr.run --bootimage
