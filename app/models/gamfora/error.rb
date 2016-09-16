module Gamfora
  class Error < StandardError
    attr_accessor :name, :message
    def initialize(message,name=nil)
      @name = name
      @message = message
    end
  end  
end  
