if platform? %w{centos redhat}
  include_recipe 'yum::epel'
  package 'gkrellm-daemon'
elsif platform? %w{ubuntu debian}
  package 'gkrellmd'
else
  package 'gkrellm-daemon'
end

template "/etc/gkrellmd.conf" do
  source 'gkrellmd.conf.erb'
  user   'root'
  group  'root'

  variables(
    :port          => node['gkrellmd']['port'],
    :allowed_hosts => node['gkrellmd']['allowed_hosts']
  )
end

service 'gkrellmd' do
  action [:enable, :start]
end
