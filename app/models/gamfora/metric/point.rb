module Gamfora
  module Metric
    #basic metric for values which can be count (link to integers)
    #`game`, `name` and `start_value` is required
    #`min_value` and `max_value` are accepted
    class Point < Gamfora::Metric::Base
      before_validation :values_to_json

      validates :values_json, presence: true
      validate :validate_start_value_is_set
      validate :validate_start_value_between_min_and_max

      def is_countable?
        true
      end  

      def valid_value_change?(v)
        v.is_a?(Numeric) #no check for min max, done at score
      end  

      def values
        unless defined? @values
          if values_json.present? && values_json != "null"
            @values=JSON.parse(values_json).symbolize_keys
          else
            @values={start: nil, min: UNLIMITED, max: UNLIMITED}
          end  
        end  
        @values
      end  

      def start_value
        values[:start]
      end

      def start_value=(v)
        values[:start]=to_acceptable_value(v)
      end
      
      def max_value
        values[:max]
      end

      def max_value=(v)
        values[:max]=(to_acceptable_value(v) || UNLIMITED)
      end

      def min_value
        values[:min]
      end

      def min_value=(v)
        values[:min]=(to_acceptable_value(v) || UNLIMITED )
      end

      private

        def validate_start_value_is_set
          self.errors.add(:values,I18n.t("gamfora.metric.point.errors.start_value_is_not_present")) unless start_value.is_a? Integer
        end  

        def validate_start_value_between_min_and_max
          self.errors.add(:values,I18n.t("gamfora.metric.point.errors.start_value_is_above_max")) if max_value != UNLIMITED && (max_value < start_value)
          self.errors.add(:values,I18n.t("gamfora.metric.point.errors.start_value_is_bellow_min")) if min_value != UNLIMITED && (start_value < min_value)
        end  

        def values_to_json
          self.values_json=@values.to_json
        end  

        def to_acceptable_value(v)
          return v if v.is_a? Integer

          if v.is_a? String
            if (v.to_i == 0)
              #could be "0" or "bflmpsvz"
              return 0 if v.include?("0")
            else  
              return v.to_i 
            end  
          end  
          
          return nil
        end  

    end  
  end
end    
