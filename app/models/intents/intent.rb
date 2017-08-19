module Intents
  class Intent
    attr_reader :snippets

    def initialize(array_of_snippets)
      @snippets = array_of_snippets
    end

    def message
      raise 'not implemented'
    end

    def describe
      raise 'not implemented'
    end
  end
end
