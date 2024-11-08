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

    func testNoFetchWhenInputCityNameIsEmpty() async {

        // Given.

        weatherViewModel.inputCityName = ""

        // When.

        await weatherViewModel.getWeather()

        // Then.

        XCTAssertEqual(weatherAPIService.fetchWeatherCallsCounter, 0)

        XCTAssertNil(weatherViewModel.weather)
    }

    func testGetWeatherWhenOpenWeatherAPIReturnsError() async {

        // Given.

        weatherViewModel.inputCityName = "Paris"

        let error = OpenWeatherAPIError.allCases.randomElement()

        weatherAPIService.error = error

        // When.

        await weatherViewModel.getWeather()

        // Then.

        XCTAssertEqual(weatherAPIService.fetchWeatherCallsCounter, 1)

        XCTAssertTrue(weatherViewModel.shouldPresentAlert)

        XCTAssertEqual(weatherViewModel.errorMessage, error?.userFriendlyDescription)

        XCTAssertNil(weatherViewModel.weather)
    }

    // Testing when the WeatherAPI returns a random error.
    func testGetWeatherWhenAPIReturnsOtherError() async {

        // Given.

        weatherViewModel.inputCityName = "Paris"

        // swiftlint:disable:next discouraged_direct_init
        let error = NSError()

        weatherAPIService.error = error

        // When.

        await weatherViewModel.getWeather()

        // Then.

        XCTAssertEqual(weatherAPIService.fetchWeatherCallsCounter, 1)

        XCTAssertTrue(weatherViewModel.shouldPresentAlert)

        XCTAssertEqual(weatherViewModel.errorMessage, Localizable.Weather.undeterminedErrorDescription)

        XCTAssertNil(weatherViewModel.weather)
    }

    func testGetWeatherIsSuccessWhenNoErrors() async {

        // Given

        weatherViewModel.inputCityName = "Paris"

        let weather: Weather = .random()

        weatherAPIService.weatherToReturn = weather

        // When

        await weatherViewModel.getWeather()

        // Then

        XCTAssertEqual(weatherAPIService.fetchWeatherCallsCounter, 1)

        XCTAssertEqual(weatherViewModel.weather, weather)

        XCTAssertFalse(weatherViewModel.shouldPresentAlert)

        XCTAssertTrue(weatherViewModel.errorMessage.isEmpty)
    }
}
