class CreditScoreError < Exception
end

class BadCreditScoreError < Exception
end

class ApartmentIsFullError < Exception
end

class ApartmentNotFound < Exception
end

def calculate_credit_rating credit_score
  case credit_score
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

class Building
  attr_reader :address

  def initialize address
    @address = address
    @apartments = []
  end

# To provide back a duplicate of the array to your user
  # def apartments
  #   @apartments.dup
  # end

  def add_apartment apartment
    @apartments << apartment
  end

  def remove_apartment apartment_number, force=false
    index = @apartments.index {|a| a.number == apartment_number}
    raise ApartmentNotFound.new "Apartment not found" if index.nil?
    apartment = @apartments[index]
    raise ApartmentOccupiedError.new "Apartment has tenants" if apartment.has_tenants? && !force
    @apartments.delete_at (index)
  end

  def total_square_footage
    @apartments.inject(0) {|sum, a| sum + a.square_foot}
  end

  def total_monthly_revenue
    @apartments.inject(0) {|sum, a| sum + a.rent}
  end

  def all_tenants
    # @apartments.map {|a| a.tenants}.flatten
    @apartments.map(&:tenants).flatten
  end

  def apartments_by_average_credit_rating
    result = {bad:[], mediocre: [], good: [], great: [], excellent: []}
    @apartments.each_with_object(result) {|a, result| result[a.credit_rating] << a}
  end
end

class Apartment
  attr_reader :number, :rent, :square_foot, :num_bed, :num_bath, :tenants

  def initialize number, rent, square_foot, num_bed, num_bath
    @number = number
    @rent = rent
    @square_foot = square_foot
    @num_bed = num_bed
    @num_bath = num_bath
    @tenants = []
  end

  def add_tenant tenant
    raise BadCreditScoreError.new "Bad credit score" if tenant.credit_rating == :bad
    raise ApartmentIsFullError.new "Apartment is full" if @tenants.length == :num_bed
    @tenants << tenant
  end

  def remove_tenant tenant
    if tenant.to_s == tenant
      index = @tenants.index {|t| t.name == tenant}
      if index.nil?
        not_found=true
      else
        @tenants.delete_at (index)
      end
    else
      deleted = @tenants.delete tenant
      not_found = deleted.nil?
    end
  end

  def remove_tenants
    @tenants.clear
  end

  def average_credit_score
    @tenants.inject(0) {|sum,t| sum + t.credit_score}.to_f / @tenants.length
  end

  def average_credit_rating
    calculate_credit_rating (average_credit_score)
  end

  def has_tenants?
    !@tenants.empty?
    # @tenants.any?
    # @tenants.length>0
  end
end

class Tenant
  attr_reader :name, :age, :credit_score

  def initialize name, age, credit_score
    @name = name
    @age = age
    raise CreditScoreError.new "Score cannot be negative" if credit_score <0
    raise CreditScoreError.new "Score cannot be larger than 800" if credit_score>800
    @credit_score = credit_score
  end

  def credit_rating
    calculate_credit_rating (credit_score)
  end
end

begin
  tenant1 = Tenant.new("Jon", 25, 600)
  tenant2 = Tenant.new("Jacob", 50, 700)

  apartment1 = Apartment.new 5, 50, 500, 5, 2
  apartment2 = Apartment.new 4, 40, 400, 4, 3
  apartment1.add_tenant tenant1
  apartment1.add_tenant tenant2

  building1 = Building.new "TipTop"
  building1.add_apartment apartment1
  p building1.all_tenants
  # p building1
  # building1.remove_apartment apartment1
  # p building1
rescue Exception => e
  p e
end

