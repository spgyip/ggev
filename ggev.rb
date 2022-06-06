#!/usr/bin/ruby

require "logger"
require "yaml"

# Constants
DEFAULT_CONFIG_FILE="./config/ggev.yaml"
DEFAULT_HOME_PATH=File::expand_path("~/.ggev")
REPO_PATH="#{DEFAULT_HOME_PATH}/repo"
DEFAULT_ENC_CIPHER="aes-128-cbc"

# Functions
def usage()
  puts "Usage: #{$PROGRAM_NAME} [command]"
  puts ""
  puts "Commands:"
  puts " init"
  puts " push"
  puts " pull"
end

def run_cmd(cmd)
  logger = Logger.new(STDOUT)
  if not system(cmd) 
    return false
  end
  return true
end

def must_run_cmd(cmd)
  run_cmd(cmd) or exit
end

# Main
logger = Logger::new(STDOUT)

if ARGV.length < 1
  usage()
  exit
end
cmd = ARGV[0]

## Load config
cfg = YAML::load_file(DEFAULT_CONFIG_FILE)

## Pre-check environment
for bin in ["openssl", "git"] 
  logger.info("Checking `#{bin}`...")
  if not run_cmd("which #{bin}")
    logger.error("Missing `#{bin}` which is required.")
    exit
  end
end

## Prepare project directories
if not Dir::exists?(DEFAULT_HOME_PATH)
  logger.info("#{DEFAULT_HOME_PATH} not found, creating ...")
  Dir.mkdir(DEFAULT_HOME_PATH)
end

if not Dir::exists?(REPO_PATH)
  logger.info("Cloning repo ...")
  must_run_cmd("git clone #{cfg["repo"]["remote"]} #{REPO_PATH}")
end


## Process commands
if cmd=="push"
  cfg["modules"].each { |mod|
    puts "Processing module #{mod["name"]} ..."

    mod_path = "#{REPO_PATH}/#{mod["name"]}"
    if not Dir::exists?(mod_path)
      FileUtils::mkdir_p(mod_path)
    end

    mod["files"].each { |from_file_path|
      from_file_path = File::expand_path(from_file_path)
      file_name = File::basename(from_file_path)
      to_file_path = "#{mod_path}/#{file_name}"

      logger.info("#{from_file_path} =(enc)=> #{to_file_path} ...")
      run_cmd("openssl enc -#{DEFAULT_ENC_CIPHER} -base64 -k #{cfg["encrypt"]["key"]} -in #{from_file_path} -out #{to_file_path}")
    }
  }

  ### Cipher
  File::write("#{REPO_PATH}/.cipher", "#{DEFAULT_ENC_CIPHER}")

  ### Commit repo
  Dir::chdir(REPO_PATH) {
    must_run_cmd("git add -A")
    must_run_cmd("git -P diff --cached --stat")
    must_run_cmd("git commit -a -m 'auto-commit by ggev'")
    must_run_cmd("git push origin master")
  }
end
