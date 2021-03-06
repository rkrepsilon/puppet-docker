Puppet::Type.newtype(:docker_network) do
  @doc = 'Docker network'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc "The new network’s name"
  end

  newparam(:check_duplicate, :boolean => true) do
    desc "Requests daemon to check for networks with same name"
    newvalues(:true, :false)
  end

  newparam(:driver) do
    desc "Name of the network driver plugin to use. Defaults to bridge driver"
  end

  newparam(:internal, :boolean => true) do
    desc "Restrict external access to the network"
    newvalues(:true, :false)
  end

  newparam(:ipam) do
    desc "Optional custom IP scheme for the network"

    validate do |value|
      raise ArgumentError, "Docker network IPAM configuration '#{value}' is not a Hash" unless value.is_a?(Hash)
    end
  end

  newparam(:enable_ipv6, :boolean => true) do
    desc "Enable IPv6 on the network"
    newvalues(:true, :false)
  end

  newparam(:options) do
    desc "Network specific options to be used by the drivers"

    validate do |value|
      raise ArgumentError, "Docker network options '#{value}' is not a Hash" unless value.is_a?(Hash)
    end
  end

  newparam(:labels) do
    desc 'Labels to set on the network, specified as a map: {"key" => "value","key2" => "value2"}'

    validate do |value|
      raise ArgumentError, "Docker network labels '#{value}' is not a Hash" unless value.is_a?(Hash)
    end
  end

  autorequire(:service) do
    ["docker"]
  end
end
