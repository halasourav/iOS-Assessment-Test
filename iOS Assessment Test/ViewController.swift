//
//  ViewController.swift
//  iOS Assessment Test
//
//  Created by Sourav Bhattacharjee on 28/07/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var showLUOutlet: UIButton!
    @IBOutlet weak var showSOutlet: UIButton!
    @IBOutlet weak var showSCOutlet: UIButton!
    @IBOutlet weak var showLOutlet: UIButton!
    @IBOutlet weak var showAllOutlet: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataModel = DataModel()
    let apiUrl = "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/synopsis.json"
    var selection : Int = 1
    var isSearch: Bool = false
    
    var alphaS = 0
    var alphaSC = 0
    var alphaL = 0
    var alphaLU = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        callApi()
        setupUI(enabled: showAllOutlet)
        searchBar.delegate = self
        self.view.layer.backgroundColor = UIColor(named: "BackgroundColor")?.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapCollectionView(_:)))
                collectionView.addGestureRecognizer(tapGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: IBActions
    @IBAction func showAll(_ sender: UIButton) {
        setupUI(enabled: showAllOutlet)
        searchBar.text = ""
        selection = 1
        isSearch = false
        resetAlphaCount()
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    @IBAction func showL(_ sender: UIButton) {
        setupUI(enabled: showLOutlet)
        searchBar.text = ""
        selection = 2
        isSearch = false
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    @IBAction func showSC(_ sender: UIButton) {
        setupUI(enabled: showSCOutlet)
        searchBar.text = ""
        selection = 3
        isSearch = false
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    @IBAction func showS(_ sender: UIButton) {
        setupUI(enabled: showSOutlet)
        searchBar.text = ""
        selection = 4
        isSearch = false
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    @IBAction func showLU(_ sender: UIButton) {
        setupUI(enabled: showLUOutlet)
        searchBar.text = ""
        selection = 5
        isSearch = false
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resetAlphaCount()
        if searchBar.text != "" {
            dataModel.searchedData(searchString: searchBar.text!, selection: selection)
            isSearch = true
            collectionView.reloadData()
        } else {
            isSearch = false
            collectionView.reloadData()
        }
    }
    
    //MARK: Collection View Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selection == 1 {
            if isSearch{
                return dataModel.searchedCombinedData.count
            }
            return dataModel.combinedData.count
        } else if selection == 2 {
            if isSearch{
                return dataModel.searchedDataL.count
            }
            return dataModel.dataL.count
        } else if selection == 3 {
            if isSearch{
                return dataModel.searchedDataSC.count
            }
            return dataModel.dataSC.count
        } else if selection == 4 {
            if isSearch{
                return dataModel.searchedDataS.count
            }
            return dataModel.dataS.count
        } else if selection == 5 {
            if isSearch{
                return dataModel.searchedDataLU.count
            }
            return dataModel.dataLU.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: "collectionCell",
            for: indexPath) as! CollectionViewCell
        cellViewSetUp(cell: cell, selection: selection, isSearch: isSearch, row: indexPath.row)
        cell.sizeToFit()
        cell.symbolLabetOutlet.sizeToFit()
        cell.priceChangeLabelOutlet.sizeToFit()
        return cell
    }
    
    
    //Adjusting cell size and spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/10, height: collectionView.frame.width/10)
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    @objc func tapCollectionView(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}


extension ViewController {
    
    func callApi() {
        guard let url = URL(string: apiUrl) else {
            return
        }
        dataModel.getPriceChange(url: url, completion: {_ in
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
        })
    }
    
    func setupUI(enabled: UIButton){

        showAllOutlet.layer.cornerRadius = showAllOutlet.frame.height/2
        showAllOutlet.layer.backgroundColor = UIColor.orange.withAlphaComponent(0.5).cgColor
        
        showLOutlet.layer.cornerRadius = showLOutlet.frame.height/2
        showLOutlet.layer.backgroundColor = .init(red: 0, green: 255, blue: 0, alpha: 0.5)
        
        showLUOutlet.layer.cornerRadius = showLUOutlet.frame.height/2
        showLUOutlet.layer.backgroundColor = .init(red: 0, green: 255, blue: 255, alpha: 0.5)
        
        showSOutlet.layer.cornerRadius = showSOutlet.frame.height/2
        showSOutlet.layer.backgroundColor = .init(red: 255, green: 0, blue: 0, alpha: 0.5)
        
        showSCOutlet.layer.cornerRadius = showSCOutlet.frame.height/2
        showSCOutlet.layer.backgroundColor = .init(red: 255, green: 255, blue: 0, alpha: 0.5)
        
        enabled.backgroundColor = enabled.backgroundColor?.withAlphaComponent(1)
    }
    
    func cellViewSetUp(cell: CollectionViewCell, selection: Int, isSearch: Bool, row: Int){
        if selection == 1 {
            if isSearch {
                if let symbol = dataModel.searchedCombinedData[row]["symbol"] as? String, let priceChange = dataModel.searchedCombinedData[row]["priceChange"] as? Double, let category = dataModel.searchedCombinedData[row]["category"] as? String{
                    cell.symbolLabetOutlet.text = symbol
                    let priceChangeString: String = String(format: "%.2f", priceChange)
                    cell.priceChangeLabelOutlet.text = String("\(priceChangeString)%")
                    if category == "s" {
                        let alphaChange = 0.25/Double(dataModel.numberOfSearchedDataS)*Double(alphaS)
                        cell.layer.backgroundColor = .init(red: 255, green: 0, blue: 0, alpha: 1 - CGFloat(alphaChange) )
                        alphaS += 1
                    } else if category == "sc" {
                        let alphaChange = 0.25/Double(dataModel.numberOfSearchedDataSC)*Double(alphaSC)
                        print(alphaChange)
                        cell.layer.backgroundColor = .init(red: 255, green: 255, blue: 0, alpha: 1 - CGFloat(alphaChange))
                        alphaSC += 1
                    } else if category == "l" {
                        let alphaChange = 0.25/Double(dataModel.numberOfSearchedDataL)*Double(alphaL)
                        cell.layer.backgroundColor = .init(red: 0, green: 255, blue: 0, alpha: 1 - CGFloat(alphaChange))
                        alphaL += 1
                    } else if category == "lu" {
                        let alphaChange = 0.25/Double(dataModel.numberOfSearchedDataLU)*Double(alphaLU)
                        cell.layer.backgroundColor = .init(red: 0, green: 255, blue: 255, alpha: 1 - CGFloat(alphaChange))
                        alphaLU += 1
                    }
                }
            }else {
                if let symbol = dataModel.combinedData[row]["symbol"] as? String, let priceChange = dataModel.combinedData[row]["priceChange"] as? Double, let category = dataModel.combinedData[row]["category"] as? String{
                    cell.symbolLabetOutlet.text = symbol
                    let priceChangeString: String = String(format: "%.2f", priceChange)
                    cell.priceChangeLabelOutlet.text = String("\(priceChangeString)%")
                    if category == "s" {
                        let alphaChange = 0.25/Double(dataModel.numberOfDataS)*Double(alphaS)
                        cell.layer.backgroundColor = .init(red: 255, green: 0, blue: 0, alpha: 1 - CGFloat(alphaChange))
                        alphaS += 1
                    } else if category == "sc" {
                        let alphaChange = 0.25/Double(dataModel.numberOfDataSC)*Double(alphaSC)
                        cell.layer.backgroundColor = .init(red: 255, green: 255, blue: 0, alpha: 1 - CGFloat(alphaChange))
                        alphaSC += 1
                    } else if category == "l" {
                        let alphaChange = 0.25/Double(dataModel.numberOfDataL)*Double(alphaL)
                        cell.layer.backgroundColor = .init(red: 0, green: 255, blue: 0, alpha: 1 - CGFloat(alphaChange))
                        alphaL += 1
                    } else if category == "lu" {
                        let alphaChange = 0.25/Double(dataModel.numberOfDataLU)*Double(alphaLU)
                        cell.layer.backgroundColor = .init(red: 0, green: 255, blue: 255, alpha: 1 - CGFloat(alphaChange))
                        alphaLU += 1
                    }
                }
            }
        } else if selection == 2 {
            if isSearch {
                if let symbol = dataModel.searchedDataL[row]["symbol"] as? String, let priceChange = dataModel.searchedDataL[row]["priceChange"] as? Double{
                    cell.symbolLabetOutlet.text = symbol
                    let priceChangeString: String = String(format: "%.2f", priceChange)
                    cell.priceChangeLabelOutlet.text = String("\(priceChangeString)%")
                    let alphaChange = 0.25/Double(dataModel.searchedDataL.count)*Double(row)
                    cell.layer.backgroundColor = .init(red: 0, green: 255, blue: 0, alpha: 1 - CGFloat(alphaChange))
                }
            } else {
                if let symbol = dataModel.dataL[row]["symbol"] as? String, let priceChange = dataModel.dataL[row]["priceChange"] as? Double{
                    cell.symbolLabetOutlet.text = symbol
                    let priceChangeString: String = String(format: "%.2f", priceChange)
                    cell.priceChangeLabelOutlet.text = String("\(priceChangeString)%")
                    let alphaChange = 0.25/Double(dataModel.dataL.count)*Double(row)
                    cell.layer.backgroundColor = .init(red: 0, green: 255, blue: 0, alpha: 1 - CGFloat(alphaChange))
                }
            }
        } else if selection == 3 {
            if isSearch {
                if let symbol = dataModel.searchedDataSC[row]["symbol"] as? String, let priceChange = dataModel.searchedDataSC[row]["priceChange"] as? Double{
                    cell.symbolLabetOutlet.text = symbol
                    let priceChangeString: String = String(format: "%.2f", priceChange)
                    cell.priceChangeLabelOutlet.text = String("\(priceChangeString)%")
                    let alphaChange = 0.25/Double(dataModel.searchedDataSC.count)*Double(row)
                    cell.layer.backgroundColor = .init(red: 255, green: 255, blue: 0, alpha: 1 - CGFloat(alphaChange))
                }
            } else {
                if let symbol = dataModel.dataSC[row]["symbol"] as? String, let priceChange = dataModel.dataSC[row]["priceChange"] as? Double{
                    cell.symbolLabetOutlet.text = symbol
                    let priceChangeString: String = String(format: "%.2f", priceChange)
                    cell.priceChangeLabelOutlet.text = String("\(priceChangeString)%")
                    let alphaChange = 0.25/Double(dataModel.dataSC.count)*Double(row)
                    cell.layer.backgroundColor = .init(red: 255, green: 255, blue: 0, alpha: 1 - CGFloat(alphaChange))
                }
            }
        } else if selection == 4 {
            if isSearch {
                if let symbol = dataModel.searchedDataS[row]["symbol"] as? String, let priceChange = dataModel.searchedDataS[row]["priceChange"] as? Double{
                    cell.symbolLabetOutlet.text = symbol
                    let priceChangeString: String = String(format: "%.2f", priceChange)
                    cell.priceChangeLabelOutlet.text = String("\(priceChangeString)%")
                    let alphaChange = 0.25/Double(dataModel.searchedDataS.count)*Double(row)
                    cell.layer.backgroundColor = .init(red: 255, green: 0, blue: 0, alpha: 1 - CGFloat(alphaChange))
                }
            }else{
                if let symbol = dataModel.dataS[row]["symbol"] as? String, let priceChange = dataModel.dataS[row]["priceChange"] as? Double{
                    cell.symbolLabetOutlet.text = symbol
                    let priceChangeString: String = String(format: "%.2f", priceChange)
                    cell.priceChangeLabelOutlet.text = String("\(priceChangeString)%")
                    let alphaChange = 0.25/Double(dataModel.dataS.count)*Double(row)
                    cell.layer.backgroundColor = .init(red: 255, green: 0, blue: 0, alpha: 1 - CGFloat(alphaChange))
                }
            }
        } else if selection == 5 {
            if isSearch {
                if let symbol = dataModel.searchedDataLU[row]["symbol"] as? String, let priceChange = dataModel.searchedDataLU[row]["priceChange"] as? Double{
                    cell.symbolLabetOutlet.text = symbol
                    let priceChangeString: String = String(format: "%.2f", priceChange)
                    cell.priceChangeLabelOutlet.text = String("\(priceChangeString)%")
                    let alphaChange = 0.25/Double(dataModel.searchedDataLU.count)*Double(row)
                    cell.layer.backgroundColor = .init(red: 0, green: 255, blue: 255, alpha: 1 - CGFloat(alphaChange))
                }
            }else{
                if let symbol = dataModel.dataLU[row]["symbol"] as? String, let priceChange = dataModel.dataLU[row]["priceChange"] as? Double{
                    cell.symbolLabetOutlet.text = symbol
                    let priceChangeString: String = String(format: "%.2f", priceChange)
                    cell.priceChangeLabelOutlet.text = String("\(priceChangeString)%")
                    let alphaChange = 0.25/Double(dataModel.dataLU.count)*Double(row)
                    cell.layer.backgroundColor = .init(red: 0, green: 255, blue: 255, alpha: 1 - CGFloat(alphaChange))
                }
            }
        }
    }
    
    func resetAlphaCount(){
        alphaL = 0
        alphaLU = 0
        alphaS = 0
        alphaSC = 0
    }
}

