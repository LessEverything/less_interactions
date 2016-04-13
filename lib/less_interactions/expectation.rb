# Verifies that some conditions are met for a member of a parameters hash
class Expectation

  def initialize parameter, options = {}
    @parameter = parameter
    @allow_nil = options[:allow_nil]
  end


  def verify(params)
    params.has_key?(@parameter) && params[@parameter] != nil
  end
end



