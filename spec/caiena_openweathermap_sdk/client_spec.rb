# frozen_string_literal: true

require "rspec"

RSpec.describe CaienaOpenweathermapSdk::Client do
  let(:base_uri) { "https://api.openweathermap.org" }
  let(:client) { described_class.new base_uri }

  describe "#current_temperature" do
    let(:params) { { q: "poços de caldas", appid: "anything", units: "metric" } }
    let(:current_temperature) { client.current_temperature params[:q], params[:appid] }

    let(:current_weather) { "#{base_uri}/data/2.5/weather" }

    context "when open weather respond successfully" do
      before(:each) do
        stub_request(:get, current_weather)
          .to_return_json(body: { main: { temp: 24.11 } }, status: 200)
          .with(query: params)
      end

      it "return current temperature for the given location" do
        expect(current_temperature).to eq 24.11
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

  describe "#forecast" do
    let(:params) { { q: "poços de caldas", appid: "anything", units: "metric" } }
    let(:forecast) { client.forecast params[:q], params[:appid] }

    let(:five_day_forecast) { "#{base_uri}/data/2.5/forecast" }

    context "when open weather respond successfully" do
      let(:response_body_mock) do
        {
          "list" => [
            { "dt" => 1_759_179_600, "dt_txt" => "2025-09-29 21:00:00", "main" => { "temp" => 14.19 } },
            { "dt" => 1_759_190_400, "dt_txt" => "2025-09-30 00:00:00", "main" => { "temp" => 13.11 } },
            { "dt" => 1_759_244_400, "dt_txt" => "2025-09-30 15:00:00", "main" => { "temp" => 19.53 } },
            { "dt" => 1_759_276_800, "dt_txt" => "2025-10-01 00:00:00", "main" => { "temp" => 13.76 } },
            { "dt" => 1_759_287_600, "dt_txt" => "2025-10-01 03:00:00", "main" => { "temp" => 12.85 } },
            { "dt" => 1_759_298_400, "dt_txt" => "2025-10-01 06:00:00", "main" => { "temp" => 12.4 } },
            { "dt" => 1_759_363_200, "dt_txt" => "2025-10-02 00:00:00", "main" => { "temp" => 13.65 } },
            { "dt" => 1_759_374_000, "dt_txt" => "2025-10-02 03:00:00", "main" => { "temp" => 12.82 } },
            { "dt" => 1_759_384_800, "dt_txt" => "2025-10-02 06:00:00", "main" => { "temp" => 12.18 } },
            { "dt" => 1_759_395_600, "dt_txt" => "2025-10-02 09:00:00", "main" => { "temp" => 15.51 } },
            { "dt" => 1_759_406_400, "dt_txt" => "2025-10-02 12:00:00", "main" => { "temp" => 19.8 } },
            { "dt" => 1_759_417_200, "dt_txt" => "2025-10-02 15:00:00", "main" => { "temp" => 18.33 } },
            { "dt" => 1_759_428_000, "dt_txt" => "2025-10-02 18:00:00", "main" => { "temp" => 16.33 } },
            { "dt" => 1_759_438_800, "dt_txt" => "2025-10-02 21:00:00", "main" => { "temp" => 16.16 } },
            { "dt" => 1_759_449_600, "dt_txt" => "2025-10-03 00:00:00", "main" => { "temp" => 16.5 } },
            { "dt" => 1_759_579_200, "dt_txt" => "2025-10-04 12:00:00", "main" => { "temp" => 14.37 } }
          ]
        }
      end

      before(:each) do
        stub_request(:get, five_day_forecast).to_return_json(body: response_body_mock, status: 200).with(query: params)
      end

      it "return forecast by day for the given location" do
        expect(forecast).to eq({
                                 "2025-09-29" => 14.19,
                                 "2025-09-30" => 16.32,
                                 "2025-10-01" => 13.00,
                                 "2025-10-02" => 15.60,
                                 "2025-10-03" => 16.50,
                                 "2025-10-04" => 14.37
                               })
      end
    end

    context "when open weather respond with error" do
      before(:each) do
        stub_request(:get, five_day_forecast)
          .to_return_json(body: { message: "mocked error" }, status: 500)
          .with(query: params)
      end

      it "raise the error" do
        expect { forecast }.to raise_error CaienaOpenweathermapSdk::OpenweathermapError, /mocked error/i
      end
    end

    context "when the request to open weather fails" do
      before(:each) do
        stub_request(:get, five_day_forecast)
          .to_raise(StandardError.new("mocked error"))
          .with(query: params)
      end

      it "raise the error" do
        expect { forecast }.to raise_error CaienaOpenweathermapSdk::ClientError, /mocked error/i
      end
    end
  end
end
