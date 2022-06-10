module GGEV
  class CommandDispatcher
    def initialize()
      @cmds = {}
    end

    def add(c)
      @cmds[c.name] = c
    end

    def names()
      all = []
      @cmds.each { |name, c|
        all << name
      }
      all
    end

    def proc(name, argv)
      c = @cmds[name]
      if not c
        return false
      end

      c.proc(argv)
      return true
    end
  end # endof class CommandDispatcher
end # endof module GGEV

