

# In this lab we'll be writing a collection of Ruby classes for a real estate app to manage apartments. Use the same approach as you did for the car lot assignment: You are not writing the actual higher-level app itself, but you should have test files that verify the behavior and interactions of your classes.

# Requirements: Classes

class Building
  attr_accessor :address
  attr_reader :apartment_list


  def initialize
    @@apartment_list = []
    @total_square_footage = total_square_footage
    @total_monthly_revenue = total_monthly_revenue
  end

  def new_apartment
    @@apartment_list << apartment
  end

  def remove_apartment number
    @@apartment_list.remove[number]

end

class Apartments #create an array
  def initialize number, rent, square_footage, bedrooms, bathrooms
  end
end

class Tenant
  def initialize name, age, credit_score
    @name = name
    @age = age
    @credit_score = credit_score
  end

  def credit_rating
      if @credit_score >=760
        puts "excellent"
      elsif @credit_score >=725
        puts "great"
      elsif @credit_score >=660
        puts "good"
      elsif @credit_score >=560
        puts "mediocre"
      elsif @credit_score <560
        puts "bad"
      end
  end
end

tenant1 = Tenant.new "Bob", 24, 770

tenant1.credit_rating


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

