

# In this lab we'll be writing a collection of Ruby classes for a real estate app to manage apartments. Use the same approach as you did for the car lot assignment: You are not writing the actual higher-level app itself, but you should have test files that verify the behavior and interactions of your classes.

# Requirements: Classes

class Building
  attr_accessor :address
  attr_reader :apartment_list


  def initialize address
    @address = address
    @apartment_list = []

  end

  def new_apartment
    @apartment_list << apartment
  end

  def remove_apartment number
    @@apartment_list.remove[number]

end

class Apartments #create an array
  attr_reader :number, :rent, :square_footage,
              :bedrooms, :bathrooms, :tenants
  def initialize number, rent, square_footage, bedrooms, bathrooms
    @number = number
    @rent = rent
    @square_footage = square_footage
    @bedrooms = bedrooms
    @bathrooms = bathrooms
    @tenants = []
  end

  def add_tenant tenant
    if tenant.credit_rating == :bad
      raise BadCreditRatingError.new "sorry you're a bad tenant"
    end

    if NotEnoughBedroomError.new "not enough bedrooms" if @tenants.length == number_of_bedrooms

      @tenants << tenant
    end
  end

  #tenant can be an object or a name
  def remove_tenant tenant
    if tenant.to_s == tenant #this is matching the tenant, you could also do tenant.class = "String"
      index = @tenants.index { |t| t.name == tenant}
      if index.nil?
        not_found = true
      else
        @tenants.delete_at_index
      end
    else
      deleted = @tenants.delete tenant
      not_found = deleted.nil?
    end

    raise NoSuchTenantError.new tenant if not_found
  end

#NEED TO UNDERSTAND THIS
  def average_credit_score
    @tenants.inject{ |sum, t| sum + t.credit_score }.to_f / @tenants.size
  end

end

class Tenant
  attr_reader :name, :age, :credit_score
  def initialize name, age, credit_score
    @name = name
    @age = age
    if credit_score < 0
      raise CreditScoreError 'Score cannot be negative'
    elsif credit > 800
      raise CreditScoreError 'Score cannot be bigger than 800'
    else
      @credit_score = credit_score
  end

  def credit_rating #use the case switch method
      case @credit_score
        when 0..559
          :bad
        when 560..659
          :mediocre
        when 660..724
          :good
        when 725..759
          :great
        else
          :excellent
      end
  end
end

class CreditScoreError < Exception
end

class BadCreditRatingError < Exception
end

class NotEnoughBedroomError < Exception
end

class NoSuchTenantError < Exception
end


#class is always in camel case
# variables etc we use snake case
# to "capture" the error you can type
# begin
#   denis = Tenant.new("denis", 25, -19)
# rescue Exception => e
# p e

tenant1 = Tenant.new "Bob", 24, 770

tenant1.credit_rating

#check out inject method for the average of tenants
#each: each_with_object is another method to check out for above as well

# Building
# has an address
# has many apartments
# the list of apartments should not be modified directly (bonus: actually prevent it from being modified directly)
# has a method to add an apartment
# has a method to remove a specific apartment by its number, which raises an error if the number is not found or the apartment currently has any tenants (bonus: allow overriding this constraint)
# has a total square footage, calculated from all apartments
# has a total monthly revenue, calculated from all apartment rents
# has a list of tenants, pulled from the tenant lists of all apartments
# has a method to retrieve all apartments grouped by credit_rating (bonus: sort the groups by credit rating from excellent to bad)

# Apartment - array

# has a number, rent, square footage, number of bedrooms, and number of bathrooms
# has many tenants
# the list of tenants should not be modified directly (bonus: actually prevent it from being modified directly)
# has a method to add a tenant that raises an error if the tenant has a "bad" credit rating, or if the new tenant count would go over the number of bedrooms
# has a method to remove a specific tenant either by object reference or by name (bonus: do this without checking classes), which raises an error if the tenant is not found
# has a method that removes all tenants
# has an average credit score, calculated from all tenants
# has a credit rating, calculated from the average credit score using the logic below

# Tenant

# has a name, age, and credit score
# has a credit rating, calculated from the credit score as follows:

# Instructions

