set :application, "com.summercode.habrjobs"

set :scm, :git
set :branch, "master"
set :repository, "gitosis@git.summercode.com:habrjobs.git"

role :app, "summercode"

set :user, "cr0t"
set :use_sudo, false

set :deploy_to, "/var/www/#{application}"

set :shared_children, %w(tmp)

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end