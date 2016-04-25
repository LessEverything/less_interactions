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
      @params = options
      @params.each do |name, value|
        instance_variable_set "@#{name}", value
      end
    end

    attr_reader :context

    # Definition of the interaction itself. You should override this in your interactions
    #
    # The default implementation raises an {InvalidInteractionError}
    def run
      raise InvalidInteractionError, "You must override the run instance method in #{self.class}"
    end

    def init
    end

    # Run your interaction.
    # @param [Object] context
    # @param [Hash] options
    #
    # This will initialize your interaction with the options you pass to it and then call its {#run} method.
    def self.run(context = {}, options = {})
      me = new(context, options)
      me.send :expectations_met?
      me.init
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

      parameters.each do |parameter|
        add_reader(parameter)
        add_expectation(parameter, options)
      end
    end

    def self.expects_any *parameters
      parameters.each do |parameter|
        add_reader(parameter)
      end
      add_any_expectation(parameters)
    end



    private

    def self.add_reader param
      methods = (self.instance_methods + self.private_instance_methods)
      self.send(:attr_reader, param.to_sym) unless methods.member?(param.to_sym)
    end

    def self.add_expectation(parameter, options)
      ex = Expectation.new(parameter, options)
      if expectations.none? { |e| e.parameter == parameter }
        expectations << ex
      end
    end

    def self.add_any_expectation(parameters)
      new_ex = MultipleChoiceExpectation.new(parameters)
      if any_expectations.none? {|ex| ex.parameters == new_ex.parameters }
        any_expectations << new_ex
      end
    end

    def expectations_met?
      __expects_mets? && __expects_any_mets?
    end

    def __expects_any_mets?
      self.class.any_expectations.each do |expectation|
        expectation.verify(@params)
      end
      true
    end

    def __expects_mets?
      self.class.expectations.each do |expectation|
        expectation.verify(@params)
      end
      true
    end

    def self.any_expectations
      @any_expectations ||= []
    end

    def self.expectations
      @expectations ||= []
    end
  end


  class InvalidInteractionError < StandardError; end
end
