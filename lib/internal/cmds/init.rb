require "internal/const"
require "internal/config"
require "internal/utils"

module GGEV
  class InitCommand
    @@name = "init"

    def name() 
      @@name
    end

    def proc(argv) 
      if File.exists?(GGEV::DEFAULT_CONFIG_FILE)
        puts "Can't initiate multiple times."
        puts "See #{GGEV::DEFAULT_CONFIG_FILE}"
        return
      end

      ## Default config
      FileUtils::mkdir_p(File::dirname(GGEV::DEFAULT_CONFIG_FILE))

      puts "Enter git repository to store/save your configs."
      repo = ""
      while repo.length==0 
        print "Repository: "
        repo = STDIN.gets.strip
      end

      puts "Enter secret key to encrypt/descrypt your configs."
      key = ""
      while key.length==0 
        print "Key: "
        key = STDIN.gets.strip
      end

      defaultCfg = GGEV::Config::default
      defaultCfg["repo"]["remote"] = repo
      defaultCfg["encrypt"]["key"] = key
      File::write(GGEV::DEFAULT_CONFIG_FILE, defaultCfg.to_yaml)

      ## Home dir
      if not Dir::exists?(GGEV::DEFAULT_HOME_PATH)
        FileUtils.mkdir_p(GGEV::DEFAULT_HOME_PATH)
      end

      if not Dir::exists?(GGEV::REPO_PATH)
        GGEV::Utils::must_run_cmd("git clone #{repo} #{GGEV::REPO_PATH}")
      end

      ## DONE
      puts ""
      puts "Congratulations! Init success!"
      puts "The default config file has been created at #{GGEV::DEFAULT_CONFIG_FILE}."
      puts "You can modify it as your necessary."
    end

  end # Endof class InitCommand
end # Endof module GGEV
