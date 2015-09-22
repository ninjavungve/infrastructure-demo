desc 'Set up host environment (create /srv directories)'
task :setup do
  cmds = [
    # Webserver
    'install -o    0 -g    0 -m 755 -d /srv/web',
    'install -o    0 -g    0 -m 755 -d /srv/log/webserver',
    # OwnCloud
    'install -o 1281 -g  100 -m 700 -d /srv/owncloud',
    'install -o 1281 -g  100 -m 755 -d /srv/log/owncloud',
    # GitLab
    'install -o 1283 -g 1283 -m 755 -d /srv/gitlab',
    'install -o 1283 -g  100 -m 755 -d /srv/log/gitlab',
    # Mailserver
    'install -o    0 -g    0 -m 755 -d /srv/mail',
    # Syncthing
    'install -o 1224 -g  100 -m 755 -d /srv/storage',
    # Minecraft
    'install -o 1280 -g  100 -m 755 -d /srv/minecraft',
    # PostgreSQL
    'install -o  999 -g    0 -m 700 -d /srv/postgresql',
    # ElasticSearch
    'install -o  105 -g  108 -m 755 -d /srv/elasticsearch',
  ]
  sh "docker run --rm -v /srv:/srv zargony/base /bin/bash -c '#{cmds.join(' && ')}'"
end

desc 'Build base iamge(s)'
task :baseimage do
  sh "docker build -t zargony/base base"
  sh "docker build -t zargony/base-ruby base-ruby"
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
