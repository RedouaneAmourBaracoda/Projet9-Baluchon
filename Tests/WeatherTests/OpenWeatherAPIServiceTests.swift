//
//  Le_BaluchonTests.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 22/08/2024.
//

import XCTest
@testable import Le_Baluchon

final class OpenWeatherAPIServiceTests: XCTestCase {

    var weatherAPIService: OpenWeatherAPIService!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let sessionMock = URLSession(configuration: configuration)
        weatherAPIService = .init(session: sessionMock)
    }

    func testNetworkCallFailsWhenInvalidURL() async throws {
        weatherAPIService.urlString = ""
        try await testOpenWeatherAPIError(statusCode: Int(), testedError: .invalidURL)
    }

    func testNetworkCallFailsWhenStatusCodeIs400() async throws {
        try await testOpenWeatherAPIError(statusCode: 400, testedError: .badRequest)
    }

    func testNetworkCallFailsWhenStatusCodeIs401() async throws {
        try await testOpenWeatherAPIError(statusCode: 401, testedError: .unauthorized)
    }

    func testNetworkCallFailsWhenStatusCodeIs404() async throws {
        try await testOpenWeatherAPIError(statusCode: 404, testedError: .notFound)
    }

    func testNetworkCallFailsWhenStatusCodeIs429() async throws {
        try await testOpenWeatherAPIError(statusCode: 429, testedError: .tooManyRequests)
    }

    func testNetworkCallFailsWhenStatusCodeIs5XX() async throws {
        try await testOpenWeatherAPIError(statusCode: Int.random(in: 500...599), testedError: .internalError)
    }

    func testNetworkCallFailsWhenStatusCodeIsUnknown() async throws {
        try await testOpenWeatherAPIError(
            statusCode: Set(-1000...1000)
                .subtracting(Set([200, 400, 401, 403, 404, 429]))
                .subtracting(Set(500...599))
                .randomElement() ?? 0,
            testedError: .invalidRequest
        )
    }

    // swiftlint:disable:next function_body_length
    func testNetworkCallSuccess() async throws {

        // Given.

        let cityName = "London"

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = Data("""
                {
                    "coord": {
                        "lon": -0.1257,
                        "lat": 51.5085
                    },
                    "weather": [
                        {
                            "id": 804,
                            "main": "Clouds",
                            "description": "couvert",
                            "icon": "04d"
                        }
                    ],
                    "base": "stations",
                    "main": {
                        "temp": 284.9,
                        "feels_like": 284.48,
                        "temp_min": 283.35,
                        "temp_max": 285.98,
                        "pressure": 1032,
                        "humidity": 90,
                        "sea_level": 1032,
                        "grnd_level": 1027
                    },
                    "visibility": 10000,
                    "wind": {
                        "speed": 1.54,
                        "deg": 210
                    },
                    "clouds": {
                        "all": 100
                    },
                    "dt": 1729668277,
                    "sys": {
                        "type": 2,
                        "id": 2075535,
                        "country": "GB",
                        "sunrise": 1729665516,
                        "sunset": 1729702241
                    },
                    "timezone": 3600,
                    "id": 2643743,
                    "name": "Londres",
                    "cod": 200
                }
                """.utf8)
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let actualResult = try await weatherAPIService.fetchWeather(cityName: cityName)
            let expectedResult = Weather(
                city: "Londres",
                lon: -0.1257,
                lat: 51.5085,
                temperature: Int(284.9),
                temperatureFelt: Int(284.48),
                temperatureMin: Int(283.35),
                temperatureMax: Int(285.98),
                humidity: 90,
                pressure: 1032,
                description: "couvert",
                weatherKind: .clouds
            )

            XCTAssertEqual(actualResult, expectedResult)
        } catch {
            XCTAssertNil(error)
        }
    }

    private func testOpenWeatherAPIError(statusCode: Int, testedError: OpenWeatherAPIError) async throws {

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = Data()
            return (mockResponse, mockData)
        }

        // Then.

        do {
            _ = try await weatherAPIService.fetchWeather(cityName: "")
        } catch let error as OpenWeatherAPIError {
            XCTAssertTrue(error == testedError)
            XCTAssertEqual(error.errorDescription, testedError.errorDescription)
            XCTAssertEqual(error.userFriendlyDescription, testedError.userFriendlyDescription)
        }
    }
}
