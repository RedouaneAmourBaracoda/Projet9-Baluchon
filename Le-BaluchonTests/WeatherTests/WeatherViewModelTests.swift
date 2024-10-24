//
//  CurrencyViewModelTests.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 18/09/2024.
//

@testable import Le_Baluchon
import XCTest

@MainActor
final class WeatherViewModelTests: XCTestCase {

    var weatherViewModel: WeatherViewModel!

    var weatherAPIService: MockWeatherAPIService!

    override func setUpWithError() throws {

        weatherAPIService = MockWeatherAPIService()

        weatherViewModel = .init(weatherAPIService: weatherAPIService)
    }

    func testClear() async {

        // Given.

        weatherViewModel.inputCityName = "Paris"

        // When.

        weatherViewModel.clear()

        // Then.

        XCTAssertTrue(weatherViewModel.inputCityName.isEmpty)
    }

    func testGetWeatherWhenOpenWeatherAPIReturnsError() async {

        // Given.

        let error = OpenWeatherAPIError.allCases.randomElement()

        weatherAPIService.error = error

        // When.

        await weatherViewModel.getWeather()

        // Then.

        XCTAssertEqual(weatherAPIService.fetchWeatherCallsCounter, 1)

        XCTAssertTrue(weatherViewModel.shouldPresentAlert)

        XCTAssertEqual(weatherViewModel.errorMessage, error?.errorDescription)

        XCTAssertNil(weatherViewModel.weatherModel)
    }

    // Testing when the WeatherAPI returns a random error.
    func testGetWeatherWhenAPIReturnsOtherError() async {

        // Given.

        // swiftlint:disable:next discouraged_direct_init
        let error = NSError()

        weatherAPIService.error = error

        // When.

        await weatherViewModel.getWeather()

        // Then.

        XCTAssertEqual(weatherAPIService.fetchWeatherCallsCounter, 1)

        XCTAssertTrue(weatherViewModel.shouldPresentAlert)

        XCTAssertEqual(weatherViewModel.errorMessage, .weatherUndeterminedErrorDescription)

        XCTAssertNil(weatherViewModel.weatherModel)
    }

    func testGetWeatherIsSuccessWhenNoErrors() async {

        // Given.

        let weather: WeatherModel = .random()

        weatherAPIService.weatherToReturn = weather

        // When.

        await weatherViewModel.getWeather()

        // Then.

        XCTAssertEqual(weatherAPIService.fetchWeatherCallsCounter, 1)

        XCTAssertEqual(weatherViewModel.weatherModel, weather)

        XCTAssertFalse(weatherViewModel.shouldPresentAlert)

        XCTAssertTrue(weatherViewModel.errorMessage.isEmpty)
    }
}
