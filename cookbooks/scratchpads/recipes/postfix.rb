#
# Cookbook Name:: scratchpads
# Recipe:: postfix
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Only include the postfix recipe IF we are the control server
if node['roles'].index(node['scratchpads']['control']['role']) then
  begin
    Dir.foreach('/var/aegir/platforms/*/sites/*') do |domain|
      default['postfix']['virtual_aliases']["@#{domain}"] = 'aegir'
      default['postfix']['virtual_aliases_domains'][domain] = domain
    end
  rescue
    Chef::Log.info('Not adding any domains to postfix configuration.')
  end
  include_recipe 'postfix::server'
  include_recipe 'postfix::virtual_aliases'
  include_recipe 'postfix::virtual_aliases_domains'
  template default['scratchpads']['postfix']['deliver_mail_to_aegir_template']['source'] do
    path default['scratchpads']['postfix']['deliver_mail_to_aegir_template']['path']
    source name
    cookbook default['scratchpads']['postfix']['deliver_mail_to_aegir_template']['cookbook']
    owner default['scratchpads']['postfix']['deliver_mail_to_aegir_template']['owner']
    group default['scratchpads']['postfix']['deliver_mail_to_aegir_template']['group']
    mode default['scratchpads']['postfix']['deliver_mail_to_aegir_template']['mode']
    action :create
  end
else
  include_recipe 'postfix::client'
end