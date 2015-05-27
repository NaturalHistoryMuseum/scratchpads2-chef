#
# Cookbook Name:: scratchpads
# Recipe:: monit
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Install "basic" monit on each server
include_recipe 'monit-ng::source'
include_recipe 'monit-ng::config'
# Install Mmonit on the control server
if node["roles"].index("control") then
  include_recipe "mmonit"
end