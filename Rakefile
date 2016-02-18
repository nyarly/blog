task :push do
  sh 'rsync -av _site/ lrd-admin:/var/www/clients/judsonlester.info/'
end

task :build do
  sh 'jekyll build'
end

task :default => [:build, :push]
