#
# Cookbook Name:: hadoop
# Recipe::        tasktracker
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "hadoop_cluster"

# Install
hadoop_package node[:hadoop][:packages][:tasktracker][:name]

if is_hadoop_yarn? then
# Fix CDH4b1 bug: 'service stop hadoop-yarn-*' should wait for SLEEP_TIME before return
%w[hadoop-yarn-nodemanager].each do |service_file|
  template "/etc/init.d/#{service_file}" do
    owner "root"
    group "root"
    mode  "0755"
    source "#{service_file}.erb"
  end
end
end

# Launch
service "#{node[:hadoop][:tasktracker_service_name]}" do
  action [ :enable, :restart ]
  running true
  supports :status => true, :restart => true
end
