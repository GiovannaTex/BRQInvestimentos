//
//  Saldo.swift
//  BRQInvestimentos
//
//  Created by user on 20/09/21.
//

import Foundation

class Saldo {
    var saldoTotal: Double
    var caixaMoedas: [String: Int]
    
    init() {
        saldoTotal = 1000.0
        caixaMoedas = ["USD": 0, "EUR": 0, "GBP": 0, "ARS": 0, "CAD": 0, "AUD": 0, "JPY": 0, "CNY": 0, "BTC": 0]
    }
    
    func vender(quantidade: Int, iso: String, valorVenda: Double) -> Double {
        guard let saldoMoeda = caixaMoedas[iso] else {
            return 0.0
        }
               
        let totalVenda = valorVenda * Double(quantidade)
               
        saldoTotal += totalVenda
        caixaMoedas[iso] = saldoMoeda - quantidade
        
        return totalVenda
    }
    
    func comprar(quantidade: Int, iso: String, valorCompra: Double) -> Double {
        guard let saldoMoeda = caixaMoedas[iso] else {
            return 0.0
        }
                
        let totalCompra = valorCompra * Double(quantidade)
                
        caixaMoedas[iso] = saldoMoeda + quantidade
        saldoTotal -= totalCompra
        
        return totalCompra
    }
}
