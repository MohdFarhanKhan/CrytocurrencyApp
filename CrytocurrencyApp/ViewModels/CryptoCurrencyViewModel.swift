//
//  CryptoCurrencyViewModel.swift
//  CrytocurrencyApp
//
//  Created by Najran Emarah on 02/05/1445 AH.
//

import Foundation
import UIKit
import Combine

class CryptoCurrencyViewModel:ObservableObject, Identifiable {
   
    
    @Published var latestListingData: LatestListing?
    @Published var bitCoinData: MarketData?
    @Published var bitCoinDataRecords: [MarketData] = []
    
    @Published var isRed = false
    @Published var is20Record = true
    @Published var isFilterByCMC = true
    @Published var isFilterByPrice = false
    @Published var isFilterByVolume24h = false
    @Published var searhText = ""
    var cancellable: AnyCancellable?
    var error : APIDataError?
     init(){
        cancellable = $searhText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
               
                    self.searchMarketData(text: value)
               
               
            })
    }
    func searchMarketData(text: String){
        if let marketData = latestListingData, !marketData.data!.isEmpty{
            bitCoinDataRecords.removeAll()
            for data in marketData.data!{
                if data.symbol != bitCoinData!.symbol {
                    if text.isEmpty{
                        if is20Record == false{
                            bitCoinDataRecords.append(data)
                        }
                        else if bitCoinDataRecords.count < 20{
                            bitCoinDataRecords.append(data)
                        }
                    }
                    else if (data.name?.lowercased().contains(text.lowercased()))! || (data.symbol?.lowercased().contains(text.lowercased()))!{
                        if is20Record == false{
                            bitCoinDataRecords.append(data)
                        }
                        else if bitCoinDataRecords.count < 20{
                            bitCoinDataRecords.append(data)
                        }
                    }
                   
                   
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
    }
    func selectMarketData(marketData: MarketData){
        if latestListingData != nil, !latestListingData!.data!.isEmpty{
            bitCoinDataRecords.removeAll()
            for data in latestListingData!.data!{
               
                if data.id == marketData.id{
                    isRed = (data.quote!.usd?.isPercentageChange24HNegative())! ? true : false
                    bitCoinData = data
                    
                    
                }
                else if bitCoinDataRecords.count < 20 && is20Record{
                    bitCoinDataRecords.append(data)
                }
                else if !is20Record{
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
    }
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
                            isRed = (data.quote!.usd?.isPercentageChange24HNegative())! ? true : false
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
                if data.symbol != bitCoinData!.symbol{
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
           let records =
            bitCoinDataRecords.sorted { $0.cmcRank! < $1.cmcRank! }
            self.bitCoinDataRecords.removeAll()
            for data in records{
                self.bitCoinDataRecords.append(data)
            }
           // print(self.bitCoinDataRecords)
           
        }
    }
    func filterByPrice(){
        isFilterByCMC = false
       isFilterByPrice = true
       isFilterByVolume24h = false
        if !bitCoinDataRecords.isEmpty{
            
            let records  = bitCoinDataRecords.sorted { ($0.quote?.usd?.price!)! < ($1.quote?.usd?.price!)! }
            self.bitCoinDataRecords.removeAll()
            for data in records{
                self.bitCoinDataRecords.append(data)
            }
           // print(self.bitCoinDataRecords)
        }
    }
    func filterByVolume24H(){
        isFilterByCMC = false
       isFilterByPrice = false
       isFilterByVolume24h = true
        if !bitCoinDataRecords.isEmpty{
            
            let records  = bitCoinDataRecords.sorted { ($0.quote?.usd?.volumeChange24H!)! < ($1.quote?.usd?.volumeChange24H!)! }
            self.bitCoinDataRecords.removeAll()
            for data in records{
                self.bitCoinDataRecords.append(data)
            }
           // print(self.bitCoinDataRecords)
        }
    }
}
