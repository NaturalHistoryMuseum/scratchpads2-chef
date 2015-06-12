#
# Cookbook Name:: scratchpads
# Recipe:: monit
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Install 'basic' monit on each server
include_recipe 'monit-ng::source'
include_recipe 'monit-ng::config'
# Install Mmonit on the control server
if node['roles'].index(node['scratchpads']['control']['role']) then
  mmonit = ScratchpadsEncryptedData.new(node, 'mmonit')
  node.default['mmonit']['license_owner'] = mmonit.get_encrypted_data 'mmonit', 'license_owner'
  node.default['mmonit']['license'] = mmonit.get_encrypted_data 'mmonit', 'license'
  include_recipe 'mmonit'
end
