
module Less
  class Interaction
    # Initialize the objects for an interaction. You should override this in your interactions. 
    # @param [Hash] options   The options are passed when running an interaction
    def initialize(options = {})
      options.each do |name, value|
        instance_variable_set "@#{name}", value
        self.class.send(:define_method, name) {value}
      end
    end

    # Definition of the interaction itself. You should override this in your interactions
    #
    # The default implementation raises an {InvalidInteractionError}
    def run
      raise InvalidInteractionError, "You most override the run instance method in #{self.class}"
    end

    # Run your interaction.
    # @param [Hash] options   
    #
    # This will initialize your interaction with the options you pass to it and then call its {#run} method.
    def self.run(options = {})
      raise InvalidInteractionError, "Every interaction must be initialized with an options hash" unless options.is_a?(Hash)
      me = new(options)
      raise MissingParameterError unless me.send :expectations_met?
      me.run
    end

    # Expect certain parameters to be present. If any parameter can't be found, a {MissingParameterError} will be raised. 
    # @overload expects(*parameters)
    #   @param *parameters A list of parameters that your interaction expects to find. 
    # @overload expects(*parameters, options)
    #   @param *parameters A list of parameters that your interaction expects to find. 
    #   @param options A list of options for the exclusion
    #   @option options :allow_nil Allow nil values to be passed to the interaction, only check to see whether the key has been set
 
    def self.expects(*parameters)
      if parameters.last.is_a?(Hash)
      	options = parameters.pop
            else
      	options = {}
      end
      parameters.each { |param| add_expectation(param, options) }
    end
    
    private

    def self.add_expectation(parameter, options)
      expectations[parameter] = options
    end

    def expectations_met?
      self.class.expectations.each do |param, param_options|
      	if param_options[:allow_nil]
      	  raise MissingParameterError, "Parameter not passed   :#{param.to_s}" unless instance_variable_defined? "@#{param}"
      	else
      	  raise MissingParameterError, "Paramter empty   :#{param.to_s}" if instance_variable_get("@#{param}").nil?
      	end
      end
    end

    def self.expectations
      @expectations ||= {}
    end
  end

  class InvalidInteractionError < StandardError; end
  class MissingParameterError < StandardError; end
end
