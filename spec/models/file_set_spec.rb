require 'rails_helper'

describe FileSet do
  subject { described_class.new }
  it "has assignable legacy properties" do
    is_expected.to respond_to :legacy_pid
    is_expected.to respond_to :legacy_pid=
    is_expected.to respond_to :legacy_state
    is_expected.to respond_to :legacy_state=
  end
end
