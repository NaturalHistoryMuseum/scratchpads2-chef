#
# Cookbook Name:: scratchpads
# Recipe:: postfix
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Only include the postfix recipe IF we are the control server
if node.automatic.roles.index("control") then
  include_recipe 'postfix::server'
else
  include_recipe 'postfix::client'
end