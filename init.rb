# Include hook code here
if RAILS_ENV == "test"
  ActiveRecord::Base.send :include, SkipValidations
end
