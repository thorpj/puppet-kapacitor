 Puppet::Functions.create_function(:generate_toml) do
  dispatch :generate_toml do
    param 'Hash', :data
  end

  def generate_toml(data)
    require 'toml'

    TOML::Generator.new(data).body
  end
end