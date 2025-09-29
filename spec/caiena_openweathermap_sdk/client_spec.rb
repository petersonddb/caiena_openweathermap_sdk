# frozen_string_literal: true

require "rspec"

RSpec.describe CaienaOpenweathermapSdk::Client do
  let(:base_uri) { "https://api.openweathermap.org" }
  let(:client) { described_class.new base_uri }

  describe "#current_temperature" do
    let(:params) { { q: "anywhere", appid: "anything", units: "metric" } }
    let(:current_temperature) { client.current_temperature params[:q], params[:appid] }

    let(:current_weather) { "#{base_uri}/data/2.5/weather" }

    context "when open weather respond successfully" do
      before(:each) do
        stub_request(:get, current_weather)
          .to_return_json(body: { main: { temp: 24.11 } }, status: 200)
          .with(query: params)
      end

      it "return current temperature for the given location" do
        expect(current_temperature).to be_a Float
      end
    end

    context "when open weather respond with error" do
      before(:each) do
        stub_request(:get, current_weather)
          .to_return_json(body: { message: "mocked error" }, status: 500)
          .with(query: params)
      end

      it "raise the error" do
        expect { current_temperature }.to raise_error CaienaOpenweathermapSdk::OpenweathermapError, /mocked error/i
      end
    end

    context "when the request to open weather fails" do
      before(:each) do
        stub_request(:get, current_weather)
          .to_raise(StandardError.new("mocked error"))
          .with(query: params)
      end

      it "raise the error" do
        expect { current_temperature }.to raise_error CaienaOpenweathermapSdk::ClientError, /mocked error/i
      end
    end
  end
end
