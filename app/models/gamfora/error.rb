module Gamfora
  class Error < StandardError
    attr_accessor :message
    def initialize(message)
      @message = message
    end
  end  

  class ValueIsNotAcceptableForMetricError < Gamfora::Error
    def initialize(value,metric)
      @message=I18n.t("gamfora.metric.errors.value_is_not_acceptable", value: value, metric_name: metric.name)
    end  
  end
end  
