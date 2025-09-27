# frozen_string_literal: true

RSpec.describe CaienaOpenweathermapSdk do
  it "has a version number" do
    expect(CaienaOpenweathermapSdk::VERSION).not_to be nil
  end

  describe "#new" do
    let(:new) { described_class.new "https://api.openweathermap.org" }

    it "instantiate a client for the API" do
      expect(new).to be_a CaienaOpenweathermapSdk::Client
    end
  end
end
