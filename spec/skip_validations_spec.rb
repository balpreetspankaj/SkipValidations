require File.dirname(__FILE__) + '/spec_helper'

module SkipValidationsSpec
  class User < ActiveRecord::Base
    def validate
      if money <= 0
        errors.add_to_base "Money should be greater than 0"
      end
    end
  end
  
  class Person < ActiveRecord::Base
    validates_numericality_of :money
  end
  
  describe "Checking Validations" do
    before(:each) do
      @user = User.new
      @person = Person.new
    end
    
    context "Validations turned on" do
      it "should raise an error when saving invalid records" do
        @user.money = 0
        lambda {
          @user.save!
        }.should raise_error
      end
    end
    
    context "Validations turned off" do
      it "should not raise an error when saving invalid record for the skipped model" do
        @user.money = 0
        lambda {
          ActiveRecord::Base.skip_validations("SkipValidationsSpec::User") { @user.save! }
        }.should_not raise_error
      end
      
      it "should still raise an error when saving invalid record for the unskipped model" do
        @user.money = 0
        @person.money = "XXX"
        lambda {
          ActiveRecord::Base.skip_validations("SkipValidationsSpec::User") do
            @user.save!
            @person.save!
          end
        }.should raise_error
      end
      
      it "should raise an error if trying to save outside the block" do
        @user.money = 0
        lambda {
          ActiveRecord::Base.skip_validations("SkipValidationsSpec::User") { @user.save! }
        }.should_not raise_error
        lambda {@user.save!}.should raise_error
      end
      
      it "should not raise an error if skipping multiple models for all invalid records" do
        @user.money = 0
        @person.money = "XXXX"
        lambda {
          ActiveRecord::Base.skip_validations("SkipValidationsSpec::User", "SkipValidationsSpec::Person") do
            @user.save!
            @person.save!
          end
        }.should_not raise_error
      end
      
      
    end
  
  end
  
end