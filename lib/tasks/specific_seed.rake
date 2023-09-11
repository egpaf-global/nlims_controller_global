namespace :db do
  namespace :seed do
    desc 'Run a specific seed file'
    task :specific, [:file] => :environment do |_, args|
      file = args[:file]
      seed_file = Rails.root.join('db', file)
      seed_file1 = Rails.root.join('db', 'seeds', file)
      puts "Seed file: #{seed_file}"
      if File.exist?(seed_file)
        puts "Running seed file: #{file}"
        load(seed_file)
      elsif File.exist?(seed_file1)
        puts "Running seed file: #{file}"
        load(seed_file1)
      else
        puts "Seed file not found: #{file}"
      end
    end
  end
end
