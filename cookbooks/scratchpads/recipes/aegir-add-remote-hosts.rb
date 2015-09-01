#
# Cookbook Name:: scratchpads
# Recipe:: aegir-add-remote-hosts
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Create Application servers for each application server we know about and that
# has not already been created.
app_hosts = []
unless Chef::Config[:solo]
  app_hosts_search = search(:node, "roles:#{node['scratchpads']['app']['role']} AND chef_environment:#{node.chef_environment}")
  app_hosts_search.each do|app_host|
    app_hosts << app_host['fqdn']
  end
end
app_hosts.each do|app_host|
  sanitised_server_name = app_host.gsub(/[^a-z0-9]/, '')
  Chef::Log.info("'#{app_host}' sanitised to '#{sanitised_server_name}'")
  # Create the server
  execute "create the #{sanitised_server_name} application server node" do
    command "#{node['scratchpads']['control']['drush_command']} @hm provision-save server_#{sanitised_server_name} --context_type=server --remote_host=#{app_host} --http_service_type='apache' --http_port=80"
    cwd node['scratchpads']['aegir']['home_folder']
    group node['scratchpads']['aegir']['group']
    user node['scratchpads']['aegir']['user']
    environment node['scratchpads']['aegir']['environment']
    not_if{::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/server_#{sanitised_server_name}.alias.drushrc.php")}
    notifies :run, "execute[verify the #{sanitised_server_name} application server node]", :immediately
  end
  # Verify the server
  execute "verify the #{sanitised_server_name} application server node" do
    action :nothing
    command "#{node['scratchpads']['control']['drush_command']} @server_#{sanitised_server_name} provision-verify"
    cwd node['scratchpads']['aegir']['home_folder']
    group node['scratchpads']['aegir']['group']
    user node['scratchpads']['aegir']['user']
    environment node['scratchpads']['aegir']['environment']
    notifies :run, "execute[import the #{sanitised_server_name} application server into front end]", :immediately
  end
  #drush @hm hosting-import @server_spapp1nhmacuk
  # Import the server into the front end
  execute "import the #{sanitised_server_name} application server into front end" do
    action :nothing
    command "#{node['scratchpads']['control']['drush_command']} @hm hosting-import @server_#{sanitised_server_name}"
    cwd node['scratchpads']['aegir']['home_folder']
    group node['scratchpads']['aegir']['group']
    user node['scratchpads']['aegir']['user']
    environment node['scratchpads']['aegir']['environment']
  end
end

# Create database servers for each database server we know about and that
# has not already been created.
data_hosts = []
unless Chef::Config[:solo]
  data_hosts_search = search(:node, "roles:#{node['scratchpads']['data']['role']} AND chef_environment:#{node.chef_environment}")
  data_hosts_search.each do|data_host|
    data_hosts << data_host['fqdn']
  end
end
data_hosts.each do|data_host|
  sanitised_server_name = data_host.gsub(/[^a-z0-9]/, '')
  Chef::Log.info("'#{data_host}' sanitised to '#{sanitised_server_name}'")
  # Create the server
  passwords = ScratchpadsEncryptedData.new(node)
  aegir_pw = passwords.get_encrypted_data 'mysql', 'aegir'
  execute "create the #{sanitised_server_name} database server node" do
    command "#{node['scratchpads']['control']['drush_command']} @hm provision-save server_#{sanitised_server_name} --context_type=server --remote_host=#{data_host} --db_service_type='mysql' --master_db='mysql://aegir:#{aegir_pw}@#{data_host}'"
    cwd node['scratchpads']['aegir']['home_folder']
    group node['scratchpads']['aegir']['group']
    user node['scratchpads']['aegir']['user']
    environment node['scratchpads']['aegir']['environment']
    not_if{::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/server_#{sanitised_server_name}.alias.drushrc.php")}
    notifies :run, "execute[verify the #{sanitised_server_name} database server node]", :immediately
  end
  # Verify the server
  execute "verify the #{sanitised_server_name} database server node" do
    action :nothing
    command "#{node['scratchpads']['control']['drush_command']} @server_#{sanitised_server_name} provision-verify"
    cwd node['scratchpads']['aegir']['home_folder']
    group node['scratchpads']['aegir']['group']
    user node['scratchpads']['aegir']['user']
    environment node['scratchpads']['aegir']['environment']
    notifies :run, "execute[import the #{sanitised_server_name} database server into front end]", :immediately
  end
  # Import the server into the front end
  execute "import the #{sanitised_server_name} database server into front end" do
    action :nothing
    command "#{node['scratchpads']['control']['drush_command']} @hm hosting-import @server_#{sanitised_server_name}"
    cwd node['scratchpads']['aegir']['home_folder']
    group node['scratchpads']['aegir']['group']
    user node['scratchpads']['aegir']['user']
    environment node['scratchpads']['aegir']['environment']
  end
end