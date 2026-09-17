# frozen_string_literal: true

require 'spec_helper'

describe 'phpversion fact' do
  subject(:fact) { Facter.fact(:phpversion).value }

  before do
    Facter.clear
    load File.expand_path('../../../lib/facter/phpversion.rb', __dir__)
  end

  after { Facter.clear }

  context 'when php is installed' do
    before do
      allow(Facter::Core::Execution).to receive(:execute).with('php -v', any_args).and_return(
        "PHP 8.2.7 (cli) (built: Jun  8 2023 20:03:25) (NTS)\n" \
        "Copyright (c) The PHP Group\n" \
        "Zend Engine v4.2.7, Copyright (c) Zend Technologies\n",
      )
    end

    it { is_expected.to eq '8.2.7' }
  end

  context 'when php is not installed' do
    before do
      allow(Facter).to receive(:log_exception).and_call_original
      allow(Facter::Core::Execution).to receive(:execute).with('php -v', any_args) do |_command, options = {}|
        on_fail = options.fetch(:on_fail, :raise)
        raise Facter::Core::Execution::ExecutionFailure, "Could not execute 'php -v': command not found" if on_fail == :raise

        on_fail
      end
    end

    it 'resolves to nil without logging an exception' do
      expect(fact).to be_nil
      expect(Facter).not_to have_received(:log_exception)
    end
  end
end
