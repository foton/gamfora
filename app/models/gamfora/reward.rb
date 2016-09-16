module Gamfora

  class Reward < ApplicationRecord
    belongs_to :action
    belongs_to :metric, class_name: "Gamfora::Metric::Any"
    #default_scope { includes(:metric) }

    
    validates :action, presence: true
    validates :metric, presence: true
    validate  :validate_value

    def value
      self.read_attribute(value_attribute)
    end  

    def <=>(other_reward)
      v=( self.metric.name <=> other_reward.metric.name )
      if v == 0
        v = ( self.joined_value <=> other_reward.joined_value )
      end  
      v
    end  

    def joined_value
      return "#{count}x #{text_value}" if count.present? && text_value.present?
      return "#{count}#{text_value}"
    end  
  
    private
 
      def validate_value
        #have some value?
        if self.value.blank?
          self.errors.add(:count, I18n.t('gamfora.reward.errors.value_is_not_set')) 
          self.errors.add(:text_value, I18n.t('gamfora.reward.errors.value_is_not_set'))
        else
          #is it valid value 'type'?
          if metric.present? && !metric.valid_value_change?(value)
            self.errors.add(:count, I18n.t("gamfora.metric.errors.value_is_not_acceptable", value: value, metric_name: metric.name))
            self.errors.add(:text_value, I18n.t("gamfora.metric.errors.value_is_not_acceptable", value: value, metric_name: metric.name))
          end
        end 
      end  

      def is_countable?
        @is_countable||=metric && metric.is_countable?
      end 

      def value_attribute
        is_countable? ? :count : :text_value
      end  
         
  end
end  

