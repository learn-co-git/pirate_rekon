require './config/environment'
require './config/initializers/cloudinary.rb'


if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride

use CollectionsController
run ApplicationController
