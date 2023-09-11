namespace :db do
  namespace :seed do
    desc 'Run a specific seed file'
    task :specific, [:file] => :environment do |_, args|
      file = args[:file]
      seed_file = Rails.root.join('db', file)
      puts "Seed file: #{seed_file}"
      if File.exist?(seed_file)
        puts "Running seed file: #{file}"
        load(seed_file)
      else
        puts "Seed file not found: #{file}"
      end
    end
  end
end
