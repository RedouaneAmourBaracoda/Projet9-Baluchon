//
//  CurrenciesDropDownView.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/08/2024.
//

import SwiftUI

struct DropDownView: View {
    @Binding private var selectedCurrency: Currencies
    @State private var showMenu = false
    @Binding private var value: Float
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        return formatter
    }()
    
    init(selectedCurrency: Binding<Currencies>, value: Binding<Float>) {
        self._selectedCurrency = selectedCurrency
        self._value = value
    }
    
    var body: some View {
        HStack {
            leftView()
                .padding(.trailing)
            Spacer()
            rightView()
                .padding(.leading)
        }
        .padding()
        .background(content: {
            Color.gray.opacity(0.3)
        })
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .padding()
        
    }
    
    private func rightView() -> some View {
        HStack {
            Text(selectedCurrency.symbol)
            TextField("", value: $value, formatter: formatter)
                .keyboardType(.decimalPad)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .frame(width: 100.0)
            
        }
    }
    
    private func leftView() -> some View {
        HStack(spacing: 0) {
            Image(uiImage: selectedCurrency.flag)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .clipShape(Circle())
              .frame(width: 80)

            VStack(alignment: .leading){
                HStack {
                    Menu(selectedCurrency.abreviation) {
                        ForEach(Currencies.allCases, id: \.self) { currency in
                            Button(action: {
                                selectedCurrency = currency
                            }, label: {
                                Text(currency.abreviation)
                            })
                        }
                    }
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                    
                    Image(systemName: showMenu ? "chevron.up" : "chevron.down")
                }

                Text(selectedCurrency.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
            }
        }
    }
}


enum Currencies: String, CaseIterable {
    case USDollar = "US Dollar"
    case Euro = "Euro"
    case CanadianDollar = "Canadian Dollar"
    case BritishPound = "British Pound"
    case AustralianDollar = "Australian Dollar"
    
    var symbol: String {
        switch self {
        case .USDollar: return "$"
        case .Euro: return "€"
        case .CanadianDollar: return "$"
        case .BritishPound: return "£"
        case .AustralianDollar: return "$"
        }
    }
    
    var abreviation: String {
        switch self {
        case .USDollar: return "USD"
        case .Euro: return "EUR"
        case .CanadianDollar: return "CAD"
        case .BritishPound: return "GBP"
        case .AustralianDollar: return "AUD"
        }
    }
    
    var flag: UIImage {
        switch self {
        case .USDollar: return UIImage(resource: .init(name: "US-flag", bundle: .main))
        case .Euro:
            return UIImage(resource: .init(name: "UE-flag", bundle: .main))
        case .CanadianDollar:
            return UIImage(resource: .init(name: "Canadian-flag", bundle: .main))
        case .BritishPound:
            return UIImage(resource: .init(name: "GB-flag", bundle: .main))
        case .AustralianDollar:
            return UIImage(resource: .init(name: "Australian-flag", bundle: .main))
        }
    }
}

//#Preview {
//    DropDownView()
//}
