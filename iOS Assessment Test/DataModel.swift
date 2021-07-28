//
//  DataModel.swift
//  iOS Assessment Test
//
//  Created by Sourav Bhattacharjee on 28/07/21.
//

import Foundation
import Alamofire

class DataModel {
    
    var dataSC : [[String:Any]] = [[:]]
    var dataL : [[String:Any]] = [[:]]
    var dataS : [[String:Any]] = [[:]]
    var dataLU : [[String:Any]] = [[:]]
    var combinedData : [[String:Any]] = [[:]]
    
    var searchedDataSC : [[String:Any]] = [[:]]
    var searchedDataL : [[String:Any]] = [[:]]
    var searchedDataS : [[String:Any]] = [[:]]
    var searchedDataLU : [[String:Any]] = [[:]]
    var searchedCombinedData : [[String:Any]] = [[:]]
    
    var numberOfDataS = 0
    var numberOfDataSC = 0
    var numberOfDataL = 0
    var numberOfDataLU = 0
    
    var numberOfSearchedDataS = 0
    var numberOfSearchedDataSC = 0
    var numberOfSearchedDataL = 0
    var numberOfSearchedDataLU = 0
    
    func getPriceChange(url: URL, completion: @escaping (Bool) -> ()) {
        clearArrays()
        let request = AF.request(url)
        request.responseJSON(completionHandler: {response in
            if let error = response.error {
                print(error.localizedDescription)
                return
            }else if let dataDictionary = response.value as? [String:Any]{
                for data in dataDictionary {
                    
                    var symbol : String = ""
                    var priceChange : Double = 0.0
                    
                    if let value = data.value as? String {
                        let valueArray = value.components(separatedBy: ";")
                        for element in valueArray {
                            symbol = element.components(separatedBy: ",")[0]
                            if let changeOfPrice = Double(element.components(separatedBy: ",")[3]) {
                                priceChange = changeOfPrice*100
                            }
                            if data.key == "sc" {
                                self.dataSC.append(["symbol":symbol,"priceChange":priceChange])
                                self.numberOfDataSC += 1
                            } else if data.key == "l" {
                                self.dataL.append(["symbol":symbol,"priceChange":priceChange])
                                self.numberOfDataL += 1
                            } else if data.key == "s" {
                                self.dataS.append(["symbol":symbol,"priceChange":priceChange])
                                self.numberOfDataS += 1
                            } else if data.key == "lu" {
                                self.dataLU.append(["symbol":symbol,"priceChange":priceChange])
                                self.numberOfDataLU += 1
                            }
                            self.combinedData.append(["symbol":symbol,"priceChange":priceChange, "category": data.key])
                        }
                    }
                }
            }
            self.dataSC = (self.dataSC as NSArray).sortedArray(using: [NSSortDescriptor(key: "priceChange", ascending: false)]) as! [[String:Any]]
            self.dataS = (self.dataS as NSArray).sortedArray(using: [NSSortDescriptor(key: "priceChange", ascending: false)]) as! [[String:Any]]
            self.dataL = (self.dataL as NSArray).sortedArray(using: [NSSortDescriptor(key: "priceChange", ascending: false)]) as! [[String:Any]]
            self.dataLU = (self.dataLU as NSArray).sortedArray(using: [NSSortDescriptor(key: "priceChange", ascending: false)]) as! [[String:Any]]
            self.combinedData = (self.combinedData as NSArray).sortedArray(using: [NSSortDescriptor(key: "priceChange", ascending: false)]) as! [[String:Any]]
            completion(true)
        })
    }
    
    
    func searchedData(searchString: String, selection: Int) {
        clearSearchedArrays()
        if selection == 1 {
            for element in combinedData {
                if let symbol = element["symbol"] as? String, let priceChange = element["priceChange"] as? Double, let category = element["category"] as? String{
                    if symbol.contains(searchString.uppercased()) {
                        searchedCombinedData.append(["symbol":symbol,"priceChange":priceChange, "category": category])
                        if category == "s" {
                            self.numberOfSearchedDataS += 1
                        } else if category == "sc" {
                            self.numberOfSearchedDataSC += 1
                        } else if category == "l" {
                            self.numberOfSearchedDataL += 1
                        } else if category == "lu" {
                            self.numberOfSearchedDataLU += 1
                        }
                    }
                }
            }
        } else if selection == 2 {
            for element in dataL {
                if let symbol = element["symbol"] as? String, let priceChange = element["priceChange"] as? Double{
                    if symbol.contains(searchString.uppercased()) {
                        searchedDataL.append(["symbol":symbol,"priceChange":priceChange])
                    }
                }
            }
        } else if selection == 3 {
            for element in dataSC {
                if let symbol = element["symbol"] as? String, let priceChange = element["priceChange"] as? Double{
                    if symbol.contains(searchString.uppercased()) {
                        searchedDataSC.append(["symbol":symbol,"priceChange":priceChange])
                    }
                }
            }
        } else if selection == 4 {
            for element in dataS {
                if let symbol = element["symbol"] as? String, let priceChange = element["priceChange"] as? Double{
                    if symbol.contains(searchString.uppercased()) {
                        searchedDataS.append(["symbol":symbol,"priceChange":priceChange])
                    }
                }
            }
        } else if selection == 5 {
            for element in dataLU {
                if let symbol = element["symbol"] as? String, let priceChange = element["priceChange"] as? Double{
                    if symbol.contains(searchString.uppercased()) {
                        searchedDataLU.append(["symbol":symbol,"priceChange":priceChange])
                    }
                }
            }
        }
    }
    
    func clearArrays() {
        dataL.removeAll()
        dataLU.removeAll()
        dataS.removeAll()
        dataSC.removeAll()
        combinedData.removeAll()
    }
    
    func clearSearchedArrays() {
        searchedDataL.removeAll()
        searchedDataLU.removeAll()
        searchedDataS.removeAll()
        searchedDataSC.removeAll()
        searchedCombinedData.removeAll()
    }
}
