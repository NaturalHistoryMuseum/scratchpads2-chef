# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "sdrycroft"
client_key               "#{current_dir}/sdrycroft.pem"
validation_client_name   "nhm-validator"
validation_key           "#{current_dir}/nhm-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/nhm"
cookbook_path            ["#{current_dir}/../cookbooks"]
secret_file              "#{current_dir}/encrypted_data_bag_secret"

knife['editor'] = "nano"
