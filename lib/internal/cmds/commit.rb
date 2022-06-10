module GGEV
  class CommitCommand
    @@name = "commit"

    def name() 
      @@name
    end

    def proc(argv) 
      puts "process commit"
      puts argv
    end

  end # endof class CommitCommand
end # endof module GGEV
