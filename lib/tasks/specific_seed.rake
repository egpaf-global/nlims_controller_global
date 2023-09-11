# frozen_string_literal: true

# Namespace: db:seed:specific
namespace :db do
  namespace :seed do
    desc 'Run specific seed files'
    task :specific, [:files] => :environment do |_, args|
      files_arg = args[:files]

      if files_arg.blank?
        puts 'No seed files specified. Usage: rails db:seed:specific\[01_user.rb,02_user.rb,03_user.rb\]'
        next
      end
      files = files_arg.split(',')
      files.each do |file|
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
end
