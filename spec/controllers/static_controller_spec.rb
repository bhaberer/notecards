require 'spec_helper'

describe StaticController do
  it 'should return the index' do
    get 'index'
    page.should == ''
  end
end
