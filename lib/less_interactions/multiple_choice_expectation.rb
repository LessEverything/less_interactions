#TODO ExpectationCollection.new(:name, :age, :weight)
# :nodoc:
module  Less
  class MultipleChoiceExpectation 
    attr_reader :parameters
    
    def initialize parameters 
      @parameters = parameters
    end

    def verify(hash_to_verify)
      unless verifies_expectations?(hash_to_verify)
        raise MissingParameterError, "Parameters empty #{@parameters.map(&:to_sym)} (At least one of these must not be nil)"
      end
    end

    def verifies_expectations?(hash_to_verify)
      valid = @parameters.any? do |parameter|
        hash_to_verify.has_key?(parameter) && !hash_to_verify[parameter].nil?
      end
      return valid
    end

    def all_params_are_not_nil?(hash_to_verify)
      hash_to_verify.any? do |k,v|
        v.nil?
      end
    end
  end

  class MissingParameterError < StandardError; end
end