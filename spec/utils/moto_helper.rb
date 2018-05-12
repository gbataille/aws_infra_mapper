# frozen_string_literal: true

def start_moto(aws_service)
  return false unless moto_installed?
  return true if already_started? aws_service

  moto_server = 'localhost'
  moto_port = Faker::Number.between(3000, 4000).to_i

  puts_msg_with_separator "Starting a moto server on port #{moto_port} (#{aws_service})"

  moto_pid = spawn('moto_server', aws_service, '-H', moto_server, '-p', moto_port.to_s,
                   out: '/dev/null', err: '/dev/null')
  @moto_servers ||= {}
  @moto_servers.merge!({ aws_service => moto_pid })

  configure_aws_for_moto aws_service, moto_server, moto_port
  true
end

def stop_moto(aws_service)
  unless defined? @moto_servers
    puts_msg_with_separator "Failed to stop moto for #{aws_service}. No Moto started"
  end

  pid = @moto_servers.delete aws_service if @moto_servers.key? aws_service
  puts_msg_with_separator "Killing moto server (#{aws_service}: pid #{pid})"
  Process.kill('KILL', pid) unless pid.nil?
end

private

def already_started?(aws_service)
  if defined?(@moto_servers) && @moto_servers.key?(aws_service)
    puts_msg_with_separator "Moto server for #{aws_service} already started, not starting a new one"
    return true
  end

  false
end

def configure_aws_for_moto(aws_service, moto_server, moto_port)
  set_aws_endpoint_for(aws_service, moto_server, moto_port)
  set_aws_credentials_for(aws_service, 'dummy_key', 'dummy_secret')
end

def moto_installed?
  `which moto_server` != ''
end
