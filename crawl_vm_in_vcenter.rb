require 'rbvmomi'

user = "username"
password = "password"

# array that is a vcenter => [datacenter(s)] mapping
vcenter_array = {
  "vcenter1.example.com" => ["datacenter name"],
  "vcenter2.example.com" => ["datacenter name2", "datacenter name3"],
}

# recurse all folders
def recurse_for_vms(folder)
  folder.childEntity.each do |x|
    if x.class == RbVmomi::VIM::VirtualMachine
      # line that will print machine information - can be changed as needed
      puts "#{x.name} - #{x.guest.guestId} - #{x.guest.ipAddress} - #{x.guest.guestState} - #{x.guest.guestFamily}"
    elsif x.class == RbVmomi::VIM::Folder
      recurse_for_vms(x)
    end
  end
end

vcenter_array.each do |key,value|
  puts "==========vcenter is: #{key}================="
  value.each do |datacenter|
    puts "========datacetner is: #{datacenter}================"
    vim = RbVmomi::VIM.connect :host => key.to_s, :user => user, :password => password, :insecure => true
    dc = vim.serviceInstance.find_datacenter(datacenter)
    recurse_for_vms(dc.vmFolder)
  end
end
