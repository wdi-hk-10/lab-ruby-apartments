class CreditScoreError < Exception
end

class BadTenantCreditError < Exception
end

class NotEnoughRoomError < Exception
end

class NoSuchTenantError < Exception
end

class NoSuchApartmentError < Exception
end

class ApartmentIsOccupiedError < Exception
end

def calculate_credit_rating credit_score
    case credit_score
    when 0..559
        :Bad
    when 560..659
        :Mediocre
    when 660..724
        :Good
    when 725..759
        :Great
    else
        :Excellent
    end
end

class Building
    attr_reader :address

    def initialize address
        @address = address
        @apartments = []
        @total_sqr_ft = (apartment.sqr_ft).reduce(:+)
        @total_revenue = (apartment.rent).reduce(:+)
        @all_tenants = (apartment.tenant)

    def add_apartment apartment
        @apartments << apartment
    end

    def apartments
        @apartments.dup
    end

    def credit_separate apartments
    end

    def remove_apartment apartment_number, force_removal=false
        index = @apartments.index { |a| a.number == apartment_number}
        raise NoSuchApartmentError.new apartment_number if index.nil?
        apartment = @apartments[index]
        raise ApartmentIsOccupiedError.new if !force_removal && apartment.has_tenants?
        @apartment.delete_at(index)
    end
end

class Tenant
    attr_reader :name, :age, :credit_score

    def initialize name, age, credit_score
        @name            = name
        @age             = age
        if credit_score < 0
            raise CreditScoreError.new 'Score cannot be negative'
        elsif credit_score > 800
            raise CreditScoreError.new 'Score cannot be greater than 800'
        else
            @credit_score = credit_score
        end
    end

    def credit_rating
    end
end

begin
    rob = Tenant.new('Rob', 45, -20)
rescue Exception => e
    p e
end

class Apartment
    attr_reader :number, :rent, :sqr_ft
    def initialize number, rent, sqr_ft, num_of_bedrooms, num_of_bath
        @number = number
        @rent = rent
        @sqr_ft = sqr_ft
        @num_of_bedrooms = num_of_bedrooms
        @num_of_bath = num_of_bath

        @tenants = []
    end

    def add_tenant tenant
        raise BadTenantCreditError.new tenant if tenant.credit_rating == :Bad
        raise NotEnoughRoomError.new tenant if tenants.length == num_of_bedrooms
        @tenants << tenant
    end

    #tenant can be an object or a name
    def remove_tenant tenant
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

    def remove_tenants
        @tenants.clear # can also replace with an empty array []
    end

    def average_credit
        # @tenants.inject(0){|sum,t| sum + t.credit_score}.to_f / tenants.length
        # @tenants.map{|t| t.credit_score}.reduce(:+).to_f / @tenants.length
        @tenants.map(&:credit_score).reduce(:+).to_f / tenants.length
    end

    def credit_rating
        calculate_credit_rating(average_credit_score)

    end

    def is_vacant?
        @tenants.present?
    end
end
