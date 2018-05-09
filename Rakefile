task :push do
  sh 'rsync -av _site/ lrd-admin:/var/www/clients/judsonlester.info/'
end

task :build do
  sh 'jekyll build'
end

task :update do
  puts ENV['NIXOPS_DIR']
  sh %[git log -n 1 --pretty=format:"\\"%H\\"" > #{ENV['NIXOPS_DIR']}/blog/commit.nix]
  sh %[cat #{ENV['NIXOPS_DIR']}/blog/commit.nix; echo]
  sh %[nix-prefetch-git --no-deepClone git@github.com:nyarly/blog.git| jq '.sha256' > #{ENV['NIXOPS_DIR']}/blog/source.nix]

  %w[default.nix Gemfile Gemfile.lock gemset.nix].each do |file|
    cp file, Pathname.new(ENV['NIXOPS_DIR']).join("blog", file).expand_path
  end
end

task :default => [:build, :push]
