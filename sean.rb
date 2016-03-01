class BadCreditRatingError < Exception
end

class NotEnoughBedroomsError < Exception
end

class NoSuchTenantError < Exception
end

class NoApartmentError < Exception
end

class ApartmentOccupiedError < Exception
end

def calculate_credit_rating average_credit_score
  if score > 760
    :excellent
  elsif score > 725
    :great
  elsif score > 660
    :good
  elsif score > 560
    :mediocre
  else
    :bad
  end
end

class Building
  # has an address
  # the list of apartments should not be modified directly
  attr_reader :apartment_list, :address

  def initialize address
    @address = address
    @apartment_list = []
  end

  def add_apartment apartment
  # has a method to add an apartment
    @apartment_list << apartment
  end

  def remove_apartments apartmentnumber force_removal=false
    # has a method to remove a specific apartment by its number, which raises an error if the number is not found or the apartment currently has any tenants (bonus: allow overriding this constraint)
    index = @apartments.index {|a| a.number == apartmentnumber}


    raise NoApartmentError.new apartmentnumber if index.nil?

    apartment = @apartments[index]
    raise ApartmentOccupiedError.new if !force_removal && apartment.has_tenants?

    @apartments.delete_at(index)
  end

  def total_square_feet sqft
    @apartment_list.inject(0) {|sum, a| sum + a.sqft}
  end

  def total_monthly_revenue
    @apartment_list.inject(0) {|sum, a| sum + a.rent}
  end

  def all_tenants
    # has a list of tenants, pulled from the tenant lists of all apartments

    # @apartment_list.map{|a| a.tenants}.flatten
    @apartment_list.map(&:tenants).flatten
  end

  def retrieve_apartments
     # retrieve all apartments grouped by average_credit_score

     result = {bad: [], mediocre: [], good: [], great: [], excellent: []}
     @apartment_list.each_with_object(result) {|a, result| result[a.credit_rating] << a}
  end
end



class Apartment
  attr_reader :number, :rent, :tenants, :sqft, :bedrooms, :bathrooms

  def initialize number, rent, sqft, bedrooms, bathrooms
    @number = Building.apartment_list.count+1
    @rent = rent
    @sqft = sqft
    @bedrooms = bedrooms
    @bathrooms = bathrooms
    @tenants = []
  end

  def add_tenant tenant
    raise BadCreditRatingError.new tenant if tenant.credit_rating == "bad"
    raise NotEnoughBedroomsError.new tenant if tenants.count == bedrooms
    @tenants << tenant
  end

  def remove_tenant tenant
    if tenant.to_s == tenant #if tenant is tenant.name
      index = @tenants.index { |t| t.name == tenant}
      if index.nil?
        not_found = true
      else
        @tenants.delete_at index
      end
    else #if tenant is the object reference
      deleted = @tenants.delete tenant
      not_found = deleted.nil?
    end
  end

  def remove_all_tenants
    @tenants.clear
  end

  def average_credit_score
    @tenants.inject(0) {|sum, t| sum + t.score}.to_f / @tenants.length
  end

  def credit_rating
    calculate_credit_rating average_credit_score
  end

  def has_tenants?
    @tenants.any?
  end
end

class Tenant
  attr_reader :name, :age, :score

  def initialize name, age, score
    @name = name
    @age = age
    @score = score
  end

  def credit_rating
    calculate_credit_rating score
  end

end

t1 = Tenant.new 'Sean',25,700
p t1.credit_rating