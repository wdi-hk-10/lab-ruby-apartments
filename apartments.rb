class Tenant
  attr_accessor :name, :age, :credit_score

  def initialize(name, age, credit_score)
    @name = name
    @age = age
    @credit_score = credit_score
  end

  def credit_rating
    case @credit_score
      when 0..559
        "bad"
      when 560..659
        "mediocre"
      when 660..724
        "good"
      when 725..759
        "great"
      else
        "excellent"
    end
  end
end

class Building
  attr_accessor :address
  attr_reader :apartments
  def initialize(address)
    @address    = address
    @apartments = []
  end

  def new_apartment(apartment)
    @apartments.push apartment
  end

  def destroy_apartment(apartment_number)
    index = @apartments.index {|apt| apt.number == apartment_number}
    if index
      @apartments.delete_at(index)
    else
      raise "apartment does not exist"
    end
end

