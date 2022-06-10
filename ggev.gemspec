Gem::Specification.new do |s|
  s.name        = "ggev"
  s.version     = "0.6.0"
  s.summary     = "Guigui ENV!"
  s.description = "Manage personal ENV"
  s.authors     = ["supergui"]
  s.email       = "supergui@live.cn"
  s.homepage    = "https://rubygems.org/gems/ggev"
  s.license     = "MIT"

  s.executables << "ggev"
  Dir.glob("./lib/internal/*.rb").each { |fp|
    s.files << fp
  }
  Dir.glob("./lib/internal/cmds/*.rb").each { |fp|
    s.files << fp
  }
end
