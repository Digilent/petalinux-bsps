#!/bin/sh
### BEGIN INIT INFO
# Provides:          consoleblank.sh
# Required-Start:
# Required-Stop:
# Default-Start:     S
# Default-Stop:
# Short-Description: disable console blank
# Description:       set consoleblank to 0 on tty1
### END INIT INFO

cur_cb=$(cat /sys/module/kernel/parameters/consoleblank)

if [ $cur_cb -ne 0 ]; then
	echo "Disable console blank"
	for i in {0..9}; do
		echo -e '\033[9;0]' > /dev/tty1
		cb_chk=$(cat /sys/module/kernel/parameters/consoleblank)
		if [ $cb_chk -eq 0 ]; then
			exit 0
		fi
	done
fi

if [ $cb_chk -ne 0 ]; then
	echo "Error: fail to disable console blank"
fi
