//
//  ViewController.swift
//  BRQInvestimentos
//
//  Created by user on 09/09/21.
//

import UIKit

class ViewController: UIViewController {
        
    // MARK: Propriedades
    var isoMoedas = ["USD", "EUR", "GBP", "ARS", "CAD", "AUD", "JPY", "CNY", "BTC"]
    var moedas = [Currency]()
    var saldo = Saldo()
    
    let urlString = "https://api.hgbrasil.com/finance?key=ddc1480f"
    
    let formatoNumeros: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        return formatter
    }()
    
    let cellHeight: CGFloat = 85
        
    // MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        title = "Moedas"
        
        definirBotaoRefresh()
        
        carregarMoedas()
    }
    
    // MARK: Botão Refresh
    func definirBotaoRefresh() {
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(carregarMoedas))
        refresh.tintColor = .white
        refresh.accessibilityLabel = "Atualizar"
        
        navigationItem.rightBarButtonItem = refresh
    }
    
    // MARK: Dados
    @objc func carregarMoedas() {
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJSON = try jsonDecoder.decode(Entry.self, from: data)
                    
                    self.moedas.append(parsedJSON.results.currencies.USD)
                    self.moedas.append(parsedJSON.results.currencies.EUR)
                    self.moedas.append(parsedJSON.results.currencies.GBP)
                    self.moedas.append(parsedJSON.results.currencies.ARS)
                    self.moedas.append(parsedJSON.results.currencies.CAD)
                    self.moedas.append(parsedJSON.results.currencies.AUD)
                    self.moedas.append(parsedJSON.results.currencies.JPY)
                    self.moedas.append(parsedJSON.results.currencies.CNY)
                    self.moedas.append(parsedJSON.results.currencies.BTC)
                    
                    //print(self.moedas)
                                            
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isoMoedas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "moedaCell", for: indexPath) as? MoedaTableViewCell else {
            return UITableViewCell()
        }
        
        cell.isAccessibilityElement = true
        cell.accessibilityHint = "Clique para acessar o câmbio"

        // ISO
        cell.moedaLabelView.text = isoMoedas[indexPath.row]
        
        if indexPath.row >= 0 && indexPath.row < moedas.count {
            
            cell.moedaLabelView.accessibilityLabel = moedas[indexPath.row].name
            
            // variação
            if let variacao = moedas[indexPath.row].variation as NSNumber? {
                if let variacaoString = formatoNumeros.string(from: variacao) {
                    cell.cotacaoLabelView.text = variacaoString + "%"
                }
            }
            cell.cotacaoLabelView.definirCorVariacao(moedas[indexPath.row].variation)
        }
        
        cell.moedaView.definirBordaView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard,
              let navigation = navigationController
        else { return }
        
        if let cambioVC = storyboard.instantiateViewController(withIdentifier: "cambioVC") as? CambioViewController {
            cambioVC.isoMoeda = isoMoedas[indexPath.row]
            cambioVC.moeda = moedas[indexPath.row]
            cambioVC.saldo = saldo
            cambioVC.formatoNumeros = formatoNumeros
            navigation.pushViewController(cambioVC, animated: true)
        }
    }
}

