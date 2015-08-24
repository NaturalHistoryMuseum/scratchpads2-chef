#
# Cookbook Name:: mmonit
# Recipe:: default
#
# Copyright (C) Lodgem Inc.
#

src_filepath = "#{Chef::Config['file_cache_path']}/#{node['mmonit']['source']['filename']}"

remote_file src_filepath do
  source node["mmonit"]["source"]["url"]
  owner "root"
  group "root"
  mode 00644
  not_if {: :File.exists?(src_filepath) }
end

bash "extract_source" do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    mkdir -p #{node['mmonit']['dir']}
    tar xzf #{node['mmonit']['source']['filename']} -C #{node['mmonit']['dir']}
    mv #{node['mmonit']['dir']}/*/* #{node['mmonit']['dir']}/
    EOH
  not_if { ::File.exists?(node["mmonit"]["dir"]) }
end

template "#{node['mmonit']['dir']}/conf/server.xml" do
  source "server.xml.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, "service[mmonit]"
end

template "mmonit service script" do
  case node['platform']
  when 'debian'
    path "/etc/systemd/system/mmonit.service"
    source "mmonit-systemd.erb"
  when 'ubuntu'
    path "/etc/init/mmonit.conf"
    source "mmonit-upstart.conf.erb"
  end
  owner  "root"
  group  "root"
  mode   "0644"
end

service "mmonit" do
  case node['mmonit']['init_style']
  when 'systemd'
    provider Chef::Provider::Service::Systemd
  when 'upstart'
    provider Chef::Provider::Service::Upstart
  end
  action [:enable, :start]
end