
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

      ex = self.class.expectations.dup
      n = ex.keep_if {|name, allow_nil| allow_nil.has_key?(:allow_nil) && allow_nil[:allow_nil]}
      nils = {}
      n.each do |name, val|
        nils[name] = nil
      end
      nils.merge(options).each do |name, value|
        instance_variable_set "@#{name}", value
        if respond_to?( "#{name}=" ) && !value.nil?
          send "#{name}=", value
        end
      end
    end

    attr_reader :context

    # Definition of the interaction itself. You should override this in your interactions
    #
    # The default implementation raises an {InvalidInteractionError}
    def run
      raise InvalidInteractionError, "You most override the run instance method in #{self.class}"
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
      me.init
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
      parameters.each do |param|
        methods = (self.instance_methods + self.private_instance_methods)
        self.send(:attr_reader, param.to_sym) unless methods.member?(param.to_sym)
        add_expectation(param, options)
      end
    end



    private

    def self.add_expectation(parameter, options)
      expectations[parameter] = options
    end

    def expectations_met?
      self.class.expectations.each do |param, param_options|
        unless param_options[:allow_nil]
          raise MissingParameterError, "Parameter empty   :#{param.to_s}" if instance_variable_get("@#{param}").nil?
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
