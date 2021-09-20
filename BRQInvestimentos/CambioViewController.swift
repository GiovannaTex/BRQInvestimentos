//
//  CambioViewController.swift
//  BRQInvestimentos
//
//  Created by user on 13/09/21.
//

import UIKit

extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

class CambioViewController: UIViewController {
    
    @IBOutlet var cambioView: UIView!
    @IBOutlet var nomeLabel: UILabel!
    @IBOutlet var variacaoLabel: UILabel!
    @IBOutlet var compraLabel: UILabel!
    @IBOutlet var vendaLabel: UILabel!
    
    @IBOutlet var saldoLabel: UILabel!
    @IBOutlet var caixaLabel: UILabel!
    @IBOutlet var quantidadeTextField: UITextField! {
        didSet {
            let grayPlaceholderText = NSAttributedString(string: "Quantidade", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                
            quantidadeTextField.attributedPlaceholder = grayPlaceholderText
        }
    }
    
    @IBOutlet var venderButton: UIButton!
    @IBOutlet var comprarButton: UIButton!
    
    var saldo: Double = 1000
    var caixa: Double = 0
    var quantidade: Int = 0
    var isoMoeda: String?
    var moeda: Currency?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Câmbio"
        
        cambioView.layer.cornerRadius = 15
        cambioView.layer.borderWidth = 1
        cambioView.layer.borderColor = UIColor.white.cgColor
        cambioView.layer.masksToBounds = true
        
        quantidadeTextField.layer.cornerRadius = 10
        quantidadeTextField.layer.borderWidth = 1
        quantidadeTextField.layer.borderColor = UIColor.lightGray.cgColor
        quantidadeTextField.layer.masksToBounds = true
        quantidadeTextField.setPadding()
                
        venderButton.layer.cornerRadius = 20
        venderButton.layer.masksToBounds = true
        venderButton.isEnabled = true
                
        comprarButton.layer.cornerRadius = 20
        comprarButton.layer.masksToBounds = true
        comprarButton.isEnabled = true
        
        carregarMoeda()
        
        if caixa == 0 {
            desabilitarBotao(venderButton)
        }
    }
    
    func carregarMoeda() {
        guard let moeda = moeda else { return }
        
        // nome
        guard let isoMoeda = isoMoeda else { return }
        nomeLabel.text = "\(isoMoeda) - \(moeda.name)"
        
        // formatação
        let formatoNumeros = NumberFormatter()
        
        formatoNumeros.numberStyle = .decimal
        formatoNumeros.decimalSeparator = ","
        formatoNumeros.groupingSeparator = "."
                
        // variação
        if let variacao = moeda.variation as NSNumber? {
            if var variacaoString = formatoNumeros.string(from: variacao) {
                while variacaoString.last == "0" {
                    variacaoString.removeLast()
                }
                if variacaoString.last == "," {
                    variacaoString.removeLast()
                }
                
                variacaoLabel.text = variacaoString + "%"
            }
        }
        
        if moeda.variation > 0 {
            variacaoLabel.textColor = .green
        } else if moeda.variation == 0 {
            variacaoLabel.textColor = .white
        } else {
            variacaoLabel.textColor = .red
        }
        
        // compra
        if let compra = moeda.buy as NSNumber? {
            if let compraString = formatoNumeros.string(from: compra) {
                compraLabel.text = "Compra: R$ \(compraString)"
            }
        }
        
        // venda
        if let venda = moeda.sell as NSNumber? {
            if let vendaString = formatoNumeros.string(from: venda) {
                vendaLabel.text = "Venda: R$ \(vendaString)"
            }
        }
        
        // saldo
        if let saldo = saldo as NSNumber? {
            if let saldoString = formatoNumeros.string(from: saldo) {
                saldoLabel.text = "Saldo disponível: R$ \(saldoString)"
            }
        }
        
        // caixa
        if let caixa = caixa as NSNumber? {
            if let caixaString = formatoNumeros.string(from: caixa) {
                caixaLabel.text = "\(caixaString) \(moeda.name) em caixa"
            }
        }
    }
    
    
    @IBAction func venderTapped(_ sender: UIButton) {
    }
    
    @IBAction func comprarTapped(_ sender: UIButton) {
    }
    
    
    func desabilitarBotao(_ botao: UIButton) {
        botao.isEnabled = false
        botao.alpha = 0.5
    }
}
