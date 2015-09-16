#
# Cookbook Name:: scratchpads
# Recipe:: phantomjs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Install package required by cite.scratchpads.eu/phantomjs
package ['libimage-exiftool-perl']

unless(::File.exists?(node['scratchpads']['phantomjs']['download']['destination']))
  # Download phantomjs
  remote_file node['scratchpads']['phantomjs']['download']['destination'] do
    source node['scratchpads']['phantomjs']['download']['source']
    owner node['scratchpads']['phantomjs']['download']['owner']
    group node['scratchpads']['phantomjs']['download']['group']
    mode node['scratchpads']['phantomjs']['download']['mode']
    action node['scratchpads']['phantomjs']['download']['action']
  end
  # Extract the tar.bz2 file
  execute 'extract phantomjs' do
    command "tar xfj #{node['scratchpads']['phantomjs']['download']['destination']}"
    cwd File.dirname(node['scratchpads']['phantomjs']['download']['destination'])
    group node['scratchpads']['phantomjs']['download']['group']
    user node['scratchpads']['phantomjs']['download']['owner']
  end
  # Move the binary to the /usr/local/bin/ folder
  execute 'move phantomjs binary' do
    command 'mv /var/chef/phantomjs-1.9.2-linux-x86_64/bin/phantomjs /usr/local/bin'
    group node['scratchpads']['phantomjs']['download']['group']
    user node['scratchpads']['phantomjs']['download']['owner']
  end
end