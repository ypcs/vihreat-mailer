#!/usr/bin/env ruby

# Author: Ville Korhonen <ville@xd.fi>
# License: AGPLv3

require 'rubygems'
require 'premailer'
require 'optparse'
require 'ostruct'
require 'pp'


class PremailerCLI
    Version = 1, 0, 0
    def self.parse(args)
        options = OpenStruct.new
        options.verbose = false
        options.infile = false
        options.outfile_html = nil
        options.outfile_plain = nil

        opt_parser = OptionParser.new do |opts|
            opts.banner = "Usage: premailer.rb [options] <infile> <outfile.html> <outfile.txt>"
            opts.separator ""
            opts.separator "Specific options:"

            opts.on("-v", "--[no-]verbose", "Verbose output") do |v|
                options.verbose = v
            end

            opts.on("--version", "Show version") do
                puts ::Version.join('.')
                exit
            end
        end
    end

    def self.convert(source, target_html, target_plain)

        premailer = Premailer.new(source, :warn_level => Premailer::Warnings::SAFE)

        File.open(target_html, "w") do |fout|
          fout.puts premailer.to_inline_css
        end

        File.open(target_plain, "w") do |fout|
          fout.puts premailer.to_plain_text
        end

        premailer.warnings.each do |w|
          puts "W: #{w[:message]} (#{w[:level]}) may not render properly in #{w[:clients]}"
        end

    end

    def self.run()
        unless ARGV.length == 3
            puts "Usage: premailer.rb <source-file> <target-html> <target-plain>"
            puts "TODO: Usage"
            exit 1
        end
        source_file = ARGV[0]
        target_html = ARGV[1]
        target_plain = ARGV[2]
        puts "I: Converting #{source_file} to inline-css #{target_html} and plain-text #{target_plain}.."
        self.convert source_file, target_html, target_plain
    end
end

PremailerCLI.run()
