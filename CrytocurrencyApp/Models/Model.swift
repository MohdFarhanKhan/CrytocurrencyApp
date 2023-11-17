//
//  Model.swift
//  CrytocurrencyApp
//
//  Created by Najran Emarah on 02/05/1445 AH.
//

import Foundation

struct LatestListing: Codable {
    let status: Status?
    let data: [MarketData]?
    
  
    enum CodingKeys:String, CodingKey {
        case status = "status"
        case data = "data"
      
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Status.self, forKey: .status)
        data = try values.decodeIfPresent([MarketData].self, forKey: .data)
    }
}

// MARK: - Datum
struct MarketData: Codable,Equatable {
    static func == (lhs: MarketData, rhs: MarketData) -> Bool {
        return true
    }
    
    let id: Int?
    let name, symbol, slug: String?
    let numMarketPairs: Int?
    let dateAdded: String?
    let tags: [String]?
    let maxSupply: Int?
    let circulatingSupply, totalSupply: Double?
    let infiniteSupply: Bool?
    let platform: Platform?
    let cmcRank: Int?
    let selfReportedCirculatingSupply, selfReportedMarketCap, tvlRatio: Double?
    let lastUpdated: String?
    let quote: Quote?
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case name = "name"
        case symbol = "symbol"
        case slug = "slug"
        case numMarketPairs = "num_market_pairs"
        case dateAdded = "date_added"
        case tags = "tags"
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case infiniteSupply = "infinite_supply"
        case platform = "platform"
        case cmcRank = "cmc_rank"
        case selfReportedCirculatingSupply = "self_reported_circulating_supply"
        case selfReportedMarketCap = "self_reported_market_cap"
        case tvlRatio = "tvl_ratio"
        case lastUpdated = "last_updated"
        case quote = "quote"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        numMarketPairs = try values.decodeIfPresent(Int.self, forKey: .numMarketPairs)
        dateAdded = try values.decodeIfPresent(String.self, forKey: .dateAdded)
        tags = try values.decodeIfPresent([String].self, forKey: .tags)
        maxSupply = try values.decodeIfPresent(Int.self, forKey: .maxSupply)
        circulatingSupply = try values.decodeIfPresent(Double.self, forKey: .circulatingSupply)
        totalSupply = try values.decodeIfPresent(Double.self, forKey: .totalSupply)
        infiniteSupply = try values.decodeIfPresent(Bool.self, forKey: .infiniteSupply)
        platform = try values.decodeIfPresent(Platform.self, forKey: .platform)
        cmcRank = try values.decodeIfPresent(Int.self, forKey: .cmcRank)
        selfReportedCirculatingSupply = try values.decodeIfPresent(Double.self, forKey: .selfReportedCirculatingSupply)
        selfReportedMarketCap = try values.decodeIfPresent(Double.self, forKey: .selfReportedMarketCap)
        tvlRatio = try values.decodeIfPresent(Double.self, forKey: .tvlRatio)
        lastUpdated = try values.decodeIfPresent(String.self, forKey: .lastUpdated)
        quote = try values.decodeIfPresent(Quote.self, forKey: .quote)
    }
    func getIconURL()->URL?{
        if let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(id ?? -1).png") {
            return url
        }
       return nil
    }
    
}



// MARK: - Platform
struct Platform: Codable {
    let id: Int?
    let name, symbol, slug, tokenAddress: String?
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case name = "name"
        case symbol = "symbol"
        case slug = "slug"
        case tokenAddress = "token_address"
      
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        tokenAddress = try values.decodeIfPresent(String.self, forKey: .tokenAddress)
    }
}

// MARK: - Quote
struct Quote : Codable{
    let usd: Usd?
    enum CodingKeys:String, CodingKey {
        case usd = "USD"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        usd = try values.decodeIfPresent(Usd.self, forKey: .usd)
       
    }
}

// MARK: - Usd
struct Usd: Codable {
    let price, volume24H, volumeChange24H, percentChange1H: Double?
    let percentChange24H, percentChange7D, percentChange30D, percentChange60D: Double?
    let percentChange90D, marketCap, marketCapDominance, fullyDilutedMarketCap: Double?
    let tvl: Double?
    let lastUpdated: String?
    enum CodingKeys:String, CodingKey {
        case price = "price"
        case volume24H = "volume_24h"
        case volumeChange24H = "volume_change_24h"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case percentChange30D = "percent_change_30d"
        case percentChange60D = "percent_change_60d"
        case percentChange90D = "percent_change_90d"
        case marketCap = "market_cap"
        case marketCapDominance = "market_cap_dominance"
        case fullyDilutedMarketCap = "fully_diluted_market_cap"
        case tvl = "tvl"
        case lastUpdated = "last_updated"
       
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        volume24H = try values.decodeIfPresent(Double.self, forKey: .volume24H)
        volumeChange24H = try values.decodeIfPresent(Double.self, forKey: .volumeChange24H)
        percentChange1H = try values.decodeIfPresent(Double.self, forKey: .percentChange1H)
        percentChange24H = try values.decodeIfPresent(Double.self, forKey: .percentChange24H)
        percentChange7D = try values.decodeIfPresent(Double.self, forKey: .percentChange7D)
        percentChange30D = try values.decodeIfPresent(Double.self, forKey: .percentChange30D)
        percentChange60D = try values.decodeIfPresent(Double.self, forKey: .percentChange60D)
        percentChange90D = try values.decodeIfPresent(Double.self, forKey: .percentChange90D)
        marketCap = try values.decodeIfPresent(Double.self, forKey: .marketCap)
        marketCapDominance = try values.decodeIfPresent(Double.self, forKey: .marketCapDominance)
        fullyDilutedMarketCap = try values.decodeIfPresent(Double.self, forKey: .fullyDilutedMarketCap)
        tvl = try values.decodeIfPresent(Double.self, forKey: .tvl)
        lastUpdated = try values.decodeIfPresent(String.self, forKey: .lastUpdated)
    }
    func getPrice()->String{
        if let price = self.price{
            return String(format: "$%.2f USD", price)
        }
       return "No Price"
    }
    func isPercentageChange24HNegative()->Bool{
        if let percentage = self.percentChange24H{
            if percentage >= 0{
               
                return false
            }
            else{
                return true
            }
        }
        return false
    }
    func getPercentageChange24H()->String{
        if let percentage = self.percentChange24H{
            if percentage >= 0{
                var percentString = String(format: "+%.2f", percentage)
                percentString += "%"
                return percentString
            }
            else{
                var percentString = String(format: "%.2f", percentage)
                percentString += "%"
                return percentString
            }
        }
       return "0 %"
    }
}

// MARK: - Status
struct Status: Codable {
    let timestamp: String?
    let errorCode: Int?
    let errorMessage: String?
    let elapsed, creditCount: Int?
    let notice: String?
    let totalCount: Int?
    enum CodingKeys:String, CodingKey {
        case timestamp = "timestamp"
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed = "elapsed"
        case creditCount = "credit_count"
        case notice = "notice"
        case totalCount = "total_count"
        
       
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        errorCode = try values.decodeIfPresent(Int.self, forKey: .errorCode)
        errorMessage = try values.decodeIfPresent(String.self, forKey: .errorMessage)
        elapsed = try values.decodeIfPresent(Int.self, forKey: .elapsed)
        creditCount = try values.decodeIfPresent(Int.self, forKey: .creditCount)
        notice = try values.decodeIfPresent(String.self, forKey: .notice)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
    }
}
