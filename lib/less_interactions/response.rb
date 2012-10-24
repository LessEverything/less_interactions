class Less::Response
  
  attr_accessor :status, :object
  def initialize(status, object)
    @status = status
    @object = object
  end
  
  def success?
    (200..299).cover? status
  end
  
  def error?
    !success?
  end
  
  def client_error?
    (400..499).cover? status
  end
  
  def server_error?
    (500..599).cover? status
  end


end
