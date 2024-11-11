//
//  Localizable.swift
//  Le-Baluchon
//
//  Created by Redouane on 01/11/2024.
//

import Foundation

enum Localizable {
    static let errorAlertTitle = NSLocalizedString(
        "weather.alert.error.title",
        comment: ""
    )

    enum Currency {
        static let navigationTitle = NSLocalizedString(
            "currency.navigation-title",
            comment: ""
        )

        static let textFieldPlaceHolder = NSLocalizedString(
            "currency.textfield.placeholder",
            comment: ""
        )

        static let noData = NSLocalizedString(
            "currency.no-data",
            comment: ""
        )

        static let invalidNumberDescription = NSLocalizedString(
            "currency.errors.invalid-number.description",
            comment: ""
        )

        static let undeterminedErrorDescription = NSLocalizedString(
            "currency.errors.undetermined.description",
            comment: ""
        )

        static let toolbarDoneButtonTitle = NSLocalizedString(
            "currency.toolbar.done-button.title",
            comment: ""
        )
    }

    enum Weather {
        static let navigationTitle = NSLocalizedString(
            "weather.navigation-title",
            comment: ""
        )

        static let textFieldPlaceHolder = NSLocalizedString(
            "weather.textfield.placeholder",
            comment: ""
        )

        static let humidityTitle = NSLocalizedString(
            "weather.additional-info.humidity.name",
            comment: ""
        )

        static let temperatureFeltTitle = NSLocalizedString(
            "weather.additional-info.temperature-felt.name",
            comment: ""
        )

        static let pressureTitle = NSLocalizedString(
            "weather.additional-info.pressure.name",
            comment: ""
        )

        static let undeterminedErrorDescription = NSLocalizedString(
            "weather.errors.undetermined.description",
            comment: ""
        )
    }

    enum Translation {
        static let navigationTitle = NSLocalizedString(
            "translation.navigation-title",
            comment: ""
        )

        static let undeterminedErrorDescription = NSLocalizedString(
            "translation.errors.undetermined.description",
            comment: ""
        )

        static let clearButtonTitle = NSLocalizedString(
            "translation.button.clear",
            comment: ""
        )

        static let toolbarTranslateButtonTitle = NSLocalizedString(
            "translation.toolbar.translate-button.title",
            comment: ""
        )
    }
}
