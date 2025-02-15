require 'spec_helper'
describe 'ejabberd' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('ejabberd') }
  end
end
