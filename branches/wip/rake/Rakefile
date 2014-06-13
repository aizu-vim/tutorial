task :server do
  Rake::Task[:slide].invoke
  Rake::Task[:blog].invoke
  system 'bundle exec jekyll server --config tmp/_config.yml'
end

task :blog do
  puts "# build blog"
  system 'mkdir tmp || true'
  system 'erb _config.yml > tmp/_config.yml'
  system 'bundle exec jekyll build --config tmp/_config.yml'
end

task :slide do
  puts "# build slide"
  system 'find _slide -type f -print0 | xargs -I$$ -0 sh -c "bundle exec slideshow build -o \`dirname $$ | sed s/^.//\` $$"'
end

