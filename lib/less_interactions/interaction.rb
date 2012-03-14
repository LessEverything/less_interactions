module Less
  class Interaction
    # Initialize the objects for an interaction. You should override this in your interactions. 
    # @param [Hash] options   The options are passed when running an interaction
    def initialize(options = {})
    end

    # Definition of the interaction itself. You should override this in your interactions
    #
    # The default implementation raises an InvalidInteractionError
    def run
      raise InvalidInteractionError, "You most override the run instance method in #{self.class}"
    end

    # Run your interaction.
    # @param [Hash] options   
    #
    # This will initialize your interaction with the options you pass to it and then call its 'run' method.
    def self.run(options = {})
      raise InvalidInteractionError, "Every interaction must be initialized with an options hash" unless options.is_a?(Hash)
      self.new(options).run
    end
  end

  class InvalidInteractionError < StandardError; end
end
