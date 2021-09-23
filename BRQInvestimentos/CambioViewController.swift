//
//  CambioViewController.swift
//  BRQInvestimentos
//
//  Created by user on 13/09/21.
//

import UIKit

extension UITextField {
    func definirPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func definirPlaceholder() {
        let grayPlaceholderText = NSAttributedString(string: "Quantidade", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
        self.attributedPlaceholder = grayPlaceholderText
    }
}

class CambioViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var cambioView: UIView!
    @IBOutlet var nomeLabel: UILabel!
    @IBOutlet var variacaoLabel: UILabel!
    @IBOutlet var compraLabel: UILabel!
    @IBOutlet var vendaLabel: UILabel!
    
    @IBOutlet var saldoLabel: UILabel!
    @IBOutlet var caixaLabel: UILabel!
    @IBOutlet var quantidadeTextField: UITextField!
    
    @IBOutlet var venderButton: UIButton!
    @IBOutlet var comprarButton: UIButton!
    
    // MARK: Propriedades
    var saldo: Saldo?
    var isoMoeda: String?
    var moeda: Currency?
    var formatoNumeros: NumberFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Câmbio"
                        
        definirBordas()
                
        carregarMoeda()
        
        checarBotoes()
    }
    
    func definirBordas() {
        cambioView.layer.cornerRadius = 15
        cambioView.layer.borderWidth = 1
        cambioView.layer.borderColor = UIColor.white.cgColor
        cambioView.layer.masksToBounds = true
        
        quantidadeTextField.layer.cornerRadius = 10
        quantidadeTextField.layer.borderWidth = 1
        quantidadeTextField.layer.borderColor = UIColor.lightGray.cgColor
        quantidadeTextField.layer.masksToBounds = true
        quantidadeTextField.definirPadding()
        quantidadeTextField.definirPlaceholder()
        
        venderButton.layer.cornerRadius = 20
        venderButton.layer.masksToBounds = true
                
        comprarButton.layer.cornerRadius = 20
        comprarButton.layer.masksToBounds = true
    }
    
    func definirCorVariacao(_ variacao: Double) {
        if variacao > 0 {
            variacaoLabel.textColor = .green
        } else if variacao == 0 {
            variacaoLabel.textColor = .white
        } else {
            variacaoLabel.textColor = .red
        }
    }
    
    func carregarMoeda() {
        guard let moeda = moeda,
              let saldo = saldo,
              let isoMoeda = isoMoeda,
              let formatoNumeros = formatoNumeros
        else { return }
        
        // Nome
        nomeLabel.text = "\(isoMoeda) - \(moeda.name)"
                
        // variação
        if let variacao = moeda.variation as NSNumber? {
            if let variacaoString = formatoNumeros.string(from: variacao) {                
                variacaoLabel.text = variacaoString + "%"
            }
        }
        
        definirCorVariacao(moeda.variation)
        
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
        if let saldoTotal = saldo.saldoTotal as NSNumber? {
            if let saldoString = formatoNumeros.string(from: saldoTotal) {
                saldoLabel.text = "Saldo disponível: R$ \(saldoString)"
            }
        }
        
        // caixa
        if let caixaMoeda = saldo.caixaMoedas[isoMoeda] as NSNumber? {
            if let caixaString = formatoNumeros.string(from: caixaMoeda) {
                caixaLabel.text = "\(caixaString) \(moeda.name) em caixa"
            }
        }
        
        quantidadeTextField.text = ""
    }
    
    // MARK: Botões
    @IBAction func venderTapped(_ sender: UIButton) {
        guard let moeda = moeda,
              let isoMoeda = isoMoeda,
              let saldo = saldo,
              let quantidadeText = quantidadeTextField.text,
              let formatoNumeros = formatoNumeros
        else { return }
        
        guard let valorVenda = moeda.sell,
              let quantidade = Int(quantidadeText)
        else { return }
                
        let totalVenda = saldo.vender(quantidade: quantidade, iso: isoMoeda, valorVenda: valorVenda)
        
        let titulo = "Vender"
        var texto = ""
        
        if let totalVendaNS = totalVenda as NSNumber? {
            if let totalVendaString = formatoNumeros.string(from: totalVendaNS) {
                texto = "Parabéns!\nVocê acabou de vender \(quantidade) \(isoMoeda) - \(moeda.name), totalizando R$ \(totalVendaString)"
            }
        }
                
        carregarMoeda()
        checarBotoes()
        
        chamarTelaTransacao(titulo: titulo, texto: texto)
    }
    
    @IBAction func comprarTapped(_ sender: UIButton) {
        guard let moeda = moeda,
              let isoMoeda = isoMoeda,
              let saldo = saldo,
              let quantidadeText = quantidadeTextField.text,
              let formatoNumeros = formatoNumeros
        else { return }
        
        guard let quantidade = Int(quantidadeText) else { return }
        
        let valorCompra = moeda.buy
        
        let totalCompra = saldo.comprar(quantidade: quantidade, iso: isoMoeda, valorCompra: valorCompra)
                
        let titulo = "Comprar"
        var texto = "Parabéns!\nVocê acabou de comprar \(quantidade) \(isoMoeda) - \(moeda.name), totalizando R$ \(totalCompra)"
        
        if let totalCompraNS = totalCompra as NSNumber? {
            if let totalCompraString = formatoNumeros.string(from: totalCompraNS) {
                texto = "Parabéns!\nVocê acabou de vender \(quantidade) \(isoMoeda) - \(moeda.name), totalizando R$ \(totalCompraString)"
            }
        }
        
        carregarMoeda()
        checarBotoes()
                
        chamarTelaTransacao(titulo: titulo, texto: texto)
    }
    
    func habilitarBotao(_ botao: UIButton) {
        botao.isEnabled = true
        botao.alpha = 1
    }
    
    func desabilitarBotao(_ botao: UIButton) {
        botao.isEnabled = false
        botao.alpha = 0.5
    }
    
    func checarBotoes() {
        guard let moeda = moeda,
              let isoMoeda = isoMoeda,
              let saldo = saldo,
              let quantidadeText = quantidadeTextField.text
        else { return }
        
        var quantidade: Int = 0
        
        if let quantidadeInt = Int(quantidadeText) {
            quantidade = quantidadeInt
        }
        
        // Botão Vender
        if let caixaMoeda = saldo.caixaMoedas[isoMoeda] {
            if caixaMoeda < quantidade || caixaMoeda == 0 || moeda.sell == nil {
                desabilitarBotao(venderButton)
            } else {
                habilitarBotao(venderButton)
            }
        }
        
        // Botão Comprar
        let totalCompra = moeda.buy * Double(quantidade)
        
        if saldo.saldoTotal < totalCompra || saldo.saldoTotal < moeda.buy {
            desabilitarBotao(comprarButton)
        } else {
            habilitarBotao(comprarButton)
        }
        
        if quantidadeText == "" || quantidade == 0 {
            desabilitarBotao(venderButton)
            desabilitarBotao(comprarButton)
        }
    }

    @IBAction func quantidadeChanged(_ sender: UITextField) {
        checarBotoes()
    }
    
    func chamarTelaTransacao(titulo: String, texto: String) {
        guard let storyboard = storyboard,
              let nc = navigationController
        else { return }
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "transacaoVC") as? TransacaoViewController {
            vc.title = titulo
            vc.texto = texto
            nc.pushViewController(vc, animated: true)
        }
    }
}
