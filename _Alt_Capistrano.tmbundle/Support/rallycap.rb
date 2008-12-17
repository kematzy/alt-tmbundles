#!/usr/bin/env ruby
require "#{ENV['TM_SUPPORT_PATH']}/lib/exit_codes"
require "#{ENV['TM_SUPPORT_PATH']}/lib/web_preview"

unless ENV['TM_PROJECT_DIRECTORY']
  TextMate::exit_show_html "Please run this from within a TextMate project."
end

unless File.exist?(File.join(ENV['TM_PROJECT_DIRECTORY'],'Capfile'))
  TextMate::exit_show_html "Couldn't find a Capfile in #{ENV['TM_PROJECT_DIRECTORY']}."
end

unless ARGV[0]
  TextMate::exit_show_html "No target specified."
end

target = ''
multistage_dir = File.join(ENV['TM_PROJECT_DIRECTORY'],'config','deploy')
if File.directory?(multistage_dir)
  stages = Dir.entries(multistage_dir).select{|x| x.match(/\.rb$/)}.collect{|x| x.gsub(/\.rb$/,'')}
  if stages.any?
    dialog = `CocoaDialog dropdown --title "Multistage" --no-newline --text "Please select a stage." --items "#{stages.join('" "')}" --button1 "OK"`
    (button,selected) = dialog.split(/\n/)
    target = stages[selected.to_i] + ' '
  end
end
target += ARGV[0]

puts html_head(:title => "Capistrano", :sub_title => ENV['TM_PROJECT_DIRECTORY'])
puts "<pre>"
system("cap -v #{target} | CocoaDialog progressbar --indeterminate --title 'Capistrano' --text 'Working (#{target}…)'")
puts "</pre></div></body></html>"
