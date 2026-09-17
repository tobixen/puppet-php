# frozen_string_literal: true

Facter.add(:phpversion) do
  setcode do
    output = Facter::Core::Execution.execute('php -v', on_fail: nil)

    unless output.nil?
      output.split("\n").first.split
            .grep(%r{^(?:(\d+)\.)(?:(\d+)\.)?(\*|\d+)}).first
    end
  end
end
