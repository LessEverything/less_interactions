
module Less
  class Interaction
    # Initialize the objects for an interaction. 
    # @param [Object] context The context for running an interaction. Optional param.
    # @param [Hash] options   The options are passed when running an interaction. Optional param.
    def initialize(context = {}, options = {})
      #the param context = {} is to allow for interactions with no context
      if context.is_a? Hash
        options.merge! context #context is not a Context so merge it in
      else
        options[:context] = context # add context to the options so will get the ivar and getter
      end
      
      param_exp = self.class.param_expectations.dup
      n = param_exp.keep_if {|name, allow_nil| allow_nil.has_key?(:allow_nil) && allow_nil[:allow_nil]}
      nils = {}
      n.each do |name, val|
        nils[name] = nil
      end
      nils.merge(options).each do |name, value|
        instance_variable_set "@#{name}", value
        eval "def #{name}; instance_variable_get :@#{name}; end"
      end
    end
    
    

    # Definition of the interaction itself. You should override this in your interactions
    #
    # The default implementation raises an {InvalidInteractionError}
    def run
      raise InvalidInteractionError, "You most override the run instance method in #{self.class}"
    end

    # Run your interaction.
    # @param [Object] context   
    # @param [Hash] options   
    #
    # This will initialize your interaction with the options you pass to it and then call its {#run} method.
    def self.run(context = {}, options = {})
      me = new(context, options)
      me.send :verify_param_expectations_met?
      return_values = me.run
      me.send :verify_return_expectations_met?, return_values
      return return_values
    end

    # Expect certain parameters to be passed in. If any parameter can't be found, a {MissingParameterError} will be raised.
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
      parameters.each { |param| add_param_expectation(param, options) }
    end

    # Expect certain values to be returned in the response. If the response isn't a hash or if it is and a
    # parameter can't be found a {MissingReturnValueError} wil be raised
    # @overload expects(*values)
    #   @param *values A list of values that you expect your interaction to return.
    # @overload expects(*values, options)
    #   @param *parameters A list of values that you expect your interaction to return.
    #   @param options A list of options for the exclusion
    #   @option options :allow_nil Allow nil values to be returned from aninteraction, only check to see whether the key has been set
    def self.returns(*values)
      if values.last.is_a?(Hash)
        options = parameters.pop
      else
        options = {}
      end
      values.each { |val| add_return_expectation(val, options) }
    end
    
    
    private

    def self.add_param_expectation(parameter, options)
      param_expectations[parameter] = options
    end

    def self.add_return_expectation(parameter, options)
      return_expectations[parameter] = options
    end

    def verify_param_expectations_met?
      self.class.param_expectations.each do |param, param_options|
        unless param_options[:allow_nil]
          raise MissingParameterError, "Parameter empty   :#{param.to_s}" if instance_variable_get("@#{param}").nil?
        end
      end
    end

    def verify_return_expectations_met?(returned_values)
      return if self.class.return_expectations.empty?
      raise MissingReturnValueError unless returned_values.is_a?(Hash)
      self.class.return_expectations.each do |name, options|
        raise MissingReturnValueError, "Expected the interaction to return a hash" unless returned_values.has_key?(name)
        raise MissingReturnValueError, "Return value empty    :#{name.to_s}" unless returned_values[name] || options[:allow_nil]
      end
    end

    def self.param_expectations
      @param_expectations ||= {}
    end

    def self.return_expectations
      @return_expectations ||= {}
    end
  end


  class InvalidInteractionError < StandardError; end
  class MissingParameterError < StandardError; end
  class MissingReturnValueError < StandardError; end
end
