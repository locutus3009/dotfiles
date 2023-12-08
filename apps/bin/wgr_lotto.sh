#!/usr/bin/env bash

cd /home/locutus/dev/lotto
pid=$(hdc shell "pgrep vm0")
if [ $? -eq 0 ]; then
  hdc shell "kill $pid"
  echo "Existing VM process killed successfully"
else
  echo "VM process not found"
fi

hdc shell "rm -rf /data/tmp && mkdir /data/tmp"
hdc shell "rm /data/lotto"
hdc shell "rm /data/mp.img"
hdc file send build/lotto /data/lotto
hdc file send build/test/integration/mp.img /data/mp.img
hdc shell "chmod +x /data/lotto"
hdc shell "export LOTTO_SEED=123 && export LOTTO_STRATEGY=random && vm.elf --plugin /data/lotto --bindcore 0 -v 4 --vgic-addr=0x7FFF000000 -k /data/mp.img -n 0"
