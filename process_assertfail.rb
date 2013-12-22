$:.unshift File.dirname(__FILE__)
require "scrape_blogspot"
#    File.open(File.join("fixture","sample.html"), "r") { |infile|
#      @parser = ScrapeBlogspot.new(infile.read)
#    }
#puts Dir.glob(File.join(File.dirname(__FILE__),"assertfail.blogspot.se","**","*.*"))

filtered = Dir.glob(File.join(File.dirname(__FILE__),"assertfail.blogspot.se","*")).select do |file| 
    /\d+$/=~file 
end.map do |folder|
    {folder: folder, files: Dir.glob(File.join(folder, "**","*.*")) }
end
info = filtered.map do |folder|
    folder[:files].map do |file|
        scraped = ScrapeBlogspot.new(File.open(file, "r", :encoding => 'utf-8').read)
        {
            name: File.basename(file),
            folder: folder[:folder].split(File::SEPARATOR).last,
            title: scraped.title,
            date_published: scraped.date_published,
            content: scraped.content,
            labels: scraped.labels
        }
    end
end.flatten(1)
puts info
#puts Dir.glob(File.join(File.dirname(__FILE__),"assertfail.blogspot.se","**","*.*"))
require 'fileutils'
FileUtils::rm_rf('assertfail.processed/*')
f = 'assertfail.processed'
FileUtils::mkdir_p(f)
info.each do |p|
    #destf = File.join(f,p[:folder])
    #FileUtils::mkdir_p(destf)
    content = [];
    content << '---'
    content << "layout: post"
    content << "title:  \"#{p[:title]}\""
    content << "date: #{p[:date_published]}"
#    date:   2013-12-05 22:27:43
    content << "categories: #{p[:labels].join(' ')}"
    content << '---'
    content << ''
    content << p[:content]
    
    File.write(File.join(f,p[:date_published].to_date.to_s+"-"+ File.basename( p[:name], ".*" )+".markdown"),content.join("\n"))
end



