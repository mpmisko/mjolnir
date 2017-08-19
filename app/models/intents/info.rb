module Intents
  class Info < Intent
    def message
      ''
    end

    def describe
      { type: 'info',
        title: message,
        snippets: @snippets }
    end
  end
end
