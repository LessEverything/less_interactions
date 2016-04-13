# Verifies that some conditions are met for a member of a parameters hash
module Less
  class Expectation

    def initialize parameter, options = {}
      @parameter = parameter
      @allow_nil = options[:allow_nil]
    end


    def verify(params)
      if @allow_nil == nil || @allow_nil == false
        params.has_key?(@parameter) && params[@parameter] != nil
      else
        params.has_key?(@parameter)
      end
    end
  end
end