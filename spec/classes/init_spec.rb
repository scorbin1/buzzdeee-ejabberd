require 'spec_helper'
describe 'ejabberd' do

  context 'with defaults for all parameters' do
    it { should contain_class('ejabberd') }
  end
end
