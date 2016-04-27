module Less
  class ExpectationArray < Array
    
    def verify!(all_params)
      self.each do |expectation|
        expectation.verify(all_params)
      end
    end

  end
end
