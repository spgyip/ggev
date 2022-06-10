
module GGEV
  module Utils
    def self::run_cmd_with_exitstatus(cmd)
      if not system(cmd) 
        return false, $?.exitstatus
      end
      return true, $?.exitstatus
    end

    def self::run_cmd(cmd)
      ok, es = self::run_cmd_with_exitstatus(cmd)
      return ok
    end

    def self::must_run_cmd(cmd)
      self::run_cmd(cmd) or exit
    end
  end
end

