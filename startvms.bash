#!/bin/bash
for UUID in $(VBoxManage list vms | grep '^"chef-repo' | sed -r "s/.*\{([^\}]*)\}/\1/")
do
	VBoxManage startvm --type headless $UUID
done
