desc 'Build base iamge'
task :baseimage do
  sh "docker build -t zargony/base base"
end

desc 'Remove exited containers'
task :rm do
  containers = `docker ps -qf status=exited`.split(/\s+/)
  sh "docker rm #{containers.join(' ')}" unless containers.empty?
end

desc 'Remove unused images'
task :rmi do
  images = `docker images -qf dangling=true`.split(/\s+/)
  sh "docker rmi #{images.join(' ')}" unless images.empty?
end

desc 'Clean up (remove exited containers and unused images)'
task clean: [:rm, :rmi]

desc 'Start interactive shell'
task :shell do
  sh 'docker run --rm -i -t -v /srv:/srv zargony/base /bin/bash'
end

desc 'Start interactive PostgreSQL command line interface'
task :psql do
  sh 'docker run --rm -i -t --link postgresql:postgresql postgres /usr/bin/psql -h postgresql -U postgres'
end
