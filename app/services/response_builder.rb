require 'intent_factory.rb'

class ResponseBuilder
  def self.new_phone_response(id, ai_responses)
    mobile_response = []
    ai_responses.each do |response|
      snippet_response = parse_entities(response.dig(:result, :parameters))
      intents = IntentFactory.intents(snippet_response)
      if intents.nil?
        mobile_response << {}
      else
        intents_descriptions = []
        intents.each { |intent| intents_descriptions << intent.describe }
        mobile_response << { intents: intents_descriptions }
      end
    end
    Rails.logger.info "Response: #{mobile_response.to_s}"
    { id: id, results: mobile_response }
  end

  def self.parse_entities(entities)
    return nil unless entities
    mobile_snippet_array = []
    entities.each do |type, content|
      next if content.empty?
      content.each do |content_part|
        mobile_snippet_array << snippetize(type: type.to_s, data: content_part)
      end
    end
    mobile_snippet_array
  end

  def self.snippetize(entity)
    snippet = {}
    ai_to_summapp_types.each do |type_summapp, type_ai|
      next unless type_ai.include?(entity[:type])
      snippet = { type: type_summapp, data: entity[:data] }
      break
    end
    snippet
  end

  def self.ai_to_summapp_types
    @map ||= { 'location' => %w[address geo-city geo-country location],
               'time' => %w[time],
               'time-period' => %w[time-period],
               'date' => %w[date],
               'date-period' => %w[date-period],
               'contact' => %w[email given-name last-name number phone-number],
               'info' => %w[unit-currency url] }
  end
  private_class_method :parse_entities, :snippetize, :ai_to_summapp_types
end
