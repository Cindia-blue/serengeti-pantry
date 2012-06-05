#
# Cookbook Name:: hadoop
# Recipe:: jobtracker
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
hadoop_package node[:hadoop][:packages][:jobtracker][:name]

# Register with cluster_service_discovery
provide_service ("#{node[:cluster_name]}-#{node[:hadoop][:jobtracker_service_name]}")
# Regenerate Hadoop xml conf files with new Hadoop server address
node.run_state[:seen_recipes].delete("hadoop_cluster::hadoop_conf_xml") # check http://tickets.opscode.com/browse/CHEF-1406
include_recipe "hadoop_cluster::hadoop_conf_xml"

# Launch service
set_bootstrap_action(ACTION_START_SERVICE, node[:hadoop][:jobtracker_service_name])
service "#{node[:hadoop][:jobtracker_service_name]}" do
  action [ :enable, :restart ]
  running true
  supports :status => true, :restart => true
end
