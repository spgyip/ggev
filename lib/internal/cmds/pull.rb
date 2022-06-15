require "yaml"

require "internal/const"
require "internal/utils"

module GGEV
  class PullCommand
    @@name = "pull"

    def name() 
      @@name
    end

    def proc(argv) 
      cfg = {}
      begin
        cfg = YAML::load_file(GGEV::DEFAULT_CONFIG_FILE)
      rescue Exception => e
        puts "Load config file fail: #{GGEV::DEFAULT_CONFIG_FILE}."
        puts "Please run `ggev init`."
        return
      end

      # Process args
      ifForce = false
      ARGV.each { |arg|
        if arg=="-f" or arg=="--force" 
          ifForce = true
        end
      }

      ### Pull resp
      Dir::chdir(GGEV::REPO_PATH) {
        GGEV::Utils::must_run_cmd("git fetch origin master")
        ok, ec = GGEV::Utils::run_cmd_with_exitstatus("git diff --exit-code --stat origin/master")

        if ok 
          # Unchanged
          puts "Unchanged"

          if not ifForce
            return
          else
            puts "Force pull"
          end
        else
          # Error happen
          if ec!=1 
            return
          end

          # ec==1
          # Something changed
          GGEV::Utils::must_run_cmd("git merge origin/master ")
        end
      }

      # Read cipher
      cipher = File::read("#{GGEV::REPO_PATH}/.cipher")

      cfg["modules"].each { |mod|
        puts "Processing module #{mod["name"]} ..."

        mod_path = "#{GGEV::REPO_PATH}/#{mod["name"]}"
        mod["files"].each { |origin_file_path|
          origin_file_path = File::expand_path(origin_file_path)
          file_name = File::basename(origin_file_path)
          cache_file_path = "#{mod_path}/#{file_name}"

          puts "#{cache_file_path} =(enc)=> #{origin_file_path} ..."
          GGEV::Utils::must_run_cmd("openssl enc -#{cipher} -md sha256 -base64 -k #{cfg["encrypt"]["key"]} -d -in #{cache_file_path} -out #{origin_file_path}")
        }
      }
    end

  end # endof class PullCommand
end # endof module GGEV


