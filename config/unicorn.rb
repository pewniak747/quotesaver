APP_ROOT = '/u/apps/quotesaver/current'
SHARED_PATH = '/u/apps/quotesaver/shared'

worker_processes 1

working_directory APP_ROOT

pid "#{SHARED_PATH}/pids/quotesaver.pid"

listen 7171

stderr_path "#{SHARED_PATH}/log/quotesaver.stderr.log"
stdout_path "#{SHARED_PATH}/log/quotesaver.stdout.log"

before_fork do |server, worker|
  old_pid = "#{SHARED_PATH}/pids/quotesaver.pid.oldbin"

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
