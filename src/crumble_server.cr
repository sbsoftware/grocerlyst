require "./models/*"
require "./views/*"
require "./resources/*"
require "./styles/*"

StimulusInclude = {{ run("./stimulus_include.cr").stringify }}

Crumble::Server.start
