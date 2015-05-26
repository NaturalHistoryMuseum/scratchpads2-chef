#
# Cookbook Name:: scratchpads
# Recipe:: postfix
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Only include the postfix recipe IF we are the control server
if node.automatic.roles.index("control") then
  template "/usr/local/bin/all-aegir-domains" do
    path "/usr/local/bin/all-aegir-domains"
    source 'all-aegir-domains.erb'
    cookbook 'scratchpads'
    owner "root"
    group "root"
    mode '0755'
    action :create
  end
  include_recipe 'postfix::server'
else
  include_recipe 'postfix::client'
end