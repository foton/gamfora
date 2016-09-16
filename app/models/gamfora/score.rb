module Gamfora

  require_dependency "gamfora/error.rb"

  class Score < ApplicationRecord
    belongs_to :player
    belongs_to :metric, class_name: "Gamfora::Metric::Any"
    #default_scope { includes(:metric) }

    validate :check_range
    validates :player, presence: true, uniqueness: { scope: [:metric_id] , message: I18n.t("gamfora.score.errors.player_already_have_score_for_this_metric")}
    validates :metric, presence: true

    def initialize(*args)
      super
      reset_value
    end  

    def value
      self.read_attribute(value_attribute)
    end  
  
    def reset_value
      self.value= metric.start_value
    end  

    #add value to current score, with corrections dependent on metrics
    #returns new value(s) for score 
    #value is corrected against metric min_value-max_value
    def add_value(v)
      check_validity(v)
      if is_countable?
        self.value=(self.value+v)
        crop_value_to_range
      else
        self.value
      end  
    end  

    #set value for current score, with corrections dependent on metrics
    #returns new value(s) for score 
    #value is corrected against metric min_value-max_value
    def set_value(v)
      check_validity(v)
      self.value=v
      crop_value_to_range
    end  

    #substract value for current score, with corrections dependent on metrics
    #returns new value(s) for score 
    #value is corrected against metric min_value-max_value
    def substract_value(v)
      check_validity(v)
      if is_countable?
        self.value=(self.value-v)
        crop_value_to_range
      else
        self.value
      end  
    end


    private

      def is_countable?
        @is_countable||=metric.is_countable?
      end 

      def value=(v)
        self.write_attribute(value_attribute,v)
      end  

      def value_attribute
        is_countable? ? :count : :text_value
      end  

      def crop_value_to_range
        self.value=min_value if value_is_below_min?
        self.value=max_value if value_is_above_max?
        self.value
      end  

      def value_is_below_min?
        min_value && self.value < min_value
      end
      
      def value_is_above_max?
        max_value && max_value < self.value
      end  

      def check_range
        return true unless is_countable?
        self.errors.add(:value, I18n.t('gamfora.score.errors.value_is_lower_than_minimum', min: min_value)) if value_is_below_min?
        self.errors.add(:value, I18n.t('gamfora.score.errors.value_is_bigger_than_maximum', max: max_value)) if value_is_above_max?
      end  

      def check_validity(v)
        fail Gamfora::ValueIsNotAcceptableForMetricError.new(v,metric) unless metric.valid_value_change?(v)
      end  

      def max_value
        unless defined?(@max_value)
          if metric.respond_to?(:max_value) && ((maxv=metric.max_value) != Gamfora::Metric::Any::UNLIMITED)
            @max_value=maxv
          else
            @max_value=nil 
          end 
        end
        @max_value
      end  

      def min_value
        unless defined?(@min_value)
          if metric.respond_to?(:min_value) && ((minv=metric.min_value) != Gamfora::Metric::Any::UNLIMITED)
            @min_value=minv
          else
            @min_value=nil 
          end 
        end
        @min_value  
      end  

  end
end  

