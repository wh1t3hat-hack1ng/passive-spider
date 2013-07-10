#!/usr/bin/env ruby

# require gems and needed files
require_relative 'lib/environment'
Environment.require_all

# initialize helper
libhelper = LibHelper.new

# output banner
libhelper.banner

# no user input
if ARGV.empty?
  libhelper.help
  puts
  libhelper.usage
  puts
  exit
end

# default vars
domain       = nil
pages        = nil
all          = nil
all_pages    = nil
all_files    = nil
neighbours   = nil
subdomains   = nil
url_keywords = nil
keywords     = nil

# user input
opts = GetoptLong.new(
	[ '--domain', '-d', GetoptLong::REQUIRED_ARGUMENT ],
	[ '--pages', '-p', GetoptLong::OPTIONAL_ARGUMENT ],
	[ '--all', '-a', GetoptLong::NO_ARGUMENT ],
	[ '--allpages', GetoptLong::NO_ARGUMENT ],
	[ '--allfiles', GetoptLong::NO_ARGUMENT ],
	[ '--neighbours', GetoptLong::NO_ARGUMENT ],
  [ '--subdomains', GetoptLong::NO_ARGUMENT ],
	[ '--urlkeywords', GetoptLong::NO_ARGUMENT ],
	[ '--keywords', GetoptLong::NO_ARGUMENT ],
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ]
)

# parse user input
opts.each do |opt, arg|
  case opt
    when '--domain'
    	domain = arg
    when '--pages'
    	pages = arg.to_i
    when '--all'
    	all = true
    when '--allpages'
    	all_pages = true
    when '--allfiles'
    	all_files = true
    when '--neighbours'
    	neighbours = true
    when '--subdomains'
      subdomains = true
    when '--urlkeywords'
    	url_keywords = true
    when '--keywords'
    	keywords = true
    when '--help'
      libhelper.help
  end
 end

if ! PublicSuffix.valid?( domain )
  puts "[ERROR] The domain supplied (#{domain}) is not a valid domain!"
  exit
end

# make all default if no other options selected
all = true if ! all && ! all_pages && ! all_files && ! neighbours && ! subdomains && ! url_keywords && ! keywords 

# initialize objects
bing = Bing.new( pages )

# start bing api calls
bing.get_all( domain ) if all
bing.get_all_pages( domain ) if all_pages
bing.get_all_files( domain ) if all_files
bing.get_ip_neighbours( domain ) if neighbours
bing.get_subdomains( domain ) if subdomains
bing.get_url_keywords( domain ) if url_keywords
bing.get_keywords( domain ) if keywords

# output output mofo
ModuleHelper.output.stdout

exit