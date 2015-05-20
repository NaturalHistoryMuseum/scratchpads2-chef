#
# Cookbook Name:: scratchpads
# Recipe:: app
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Mount the folder from the control server
include_recipe 'nfs'
if Chef::Config[:solo]
  control_hosts = {"sp-control-1" => {"fqdn" => "sp-control-1"}}
else
  control_hosts = search(:node, "role:control")
end
control_host = control_hosts.first
mount "/var/aegir/platforms" do
  device "#{control_host['fqdn']}:/var/aegir/platforms"
  fstype "nfs"
  options "rw,bg,ac,noatime"
  action [:mount, :enable]
end
