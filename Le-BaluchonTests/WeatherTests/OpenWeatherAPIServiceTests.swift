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

        // Given.

        weatherAPIService.urlString = ""

        // Then.

        do {
            let _ = try await weatherAPIService.fetchWeather(cityName: "")
        } catch let error as OpenWeatherAPIError {
            XCTAssert(error == .invalidURL)
            XCTAssert(error.errorDescription == OpenWeatherAPIError.invalidURL.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs400() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await weatherAPIService.fetchWeather(cityName: "")
        } catch let error as OpenWeatherAPIError {
            XCTAssert(error == .bad_request)
            XCTAssert(error.errorDescription == OpenWeatherAPIError.bad_request.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs401() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await weatherAPIService.fetchWeather(cityName: "")
        } catch let error as OpenWeatherAPIError {
            XCTAssert(error == .unauthorized)
            XCTAssert(error.errorDescription == OpenWeatherAPIError.unauthorized.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs404() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await weatherAPIService.fetchWeather(cityName: "")
        } catch let error as OpenWeatherAPIError {
            XCTAssert(error == .not_found)
            XCTAssert(error.errorDescription == OpenWeatherAPIError.not_found.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs429() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 429,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await weatherAPIService.fetchWeather(cityName: "")
        } catch let error as OpenWeatherAPIError {
            XCTAssert(error == .too_many_requests)
            XCTAssert(error.errorDescription == OpenWeatherAPIError.too_many_requests.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs5XX() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: Int.random(in: 500...599),
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await weatherAPIService.fetchWeather(cityName: "")
        } catch let error as OpenWeatherAPIError {
            XCTAssert(error == .internalError)
            XCTAssert(error.errorDescription == OpenWeatherAPIError.internalError.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIsUnknown() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: Set(-1000...1000).subtracting(Set([200, 400, 401, 403, 404, 429])).subtracting(Set(500...599)).randomElement() ?? 0,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await weatherAPIService.fetchWeather(cityName: "")
        } catch let error as OpenWeatherAPIError {
            XCTAssert(error == .invalidRequest)
            XCTAssert(error.errorDescription == OpenWeatherAPIError.invalidRequest.errorDescription)
        }
    }

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

            let mockData = """
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
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let actualResult = try await weatherAPIService.fetchWeather(cityName: cityName)
            let expectedResult = WeatherModel(
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
}
