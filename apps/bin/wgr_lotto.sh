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
hdc shell "/data/lotto stress -r 10 --temporary-directory /data/tmp --output-trace /data/tmp/lotto.trace -- vm.elf --plugin /data/lotto --bindcore 0 -v 4 -b /data/mp.img -n 0 --bootaddr 0"
