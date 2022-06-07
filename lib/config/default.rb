
module GGEV
  module CONFIG
  
    @@default = {
      "repo" => {
        "remote" => "",
      },
      "encrypt" => {
        "key" => ""
      },
      "modules" => [
        {"name" => "vim", "files" => ["~/.vimrc"]},
        {"name" => "git", "files" => ["~/.gitconfig"]},
        {"name" => "zsh", "files" => ["~/.zshrc"]},
        {"name" => "tmux", "files" => ["~/.tmux.conf"]},
        {"name" => "autossh", "files" => ["~/.config/autossh/hosts"]}
      ]
    }

    def self.default()
      @@default
    end

  end
end
