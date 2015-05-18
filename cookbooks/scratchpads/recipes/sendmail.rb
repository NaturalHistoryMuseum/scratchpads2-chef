#
# Cookbook Name:: scratchpads
# Recipe:: sendmail
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
apt_package "sendmail" do
  action :install
end
