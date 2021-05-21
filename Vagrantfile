# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

	NodeCount = 4
	
	(1..NodeCount).each do |i|
		config.vm.define "webserver#{i}" do |node|
			node.vm.box = "bento/ubuntu-20.04"
			node.vm.hostname = "webserver#{i}"
			node.vm.network "private_network", ip: "192.168.100.10#{i}"
			node.vm.provision :shell, path: "webserver.sh", :args => "#{i}"
			node.vm.provider "virtualbox" do |v|
				v.name = "webserver#{i}"
			end
		end
	end

	config.vm.define "haproxyserver" do |node|
		node.vm.box = "bento/ubuntu-20.04"
		node.vm.hostname = "haproxyserver"
		node.vm.network "private_network", ip: "192.168.100.105"
		node.vm.provision :shell, path: "haproxy.sh"
			node.vm.provider "virtualbox" do |v|
                                v.name = "haproxyserver"
                        end
	end
end
