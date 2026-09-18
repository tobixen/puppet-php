# frozen_string_literal: true

Facter.add(:phpversion) do
  confine { Facter::Core::Execution.which('php') }

  setcode do
    output = Facter::Core::Execution.execute('php -v')

    unless output.nil?
      output.split("\n").first.split
            .grep(%r{^(?:(\d+)\.)(?:(\d+)\.)?(\*|\d+)}).first
    end
  end
end
