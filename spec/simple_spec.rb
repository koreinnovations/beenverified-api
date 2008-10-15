class BeenVerifiedApi
  def awesome?
    true  
  end
end


describe BeenVerifiedApi do 
  it 'should be awesome' do 
    BeenVerifiedApi.new.should be_awesome
  end
end