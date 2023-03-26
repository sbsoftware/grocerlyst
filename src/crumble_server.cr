require "./styles/*"
require "./models/*"
require "./stimulus_controllers/*"
require "./views/*"
require "./resources/*"

StimulusInclude = {{ run("./stimulus_include.cr").stringify }}

Crumble::Server.start
