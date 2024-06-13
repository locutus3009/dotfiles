#!/usr/bin/env bash

cd /home/locutus/dev/lotto
tput reset
hdc shell "dmesg -C && dmesg -w | grep vm0"
