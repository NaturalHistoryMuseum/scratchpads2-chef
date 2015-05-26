# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "simor"
client_key               "#{current_dir}/user.pem"
validation_client_name   "nhm"
validation_key           "#{current_dir}/nhm.pem"
chef_server_url          "https://chef.nhm.ac.uk/organizations/nhm"
cookbook_path            ["#{current_dir}/../cookbooks"]

knife['editor'] = "nano"
