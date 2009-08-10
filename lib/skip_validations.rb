# SkipValidations
module SkipValidations
  def self.included(base)
    base.extend SkipValidations::ClassMethods
  end


  module ClassMethods
    def skip_validations(*with_models)
      Array(with_models).each do |m|
        class_name = m.to_s.classify.constantize
        class_name.class_eval %Q{
          alias_method :save!, :save_without_validation!
        }
      end
      yield
    ensure
      Array(with_models).each do |m|
        class_name = m.to_s.classify.constantize
        class_name.class_eval %Q{
          alias_method :save!, :save_with_validation!
        }
      end
    end
  end
end
