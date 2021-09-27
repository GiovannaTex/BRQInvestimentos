//
//  FinanceData.swift
//  BRQInvestimentos
//
//  Created by user on 12/09/21.
//

import Foundation

struct Entry: Codable {
    let results: Results
}

struct Results: Codable {
    let currencies: Currencies
}

struct Currencies: Codable {
    let USD, EUR, GBP, ARS, CAD, AUD, JPY, CNY, BTC: Currency
}

struct Currency: Codable {
    let name: String
    let buy: Double
    let sell: Double?
    let variation: Double
}

