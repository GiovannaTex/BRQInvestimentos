//
//  CambioViewController.swift
//  BRQInvestimentos
//
//  Created by user on 13/09/21.
//

import UIKit

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
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Câmbio"
                        
        definirBordas()
                
        carregarMoeda()
        
        checarBotoes()
    }
    
    // MARK: Layout
    func definirBordas() {
        cambioView.definirBordaView()
        
        quantidadeTextField.definirBordaTextField()
        quantidadeTextField.definirPadding()
        quantidadeTextField.definirPlaceholder()
        
        venderButton.definirBordaButton()
                
        comprarButton.definirBordaButton()
    }
    
    // MARK: Dados
    func carregarMoeda() {
        guard let moeda = moeda,
              let saldo = saldo,
              let isoMoeda = isoMoeda,
              let formatoNumeros = formatoNumeros
        else { return }
        
        // Nome
        nomeLabel.text = "\(isoMoeda) - \(moeda.name)"
                
        // Variação
        if let variacao = moeda.variation as NSNumber? {
            if let variacaoString = formatoNumeros.string(from: variacao) {                
                variacaoLabel.text = variacaoString + "%"
            }
        }
        
        variacaoLabel.definirCorVariacao(moeda.variation)
        
        // Compra
        if let compra = moeda.buy as NSNumber? {
            if let compraString = formatoNumeros.string(from: compra) {
                compraLabel.text = "Compra: R$ \(compraString)"
            }
        }
        
        // Venda
        if let venda = moeda.sell as NSNumber? {
            if let vendaString = formatoNumeros.string(from: venda) {
                vendaLabel.text = "Venda: R$ \(vendaString)"
            }
        }
        
        // Saldo
        if let saldoTotal = saldo.saldoTotal as NSNumber? {
            if let saldoString = formatoNumeros.string(from: saldoTotal) {
                saldoLabel.text = "Saldo disponível: R$ \(saldoString)"
            }
        }
        
        // Caixa
        if let caixaMoeda = saldo.caixaMoedas[isoMoeda] as NSNumber? {
            if let caixaString = formatoNumeros.string(from: caixaMoeda) {
                caixaLabel.text = "\(caixaString) \(moeda.name) em caixa"
            }
        }
        
        quantidadeTextField.text = String()
        quantidadeTextField.accessibilityHint = "Digite a quantidade"
    }
    
    // MARK: Botões
    @IBAction func botaoPressionado(_ sender: UIButton) {
        guard let moeda = moeda,
              let isoMoeda = isoMoeda,
              let saldo = saldo,
              let quantidadeText = quantidadeTextField.text,
              let formatoNumeros = formatoNumeros,
              let quantidade = Int(quantidadeText)
        else { return }

        var titulo = String()
        var texto = String()
        var transacao = String()
        var totalTransacao = Double()
        
        if sender.tag == 0 {
            guard let valorVenda = moeda.sell else { return }
            
            totalTransacao = saldo.vender(quantidade: quantidade, iso: isoMoeda, valorVenda: valorVenda)
            
            titulo = "Vender"
            transacao = "vender"

        } else {
            let valorCompra = moeda.buy
            
            totalTransacao = saldo.comprar(quantidade: quantidade, iso: isoMoeda, valorCompra: valorCompra)
            
            titulo = "Comprar"
            transacao = "comprar"
        }
        
        if let totalTransacaoNS = totalTransacao as NSNumber? {
            if let totalTransacaoString = formatoNumeros.string(from: totalTransacaoNS) {
                texto = "Parabéns!\nVocê acabou de \(transacao) \(quantidade) \(isoMoeda) - \(moeda.name), totalizando R$ \(totalTransacaoString)"
            }
        }
        
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
        
        if quantidadeText.isEmpty || quantidade <= 0 {
            desabilitarBotao(venderButton)
            desabilitarBotao(comprarButton)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        carregarMoeda()
        checarBotoes()
    }

    // MARK: TextField
    @IBAction func quantidadeChanged(_ sender: UITextField) {
        checarBotoes()
    }
    
    // MARK: TransacaoViewController
    func chamarTelaTransacao(titulo: String, texto: String) {
        guard let storyboard = storyboard,
              let navigation = navigationController
        else { return }
        
        if let transacaoVC = storyboard.instantiateViewController(withIdentifier: "transacaoVC") as? TransacaoViewController {
            transacaoVC.title = titulo
            transacaoVC.texto = texto
            navigation.pushViewController(transacaoVC, animated: true)
        }
    }
}

// MARK: Extensions
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
    
    func definirBordaTextField() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
    }
}

extension UIButton {
    func definirBordaButton() {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
}
