require "socket"
require "yaml"
require "fileutils"

require "internal/const"
require "internal/utils"

module GGEV
  class PushCommand
    @@name = "push"

    def name() 
      @@name
    end

    def proc(argv) 
      cfg = YAML::load_file(GGEV::DEFAULT_CONFIG_FILE)

      cfg["modules"].each { |mod|
        puts "Processing module #{mod["name"]} ..."

        mod_path = "#{GGEV::REPO_PATH}/#{mod["name"]}"
        if not Dir::exists?(mod_path)
          FileUtils::mkdir_p(mod_path)
        end

        mod["files"].each { |origin_file_path|
          origin_file_path = File::expand_path(origin_file_path)
          file_name = File::basename(origin_file_path)
          cache_file_path = "#{mod_path}/#{file_name}"

          puts "#{origin_file_path} =(enc)=> #{cache_file_path} ..."
          GGEV::Utils::must_run_cmd("openssl enc -#{GGEV::DEFAULT_ENC_CIPHER} -md sha256 -base64 -k #{cfg["encrypt"]["key"]} -in #{origin_file_path} -out #{cache_file_path}")
        }
      }

      ### Cipher
      File::write("#{GGEV::REPO_PATH}/.cipher", "#{GGEV::DEFAULT_ENC_CIPHER}")

      ### Commit repo
      Dir::chdir(GGEV::REPO_PATH) {
        GGEV::Utils::must_run_cmd("git add -A")
        GGEV::Utils::must_run_cmd("git -P diff --cached --stat")
        GGEV::Utils::must_run_cmd("git commit -a -m 'auto-commit by ggev on #{Socket.gethostname}'")
        GGEV::Utils::must_run_cmd("git push origin master")
      }
    end

  end # endof class PushCommand
end # endof module GGEV


