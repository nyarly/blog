task :build do
  sh 'jekyll build'
end

desc "Update the pinned version in the Nixops setup"
task :update do
  puts ENV['NIXOPS_DIR']
  sh %[git log -n 1 --pretty=format:"\\"%H\\"" > #{ENV['NIXOPS_DIR']}/packages/blog/commit.nix]
  sh %[cat #{ENV['NIXOPS_DIR']}/packages/blog/commit.nix; echo]
  sh %[nix-prefetch-git --no-deepClone git@github.com:nyarly/blog.git| jq '.sha256' > #{ENV['NIXOPS_DIR']}/packages/blog/source.nix]

  %w[default.nix Gemfile Gemfile.lock gemset.nix].each do |file|
    cp file, Pathname.new(ENV['NIXOPS_DIR']).join("packages/blog", file).expand_path
  end

  puts
  puts "Remember to `cd #{ENV['NIXOPS_DIR']}; nixops deploy -d webserver`"
end

task :default => [:build, :push]
