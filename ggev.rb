#!/usr/bin/ruby

require "logger"
require "yaml"

# Constants
DEFAULT_CONFIG_FILE="./config/ggev.yaml"
DEFAULT_PATH=File::expand_path("~/.ggev/")
REPO_PATH="#{DEFAULT_PATH}/repo/"
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

## Pre-check environment
for bin in ["openssl", "git"] 
  logger.info("Checking `#{bin}`...")
  if not run_cmd("which #{bin}")
    logger.error("Missing `#{bin}` which is required.")
    exit
  end
end

## Prepare project directories
if not Dir::exists?(DEFAULT_PATH)
  logger.info("#{DEFAULT_PATH} not found, creating ...")
  Dir.mkdir(DEFAULT_PATH)
end

if not Dir::exists?(REPO_PATH)
  logger.info("Cloning repo ...")
  must_run_cmd("git clone #{cfg["repo"]["remote"]} #{REPO_PATH}")
end

## Load config
cfg = YAML::load_file(DEFAULT_CONFIG_FILE)

## Process commands
if cmd=="push"
  cfg["modules"].each { |mod|
    puts "Processing module #{mod["name"]} ..."

    mod_path = "#{REPO_PATH}/#{mod["name"]}/"
    if not Dir::exists?(mod_path)
      logger.info("Mkdir #{mod_path} ...")
      Dir::mkdir(mod_path)
    end

    mod["files"].each { |file|
      origin_file = File::expand_path(file["origin"])
      cache_file = "#{mod_path}/#{file["cache"]}"
      logger.info("#{origin_file} =(enc)=> #{cache_file} ...")
      run_cmd("openssl enc -#{DEFAULT_ENC_CIPHER} -base64 -k #{cfg["encrypt"]["key"]} -in #{origin_file} -out #{cache_file}")
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
