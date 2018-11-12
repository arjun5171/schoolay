worker_processes 4
working_directory "/schoolay"               

timeout 60               

listen "/schoolay/unicorn.sock", :backlog => 1024, :tcp_nodelay => true, :tcp_nopush => false, :tries => 5, :delay => 0.5, :accept_filter => "httpready"
pid "/schoolay/pids/unicorn_master.pid"               

#stderr_path "/srv/www/de/log/unicorn.stderr.log"
#stdout_path "/srv/www/de/log/unicorn.stdout.log"

preload_app true
GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)               

# ensure Unicorn doesn't use a stale Gemfile when restarting
# more info: https://willj.net/2011/08/02/fixing-the-gemfile-not-found-bundlergemfilenotfound-error/
before_exec do |server|
ENV['BUNDLE_GEMFILE'] = "/schoolay/Gemfile"
end               

before_fork do |server, worker|
# the following is highly recomended for Rails + "preload_app true"
# as there's no need for the master process to hold a connection
if defined?(ActiveRecord::Base)
 begin
   ActiveRecord::Base.connection.disconnect!
   ActiveRecord::Base.clear_all_connections!
 rescue => e
 end
end               

# Before forking, kill the master process that belongs to the .oldbin PID.
# This enables 0 downtime deploys.
old_pid = "/schoolay/pids/unicorn_master.pid.oldbin"
if File.exists?(old_pid) && server.pid != old_pid
 begin
   Process.kill("QUIT", File.read(old_pid).to_i)
 rescue Errno::ENOENT, Errno::ESRCH
   # someone else did our job for us
 end
end
end               


Rails.logger.level = Logger::DEBUG               

#Rails.cache.reset
if Rails.cache.respond_to? :restart
 Rails.cache.restart
elsif Rails.cache.respond_to? :reconnect
 Rails.cache.reconnect
end               

worker_pid = File.join("/schoolaye/pids/unicorn_worker_#{worker.nr}.pid")
File.open(worker_pid, "w") { |f| f.puts Process.pid }
if defined?(ActiveRecord::Base)
 ActiveRecord::Base.establish_connection
end
# if preload_app is true, then you may also want to check and
# restart any other shared sockets/descriptors such as Memcached,
# and Redis.  TokyoCabinet file handles are safe to reuse
# between any number of forked children (assuming your kernel
# correctly implements pread()/pwrite() system calls)