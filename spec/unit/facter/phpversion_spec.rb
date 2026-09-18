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
      allow(Facter::Core::Execution).to receive(:which).with('php').and_return('/usr/bin/php')
      allow(Facter::Core::Execution).to receive(:execute).with('php -v').and_return(
        "PHP 8.2.7 (cli) (built: Jun  8 2023 20:03:25) (NTS)\n" \
        "Copyright (c) The PHP Group\n" \
        "Zend Engine v4.2.7, Copyright (c) Zend Technologies\n",
      )
    end

    it { is_expected.to eq '8.2.7' }
  end

  context 'when php is not in the path' do
    before do
      allow(Facter::Core::Execution).to receive(:which).with('php').and_return(nil)
      allow(Facter::Core::Execution).to receive(:execute)
    end

    it 'resolves to nil without running php' do
      expect(fact).to be_nil
      expect(Facter::Core::Execution).not_to have_received(:execute)
    end
  end
end
