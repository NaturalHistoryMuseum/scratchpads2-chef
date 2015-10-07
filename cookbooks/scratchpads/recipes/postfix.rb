#
# Cookbook Name:: scratchpads
# Recipe:: postfix
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Only include the postfix recipe IF we are the control server
if node['roles'].index(node['scratchpads']['control']['role']) then
  # Always receive for quartz.nhm.ac.uk (add any others we require here).
  node.default['postfix']['virtual_aliases']['@quartz.nhm.ac.uk'] = 'aegir'
  node.default['postfix']['virtual_aliases_domains']['quartz.nhm.ac.uk'] = 'quartz.nhm.ac.uk'
  begin
    Dir.foreach('/var/aegir/platforms') do |platform|
      if File.exists?("/var/aegir/platforms/#{platform}/sites")
        Dir.foreach("/var/aegir/platforms/#{platform}/sites") do |site|
          if File.exists?("/var/aegir/platforms/#{platform}/sites/#{site}/settings.php")
            node.default['postfix']['virtual_aliases']["@#{site}"] = 'aegir'
            node.default['postfix']['virtual_aliases_domains'][site] = site
          end
        end
      end
    end
  rescue
    Chef::Log.info('Not adding any domains to postfix configuration.')
  end
  include_recipe 'postfix::server'
  include_recipe 'postfix::virtual_aliases'
  include_recipe 'postfix::virtual_aliases_domains'
else
  include_recipe 'postfix::client'
end