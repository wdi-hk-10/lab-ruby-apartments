# Custom Error Classes
class BadCreditRatingError < Exception 
end
class NotEnoughBedroomError < Exception 
end
class NoSuchTenantError < Exception
end
class NoSuchApartmentError < Exception
end
class ApartmentOccupiedError < Exception
end

# has a credit rating, calculated from the credit score as follows:
  # 760 or higher is "excellent"
  # 725 or higher is "great"
  # 660 or higher is "good"
  # 560 or higher is "mediocre"
  # anything lower is "bad"
def calculate_credit_rating credit_score
  case credit_score
    when 0..559 then :bad
    when 560..659 then :mediocre
    when 660..724 then :good
    when 725..759 then :great
    else :excellent
  end
end

### Tenant
class Tenant
  attr_reader :name, :age, :credit_score

  # has a name, age, and credit score
  def initialize name, age, credit_score
    @name = name
    @age = age
    @credit_score = credit_score
  end

  def credit_rating
    calculate_credit_rating @credit_score
  end

  def to_s
    inspect
  end
end

### Apartment
class Apartment
  attr_reader :number, :rent, :square_footage, :number_of_bedrooms, :number_of_bathrooms

  # has a number, rent, square footage, number of bedrooms, and number of bathrooms
  def initialize number, rent, square_footage, number_of_bedrooms, number_of_bathrooms
    @number = number
    @rent = rent
    @square_footage = square_footage
    @number_of_bedrooms = number_of_bedrooms
    @number_of_bathrooms = number_of_bathrooms

    # has many tenants
    @tenants = []
  end

  # the list of tenants should not be modified directly 
  # (bonus: actually prevent it from being modified directly)
  def tenants
    @tenants.dup
  end

  # has a method to add a tenant that raises an error if the tenant has a "bad" credit rating, 
  # or if the new tenant count would go over the number of bedrooms
  def add_tenant tenant
    raise BadCreditRatingError.new tenant if tenant.credit_rating == :bad
    raise NotEnoughBedroomError.new tenant if @tenants.length == @number_of_bedrooms

    @tenants << tenant
  end

  # has a method to remove a specific tenant either by object reference 
  # *or* by name (bonus: do this without checking classes), 
  # which raises an error if the tenant is not found
  def remove_tenant tenant
    name_to_remove = tenant
    name_to_remove = tenant.name unless tenant.to_s == tenant
    removed = @tenants.reject! {|t| t.name == name_to_remove}
    raise NoSuchTenantError.new tenant if removed.nil?
  end

  # has a method that removes all tenants
  def remove_all_tenants
    @tenants.clear
  end

  # has an average credit score, calculated from all tenants
  def average_credit_score
    @tenants.inject(0) {|sum,t| sum + t.credit_score}.to_f / @tenants.length

    # The 2 alternative ways require looping the array twice
    #@tenants.map{|t| t.credit_score}.reduce(:+).to_f / @tenants.length
    #@tenants.map(&:credit_score).reduce(:+).to_f / @tenants.length
  end

  # has a credit rating, calculated from the average credit score using the logic below
  def credit_rating
    calculate_credit_rating average_credit_score
  end

  # helper method
  def has_tenants?
    @tenants.any?
  end

  def to_s
    inspect
  end
end

### Building
class Building
  attr_reader :address

  # has an address
  def initialize address
    @address = address

    # has many apartments
    @apartments = []
  end

  # the list of apartments should not be modified directly 
  # (bonus: actually prevent it from being modified directly)
  def apartments
    @apartments.dup
  end

  # has a method to add an apartment
  def add_apartment apartment
    @apartments << apartment
  end

  # has a method to remove a specific apartment by its number, 
  # which raises an error if the number is not found or the apartment currently has any tenants 
  # (bonus: allow overriding this constraint)
  def remove_apartment apartment_number, force_removal = false
    index = @apartments.index { |a| a.number == apartment_number }
    raise NoSuchApartmentError.new apartment_number if index.nil?
    
    apartment = @apartments[index]
    raise ApartmentOccupiedError.new apartment if !force_removal && apartment.has_tenants?

    @apartments.delete_at index
  end

  # has a total square footage, calculated from all apartments
  def total_square_footage
    @apartments.inject(0) {|sum,a| sum + a.square_footage}
  end

  # has a total monthly revenue, calculated from all apartment rents
  def total_monthly_revenue
    @apartments.inject(0) {|sum,a| sum + a.rent}
  end

  # has a list of tenants, pulled from the tenant lists of all apartments
  def all_tenants
    @apartments.map(&:tenants).flatten
  end

  # has a method to retrieve all apartments grouped by `credit_rating` 
  # (bonus: sort the groups by credit rating from `excellent` to `bad`)
  def apartments_by_average_credit_rating
    result = {excellent: [], great: [], good: [], mediocre: [], bad: []}
    @apartments.each_with_object(result) {|a,h| h[a.credit_rating] << a}
  end

  def to_s
    inspect
  end
end
