class Chef
  # Public: This class provides helpers for retrieving passwords from encrypted
  # data bags
  class ScratchpadsEncryptedData
    attr_accessor :node, :bag, :secret_file

    def initialize(node, bag = node['scratchpads']['encrypted_data_bag'])
      @node = node
      @bag = bag
      @secret_file = node['scratchpads']['encrypted_data_bag_secret_file']
    end

    # Function which retuns the 
    def get_encrypted_data(item, key)
      datum = nil
      begin
        # load the encrypted data bag item, using a secret if specified
        data = Chef::EncryptedDataBagItem.load(@bag, item, secret)
        # now, let's look for the data
        datum = data[key]
      rescue
        Chef::Log.info("Unable to load data for #{key}, #{item}.")
      end
      datum
    end

    private
    def data_bag_secret_file
      if !secret_file.empty? && ::File.exist?(secret_file)
        secret_file
      elsif !Chef::Config[:encrypted_data_bag_secret].empty?
        Chef::Config[:encrypted_data_bag_secret]
      end
    end
    def secret
      return unless data_bag_secret_file
      Chef::EncryptedDataBagItem.load_secret(data_bag_secret_file)
    end
  end
end
