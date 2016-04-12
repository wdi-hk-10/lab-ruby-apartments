class CreditScoreError < Exception
end

class BadCreditRatingError < Exception
end

class NotEnoughBedroomError < Exception
end

class NoSuchTenantError < Exception
end

class NoSuchApartmentError < Exception
end

class Tenant
  def initialize name, age, credit_score
    @name = name
    @age = age
    if credit_score < 0
      raise CreditScoreError "Credit score cannot be negative."
    elsif credit_score > 800
      raise CreditScoreError "Credit score cannot be greater than 800."
    else @credit_score = credit_score
  end

  def credit_rating
    case credit_score
    when 0..559
      :bad
    when 560..659
      :mediocre
    when 660..724
      :good
    when 725..759
      :great
    when 760..800
      :excellent
    else
      p "Incorrect input."
    end
  end
end

begin
  judah = Tenant.new("Judah", 27, 740)
rescue Exception => e
  p e
end

class Apartment
  attr_reader :number, :rent, :square_footage, :number_of_bedrooms, :number_of_bathrooms

  def initialize number, rent, square_footage, number_of_bedrooms, number_of_bathrooms
    @number = number
    @rent = rent
    @square_footage = square_footage
    @number_of_bedrooms = number_of_bedrooms
    @number_of_bathrooms = number_of_bathrooms
    @avg_credit_score = avg_credit_score
    @overall_credit_rating = overall_credit_rating

    @tenants = []
  end

  def add_tenant
    if tenant.credit_rating == :bad
      raise BadCreditRatingError.new tenant
    end

    raise NotEnoughBedroomError.new tenant if tenants.length == number_of_bedrooms

    tenants << tenant
  end

  def remove_tenant tenant
    if tenant.to_s == tenant
      index = @tenants.index{ |t| t.name == tenant }
      if index.nil?
        not_found = true
      else
        tenants.delete_at index
      end
    else
      deleted = tenants.delete tenant
      not_found = deleted.nil?
    end

    raise NoSuchTenantError.new tenant if not_found
  end

  def avg_credit_score
    @tenants.inject{ |sum, t| sum + (t.credit_score / @tenants.size) }.to_i
  end

  def overall_credit_rating
    case avg_credit_score
    when 0..559
      :bad
    when 560..659
      :mediocre
    when 660..724
      :good
    when 725..759
      :great
    when 760..800
      :excellent
    else
  end

end

class Building
  attr_accessor :address
  attr_reader :apartments

  def initialize address, number_of_apartments
    @address = address
    @number_of_apartments = number_of_apartments
    @total_square_footage = total_square_footage
    @total_monthly_revenue = total_monthly_revenue

    @apartments = []
  end

  def add_apartment
    apartments << apartment
  end

  def remove_apartment number
    if number.to_n == number
      index = @apartments.index{ |a| a.number == number }
      if index.nil?
        not_found = true
      else
        apartments.delete_at index
      end
    else
      deleted = apartments.delete apartment
      not_found = deleted.nil?
    end

    raise NoSuchApartmentError.new number if not_found
  end

  def total_square_footage
    @apartments.inject{ |sum, a| sum + a.square_footage }.to_i
  end

  def total_monthly_revenue
    @apartments.inject{ |sum, r| sum + r.rent }.to_i
  end

  def tenant_list
    tenant_list = ([].concat(apartments.each(:tenants))).sort_by(&:name)
  end
end
