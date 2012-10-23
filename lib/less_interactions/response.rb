class Less::Response
  
  attr_accessor :status, :object
  def initialize(status, object)
    @status = status
    @object = object
  end


end
