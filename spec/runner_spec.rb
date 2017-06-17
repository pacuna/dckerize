require 'spec_helper' 
describe Dckerize::Runner do

  let(:runner) {
    Dckerize::Runner.new(['up', 'myapp'])
  }

  let(:invalid_runner_without_up) {
    Dckerize::Runner.new(['something', 'myapp'])
  }

  after(:each) do
    clean_files
  end

  describe '#initialize' do
    context 'valid runner' do
      it 'should initialize correctly' do
        expect(runner).to be_valid
      end
    end

    context 'invalid runner' do
      it 'should be invalid without up' do
        expect(invalid_runner_without_up).to_not be_valid
      end

    end
  end

  describe '#execute' do
    context 'valid runner' do
      it 'should not raise error' do
        expect{ runner.execute }.to_not raise_error
      end
    end

    context 'invalid runner' do
      it 'should raise error without up as first option' do
        expect{ invalid_runner_without_up.execute }.to raise_error Dckerize::Runner::ERROR_MESSAGE
      end

    end
  end
end
