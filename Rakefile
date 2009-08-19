# MagLev Rakefile

require 'rake/clean'
require 'rake/rdoctask'
require 'rakelib/maglev'
require 'rakelib/parser'

require 'rakelib/maglev_stone.rb'
require 'rakelib/contrib/ottobehrens/stone.rb'

verbose false  # turn off rake's chatter about all the sh commands

CLEAN.include('*.out', 'log/vmunit*.out', 'log/all*.out', 'html', 'vmunit.log', 'topazerrors.log')
CLOBBER.include('lib/ruby/site_ruby/1.8/smalltalk', 'version.txt')

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include('README*', 'docs/*', 'LICENSES.txt', 'src/kernel/bootstrap/Maglev.rb')
end

task :default => :'maglev:status'

# This initializes the environment, and then ensures that there is a
# gemstone diretory there.  Needed to pull this out, since some of the
# initialization tasks need to be performed before there is a gemstone dir
# there, but need the ENV var (i.e., need to know where gemstone should
# be).
task :gemstone do
  raise "\nBad GEMSTONE dir: '#{GEMSTONE}'" unless File.directory?(GEMSTONE)
  raise "\nNo etc/maglev.demo.key" unless File.exists?("etc/maglev.demo.key")
end

desc "Run a squeak image"
task :squeak do
  gem_tools = '/Applications/Maglev.app'
  if File.exists?(gem_tools)
    sh %{ open #{gem_tools} }
  else
    puts "The #{gem_tools} application used by the 'squeak' command was not found on your system."
    puts "To fix this, correct the 'squeak' command in the gemstone script."
  end
end

desc "Stop netldi"
task :stopnetldi do
  GemStoneInstallation.current.stopnetldi
end

desc "Start netldi"
task :startnetldi do
  GemStoneInstallation.current.startnetldi
end
namespace :stone do
  desc "List MagLev stones managed by this Rakefile"
  task :list do
    puts GemStoneInstallation.current.stones.join("\n")
  end

  desc "Create a new stone"
  task :create, :stone_name do |t, args|
    raise ArgumentError, "Task #{t.name} requires a stone name" unless args.stone_name
    puts "Creating #{args.stone_name}"
    MagLevStone.create(args.stone_name)
  end

  desc "Destroy a stone"
  task :destroy, :stone_name do |t, args|
    raise ArgumentError, "Task #{t.name} requires a stone name" unless args.stone_name
    puts "Destroying #{args.stone_name}"
    s = Stone.existing(args.stone_name)
    s.stop
    s.destroy!
  end

  desc "Invoke a task on all stones"
  task :all, :task_name do |t,args|
    GemStoneInstallation.current.stones.each do |stone_name|
      Rake::Task["#{stone_name}:#{args.task_name}"].invoke
    end
  end
end

def task_gemstone(stone, action, desc=nil)
  desc "#{desc.nil? ? action.to_s : desc} #{stone.name}"
  task action do
    stone.send(action)
  end
end

GemStoneInstallation.current.stones.each do |stone_name|
  namespace stone_name do
    stone = MagLevStone.new(stone_name, GemStoneInstallation.current)
    [[:start,            "Start the stone"],
     [:stop,             "Stop the stone"],
     [:restart,          "Stop then start the stone"],
     [:status,           "Report status of stone"],
     [:reload,           "Destroy then create the stone"],
     [:take_snapshot,    "Make a backup of the stone"],
     [:restore_snapshot, "Restore the stone from the previous snapshot"]
    ].each do |action,desc|
      task_gemstone(stone, action, desc)
    end
  end
end
