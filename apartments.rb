### `Building`
# has an address
# has many apartments
# the list of apartments should not be modified directly
  # (Bonus: actually prevent it from being modified directly)
# has a method to add an apartment
# has a method to remove a specific apartment by its number, which raises an error if the number is not found or the apartment currently has any tenants
  # (Bonus: allow overriding this constraint)
# has a total square footage, calculated from all apartments
# has a total monthly revenue, calculated from all apartment rents
# has a list of tenants, pulled from the tenant lists of all apartments
# has a method to retrieve all apartments grouped by `credit_rating`
  # (Bonus: sort the groups by credit rating from `excellent` to `bad`)

class Building
attr_accessor :address
attr_reader :apartments
  def initialize
    @address = address
    @apartments = []
  end

  def  add_apartment (apartment)
    # has a method to add an apartment
    @apartments.push apartment
  end

  def remove_apartment (apartment_number)
    # has a method to remove a specific apartment by its number,
    # which raises an error if the number is not found or the apartment currently has any tenants
    # (Bonus: allow overriding this constraint)
  end

  def total_square_footage
    # has a total square footage, calculated from all apartments
    square_footage.inject {|acc,n| acc + n}
  end

  def total_monthly_revenue
    # has a total monthly revenue, calculated from all apartment rents
    rent.inject {|acc,n| acc + n}
  end

  def tenant_list
    # has a list of tenants, pulled from the tenant lists of all apartments
    select
  end

  def apartments_by_credit_rating
    # has a method to retrieve all apartments grouped by `credit_rating`
    # (Bonus: sort the groups by credit rating from `excellent` to `bad`)
  end
end


### `Apartment`
# has a number, rent, square footage, number of bedrooms, and number of bathrooms
# has many tenants
# the list of tenants should not be modified directly
  # (Bonus: actually prevent it from being modified directly)
# has a method to add a tenant that raises an error if the tenant has a "bad" credit rating, or if the new tenant count would go over the number of bedrooms
# has a method to remove a specific tenant either by object reference *or* by name
  # (Bonus: do this without checking classes), which raises an error if the tenant is not found
# has a method that removes all tenants
# has an average credit score, calculated from all tenants
# has a credit rating, calculated from the average credit score using the logic below...

class Apartment < Building
  attr_accessor :number, :rent, :square_footage, :number_bedrooms, :number_bathrooms
  attr_reader :tenants
  def initialize number, rent, square_footage, number_bedrooms, number_bathrooms
    @number = number
    @rent = rent
    @square_footage = square_footage
    @number_bedrooms = number_bedrooms
    @number_bathrooms = number_bathrooms
    @tenants = []
  end

  def add_tenant (tenant)
    if tenant.credit_rating == :bad
      raise BadCreditRatingError.new tenant # or "this tenant has a bad credit rating"
    end

    raise NotEnoughBedroomError.new tenant if tenants.length == number_bedrooms # another way of presenting the above

    @tenants << tenant # add tenant to the array
    end
    # has a method to add a tenant that raises an error if the tenant has a "bad" credit rating,
    # or if the new tenant count would go over the number of bedrooms
  end

  # has a method to remove a specific tenant either by object reference *or* by name
  # (Bonus: do this without checking classes), which raises an error if the tenant is not found
  def remove_tenant (tenant)
    if tenant.to_s == tenant
      index = @tenants.index { |t| t.name == tenant}
      if index.nil?
        not_found = true
      else
        @tenants.delete_at index
      end
    else
      deleted = @tenants.delete tenant
      not_found = deleted.nil?
    end

    raise NoSuchTenantError.new tenant if not_found
  end

  def remove_all_tenants
    # has a method that removes all tenants
    @tenants.clear
  end

  def average_credit_score
    # has an average credit score, calculated from all tenants
    @tenants.inject{ |sum, el| sum + el }.to_f / @tenants.size
  end

  def credit_rating
   # has a credit rating, calculated from the average credit score using the logic below...
  end
#end


### `Tenant`
# has a name, age, and credit score
# has a credit rating, calculated from the credit score as follows:
  # 760 or higher is "excellent"
  # 725 or higher is "great"
  # 660 or higher is "good"
  # 560 or higher is "mediocre"
  # anything lower is "bad"

class CreditScoreError < Exception # to pick up errors
end

class BadCreditRatingError < Exception # to pick up errors
end

class NotEnoughBedroomError < Exception # to pick up errors
end

class NoSuchTenantError < Exception # to pick up errors
end


class Tenant < Apartment
attr_accessor :name, :age, :credit_score
  def initialize name, age, credit_score
    @name = name
    @age = age
    if credit_score < 0
      raise CreditScoreError.new 'Credit score cannot be negative'
    elsif credit_score > 800
      raise CreditScoreError.new 'Credit score cannot be greater than 800'
    else
      @credit_score = credit_score
    end
  end

  def tenant_credit_rating # use if-else or case-when and range
    case credit_score
    when 0..559 # range
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
    # has a credit rating, calculated from the credit score as follows:
      # 760 or higher is "excellent"
      # 725 or higher is "great"
      # 660 or higher is "good"
      # 560 or higher is "mediocre"
      # anything lower is "bad"
  end
end

begin
  denis = Tenant.new("Denis", 25, -19)
rescue Exception => e # captures the error
  p e
end