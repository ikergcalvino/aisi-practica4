# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative 'provisioning/vbox.rb'
VBoxUtils.check_version('7.0.6')
Vagrant.require_version ">= 2.3.4"

class VagrantPlugins::ProviderVirtualBox::Action::Network
  def dhcp_server_matches_config?(dhcp_server, config)
    true
  end
end

# Hostnames for master and worker nodes
MASTER_HOSTNAME = "idc-aisi2223-k8s-master"
WORKER_HOSTNAME = "idc-aisi2223-k8s-worker"

# Cluster settings
MASTER_IP = "192.168.56.10"
MASTER_CORES = 1
NUM_WORKERS = 2
WORKER_CORES = 1
MASTER_MEMORY = 2048
WORKER_MEMORY = 1024
POD_NETWORK = "10.10.1.0/24"

require 'ipaddr'
CLUSTER_IP_ADDR = IPAddr.new MASTER_IP
CLUSTER_IP_ADDR = CLUSTER_IP_ADDR.succ

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.box_version = "20230110.0.0"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  # Configure hostmanager and vbguest plugins
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.vbguest.auto_update = false
  
  # Master node
  config.vm.define "master", primary: true do |master|
    master.vm.hostname = MASTER_HOSTNAME
    master.vm.network "private_network", ip: MASTER_IP
    
    master.vm.provider "virtualbox" do |prov|
	prov.name = "AISI-P4-#{master.vm.hostname}"
        prov.cpus = MASTER_CORES
        prov.memory = MASTER_MEMORY
	prov.gui = false
    end
    
    # Install and setup K8s using ansible
    master.vm.provision "ansible_local", run: "once" do |ansible|
	ansible.install = "true"
	ansible.install_mode = "pip3"
	ansible.playbook = "provisioning/playbook-main.yml"
        ansible.inventory_path = "ansible.inventory"
        ansible.limit = "all"
	ansible.extra_vars = {
                master_ip: MASTER_IP,
                master_hostname: MASTER_HOSTNAME,
                pod_network: POD_NETWORK,
            }
    end
  end
  
  # Worker nodes
  (1..NUM_WORKERS).each do |i|
    config.vm.define "worker-#{i}" do |worker|
	worker.vm.hostname = "#{WORKER_HOSTNAME}-#{i}"
	IP_ADDR = CLUSTER_IP_ADDR.to_s
        CLUSTER_IP_ADDR = CLUSTER_IP_ADDR.succ
        worker.vm.network "private_network", ip: IP_ADDR
        
        worker.vm.provider "virtualbox" do |prov|
	    prov.name = "AISI-P4-#{worker.vm.hostname}"
            prov.cpus = WORKER_CORES
            prov.memory = WORKER_MEMORY
	    prov.gui = false
        end
    end
  end
  
  # Global provisioning bash script
  config.vm.provision "shell", run: "once", path: "provisioning/bootstrap.sh"
end
