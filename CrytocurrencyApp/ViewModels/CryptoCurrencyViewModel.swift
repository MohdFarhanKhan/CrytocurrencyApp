//
//  CryptoCurrencyViewModel.swift
//  CrytocurrencyApp
//
//  Created by Najran Emarah on 02/05/1445 AH.
//

import Foundation


class CryptoCurrencyViewModel:ObservableObject {
   
     init() {}
    @Published var latestListingData: LatestListing?
    @Published var bitCoinData: MarketData?
    @Published var bitCoinDataRecords: [MarketData] = []
    @Published var isRed = false
    @Published var is20Record = true
    @Published var isFilterByCMC = true
    @Published var isFilterByPrice = false
    @Published var isFilterByVolume24h = false
    var error : APIDataError?
    func getCrypytoCurrencyData(){
       
        HttpUtility.shared.getLatestCryptocurrencyData { [self] result in
            switch result{
            case .success(let response):
                latestListingData = response
                if let marketData = latestListingData, !marketData.data!.isEmpty{
                    bitCoinDataRecords.removeAll()
                    for data in marketData.data!{
                        is20Record = true
                        if data.symbol == "BTC"{
                            isRed = (data.quote!.usd?.volumeChange24H!)! < 0.0 ? true : false
                            bitCoinData = data
                        }
                        else if bitCoinDataRecords.count < 20{
                            bitCoinDataRecords.append(data)
                        }
                       
                    }
                    if isFilterByCMC {
                        filterByCMC()
                    }
                    else if isFilterByPrice {
                        filterByPrice()
                    }
                    else if isFilterByVolume24h {
                       filterByVolume24H()
                    }
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
    func getAllRecord(){
        if let marketData = latestListingData, !marketData.data!.isEmpty{
           
            bitCoinDataRecords.removeAll()
            for data in marketData.data!{
                if data.symbol != "BTC"{
                    if is20Record == true{
                        bitCoinDataRecords.append(data)
                    }
                    else if bitCoinDataRecords.count < 20{
                        bitCoinDataRecords.append(data)
                    }
                   
                }
                
            }
            is20Record = !is20Record
            if isFilterByCMC {
                filterByCMC()
            }
            else if isFilterByPrice {
                filterByPrice()
            }
            else if isFilterByVolume24h {
               filterByVolume24H()
            }
            
        }
    }
    func filterByCMC(){
        isFilterByCMC = true
       isFilterByPrice = false
       isFilterByVolume24h = false
        if !bitCoinDataRecords.isEmpty{
            bitCoinDataRecords =
            bitCoinDataRecords.sorted { $0.cmcRank! < $1.cmcRank! }
        }
    }
    func filterByPrice(){
        isFilterByCMC = false
       isFilterByPrice = true
       isFilterByVolume24h = false
        if !bitCoinDataRecords.isEmpty{
            
            bitCoinDataRecords = bitCoinDataRecords.sorted { ($0.quote?.usd?.price!)! < ($1.quote?.usd?.price!)! }
        }
    }
    func filterByVolume24H(){
        isFilterByCMC = false
       isFilterByPrice = false
       isFilterByVolume24h = true
        if !bitCoinDataRecords.isEmpty{
            
            bitCoinDataRecords = bitCoinDataRecords.sorted { ($0.quote?.usd?.volumeChange24H!)! < ($1.quote?.usd?.volumeChange24H!)! }
        }
    }
}
