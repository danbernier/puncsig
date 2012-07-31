require 'puncsig'

namespace :puncsig do
  desc "Run puncsig on the whole app"
  task :all do
    Puncsig::Report.new(controllers + models + helpers + lib).run
  end

  desc "Run puncsig on just the models"
  task :models do
    Puncsig::Report.new(models).run
  end

  desc "Run puncsig on just the controllers"
  task :controllers do
    Puncsig::Report.new(controllers).run
  end

  desc "Run puncsig on just the helpers"
  task :helpers do
    Puncsig::Report.new(helpers).run
  end

  desc "Run puncsig on just the files in lib"
  task :lib do
    Puncsig::Report.new(lib).run
  end



  def controllers
    all_under("app/controllers")
  end

  def models
    all_under("app/models")
  end

  def helpers
    all_under("app/helpers")
  end

  def lib
    all_under("lib")
  end

  def all_under(dir)
    Dir.glob(File.join(dir, '**/*.rb'))
  end

end
