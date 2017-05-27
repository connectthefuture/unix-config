#!/bin/sh
exec ruby -x "$0" "$@"
#!ruby -W0

# setup-environment
# The MIT License (MIT) [https://opensource.org/licenses/MIT]
# Copyright (c) 2016 Gregory D. Stula
#
#  Created by Gregory D. Stula on 1/4/16.
#

# ghetto option parsing
backup_enabled = (ARGV[1] == "--back-up") || (ARGV[1] == "-b")

topleveldir= `git rev-parse --show-toplevel`.chomp
if topleveldir.empty?
   $stderr.puts "# No .git/ found! #"
   exit(1)
end

unix_config_dir = "#{ENV['HOME']}/.unix_config_dir"

`echo #{topleveldir} > #{unix_config_dir}`

homedir = ENV["HOME"] + "/"
filenames = [".zshrc", ".zsh", ".vimrc", ".vim"].map { |name| homedir + name }

spacing = filenames.max_by(&:length).length + 1

filenames.each do |file|
    if File.exists?(file) && !File.symlink?(file)
        now = Time.now.to_s.split(" ").join("-")
        backup = "#{file}.old-#{now}"
        action = ''

        backup_enabled ? action = "mv #{file} #{backup}" : action = "rm #{file}"

        `#{action}`

        $stderr.puts "Previous #{file} was saved as #{backup}" if action == "mv"
    end

   `rm #{file}` if File.symlink?(file)

   source = "#{ file.split( "." )[1] }"
   file =~ /(vim|zsh|git)/i
   `ln -s #{topleveldir}/#{$1}.config/#{source} #{file}`

    puts "#{file}|".rjust(spacing)
end

success_message = "| were successfully symlinked."
puts success_message.rjust(success_message.length + spacing - 1)

puts

puts "Would you like to install Microsoft Fonts now? (Y/n)"
answer = STDIN.gets.chomp

if answer.downcase == 'y'
	system('./MicrosoftFontInstaller')
elsif answer.downcase == 'n'
    puts "You can always install later by running MicrosoftFontInstaller in \$UNIX_CONFIG_DIR/unix-config/scripts"
else
    puts "Aborting ..."
end

puts

puts "Fetching and building dependencies..."

system('./build-dependencies.zsh')
