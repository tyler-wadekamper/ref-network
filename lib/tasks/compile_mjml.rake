namespace :mjml do
  desc "Compile all MJML files"
  task compile: :environment do
    mjml_files = Dir.glob(Rails.root.join('app', 'views', '**', '*.mjml'))

    mjml_files.each do |file|
      html_file = file.sub(/\.mjml\z/, '.html')
      system "mjml #{file} -o #{html_file}"
      puts "Compiled #{file} to #{html_file}"
    end
  end
end
