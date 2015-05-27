#
# Cookbook Name:: scratchpads
# Recipe:: postfix
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Only include the postfix recipe IF we are the control server
if node["roles"]["control"] then
  template "/usr/local/bin/all-aegir-domains" do
    path "/usr/local/bin/all-aegir-domains"
    source 'all-aegir-domains.erb'
    cookbook 'scratchpads'
    owner "root"
    group "root"
    mode '0755'
    action :create
  end
  domains = `/usr/local/bin/all-aegir-domains`
  domains.each_line do|line|
    default['postfix']['virtual_aliases_domains'][line] = line
    default['postfix']['virtual_aliases']["@#{line}"] = "aegir"
  end
  include_recipe 'postfix::server'
  include_recipe 'postfix::aliases'
  include_recipe 'postfix::virtual_aliases'
else
  include_recipe 'postfix::client'
end