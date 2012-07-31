require 'puncsig'
require 'rails'

module Puncsig
  class Railtie < Rails::Railtie
    railtie_name :puncsig

    rake_tasks do
      load "tasks/puncsig.rake"
    end
  end
end
