worker_processes 1
user "git", "git"
working_directory "/opt/gitlab"
listen "/var/www/gitlab/backend.sock", :backlog => 64
listen "0.0.0.0:8080", :tcp_nopush => true
timeout 30
stderr_path "/var/log/gitlab/gitlab/unicorn.stderr.log"
stdout_path "/var/log/gitlab/gitlab/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
