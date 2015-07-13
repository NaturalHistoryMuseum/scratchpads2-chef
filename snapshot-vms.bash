#!/bin/bash
DATETIME=`date +"%F_%R"`
for UUID in $(VBoxManage list vms | grep '^"chef-repo' | sed -r "s/.*\{([^\}]*)\}/\1/")
do
	VBoxManage snapshot $UUID take snapshot-$DATETIME --live
done
