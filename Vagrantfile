# Configure Vagrant:
Vagrant.configure("2") do |config|
  # If we're using VirtualBox, to improve performance let's try to
  # make sure we assign the VM an appropriate amount RAM:
  # cf. http://www.stefanwrobel.com/how-to-make-vagrant-performance-not-suck
  host = RbConfig::CONFIG['host_os']

  config.vm.provider "virtualbox" do |v|
    # Give VM 1/4 system memory:
    # meminfo on Linux returns kB; Windows and MacOS return bytes
    if host =~ /darwin/
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    elsif host =~ /mswin|mingw|cygwin/
      mem = `wmic computersystem Get TotalPhysicalMemory`.split[1].to_i / 1024 / 1024 / 4
    end

    v.customize ["modifyvm", :id, "--memory", mem]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # The geerlingguy Ubuntu box seems generally more reliable
  # than the official one:
  config.vm.box = "geerlingguy/ubuntu1604"

  # Forward guest port 80 to host port 8080
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", type: "dhcp"

  # Set the synced folder:
  if host =~ /mswin|mingw|cygwin/
    config.vm.synced_folder ".", "/vagrant",
      owner: "www-data",
      group: "www-data"
  else
    config.vm.synced_folder ".", "/vagrant",
      owner: "www-data",
      group: "www-data",
      nfs: true
  end

  # Provision the Vagrant VM:
  # (Vagrant will install Ansible if necessary)
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/playbook.yml"
    ansible.compatibility_mode = "2.0"
  end

  # Restore a DB backup:
  config.vm.provision "db_restore", type: "shell", run: "once" do |shell|
    shell.path = "ansible/scripts/db_restore.sh"
  end

  config.vm.provision "shell", privileged: false, inline: <<-EOF
    echo "Vagrant Box provisioned!"
    echo "Now install Craft at http://localhost:8080/admin/install"
  EOF
end
