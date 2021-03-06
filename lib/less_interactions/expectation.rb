# Verifies that some conditions are met for a member of a parameters hash
module Less
  class Expectation
    attr_reader :parameter
    def initialize parameter, options = {}
      @parameter = parameter
      @allow_nil = options[:allow_nil]
    end

    def verify(params)
      unless verifies_expectations?(params)
        raise MissingParameterError, "Parameter empty  :#{@parameter}"
      end
    end

    def allows_nil?
      @allow_nil
    end    

    private

    def verifies_expectations?(params)
      if @allow_nil == nil || @allow_nil == false
        params.has_key?(@parameter) && params[@parameter] != nil
      else
        true
      end
    end
  end
  class MissingParameterError < StandardError; end
end


