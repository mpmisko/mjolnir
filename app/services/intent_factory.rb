class IntentFactory
  def self.intents(snippet_array)
    return nil unless snippet_array
    response_intents = []
    all_intents_array.each do |intent|
      intent_snippets = []
      next unless check_types_intersect(snippet_array, send("necessary_#{intent}_type_set"))
      snippet_array.each do |snippet|
        intent_snippets << snippet if send("possible_#{intent}_type_set").include?(snippet[:type])
      end
      response_intents << "Intents::#{intent.capitalize}".constantize.new(intent_snippets)
    end
    return nil if response_intents.empty?
    response_intents
  end

  def self.necessary_info_type_set
    @necessary_info_set ||= %w[location time time-period date date-period contact info]
  end

  def self.possible_info_type_set
    @possible_info_set ||= necessary_info_type_set
  end

  def self.all_intents_array
    @all_intents ||= Intents::Intent.subclasses.map { |klass| klass.name.downcase.split('::')[-1] }
  end

  def self.check_types_intersect(array, keys)
    types = []
    array.each { |snippet| types << snippet[:type] }
    !(types & keys).empty?
  end

  private_class_method :check_types_intersect
end
