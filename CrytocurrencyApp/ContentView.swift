//
//  ContentView.swift
//  CrytocurrencyApp
//
//  Created by Najran Emarah on 02/05/1445 AH.
//

import SwiftUI

struct ListCellView: View {
    
    @State var marketData: MarketData
    var body: some View {
        HStack{
           
            iconView(marketData: marketData)
                .frame(width: 50, height: 50)
                .padding(.leading,15)
           
            
        VStack{
            Text(marketData.symbol!)
                .font(.headline)
                .font(Font.body.bold())
            Text(marketData.name! )
                .font(.subheadline)
        }
        .padding(.leading, 5)
            Image((marketData.quote?.usd?.volumeChange24H!)! < 0.0 ? "redWave" :  "greenWave")
                .frame(width: 80)
               
       
           
        VStack{
            Text((marketData.quote?.usd?.getPrice())!)
                .font(.headline)
                .font(Font.body.bold())
                .padding(.trailing)
            Text((marketData.quote?.usd?.getPercentageChange24H())!)
                .font(.subheadline)
                .foregroundStyle((marketData.quote?.usd?.volumeChange24H!)! < 0.0 ? Color.red :  Color.green)
                
        }
       
    }
        
    }
}
struct iconView: View {
    
    @State var  marketData: MarketData
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                
                if self.imageLoader.image != nil {
                    Image(uiImage: self.imageLoader.image!)
                        .resizable()
                }
            }
            .aspectRatio(16/9, contentMode: .fit)
            .cornerRadius(8)
            .shadow(radius: 4)
        }
        .lineLimit(1)
        .onAppear {
            if let url = self.marketData.getIconURL(){
                self.imageLoader.loadImage(with: url)
            }
        }
    }
}
struct ContentView: View {
    @ObservedObject var viewModel: CryptoCurrencyViewModel = CryptoCurrencyViewModel()
    @State var searchText = ""
    
    @State var gColor: Color = Color(red: 229.0/255, green: 250.0/255, blue: 230.0/255, opacity: 0.4)
    @State var rColor: Color = Color(red: 252/255, green: 61/255, blue: 1/255, opacity: 0.4)
   
    var body: some View {
        VStack {
            HStack{
                Text("EXCHANGES")
                  Spacer()
                Button("", systemImage: "bell") {
                    
                }
                .foregroundColor(.black)
                Button("", systemImage: "gearshape") {
                    
                }
                .foregroundColor(.black)

            }
            HStack{
                HStack(spacing: 2){
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search Cryptocurrency here..", text: $searchText)
                }
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.init(white: 0.8))
                }
               
                Spacer()
                Menu("Filter", image: .filterIcon ) {
                    Button {
                        viewModel.filterByPrice()
                    } label: {
                       Text("Sort crytocurrencies by price")
                    }

                    Button {
                        viewModel.filterByVolume24H()
                    } label: {
                        Text("Sort crytocurrencies by volume_24h")
                    }
                }
                .foregroundColor(.gray)
                .fontWidth(Font.Width(15))
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(.gray)
                }
                
                
            }
            HStack{
                Text("Cryptocurrency :")
                   
                    .fontWeight(.heavy)
                Text("NFT")
                Spacer()
            }
            VStack{
                    HStack{
                        if viewModel.bitCoinData != nil{
                            iconView(marketData: viewModel.bitCoinData!)
                            .frame(width: 50, height: 50)
                            .padding(.leading,15)
                        }
                        
                    VStack{
                        Text(viewModel.bitCoinData?.symbol ?? "No bitcoin data")
                            .font(.headline)
                            .font(Font.body.bold())
                        Text(viewModel.bitCoinData?.name ?? "No bitcoin data")
                            .font(.subheadline)
                    }
                    .padding(.leading, 5)
                    Spacer()
                        if let usdData = viewModel.bitCoinData?.quote?.usd{
                            VStack{
                                
                                Text( usdData.getPrice())
                                    .font(.headline)
                                    .font(Font.body.bold())
                                  
                                Text(usdData.getPercentageChange24H())
                                    .font(.subheadline)
                                    .foregroundStyle(viewModel.isRed ? Color.red : Color.green)
                                    
                            }
                            
                        }
                   
                }
                    .padding(.top,50)
                    .frame(height: 40)
                Image(viewModel.isRed ? "redBaseIcon" : "greenBaseIcon" )
            
            }
            
            .frame(width: 380, height: 150)
            .background(viewModel.isRed ? rColor : gColor)
              .cornerRadius(15)
            HStack{
                Text("Top Cryptocurrencies")
                   
                    .fontWeight(.heavy)
                Spacer()
                Button("View All") {
                    viewModel.getAllRecord()
                }
                .foregroundColor(.gray)
            }
            if !viewModel.bitCoinDataRecords.isEmpty{
                ScrollView(.vertical){
                    ForEach((1...(viewModel.bitCoinDataRecords.count )), id: \.self) { indx in
                        ListCellView(marketData: viewModel.bitCoinDataRecords[indx-1])
                            .frame( height: 100)
                    }
                }
            }
            Spacer()
            HStack{
                Button {
                        
                    } label: {
                        VStack{
                            Image("Face")
                            Text("€-$hop")
                                .foregroundColor(.gray)
                                .font(.footnote)
                                .padding(.top,-5)
                        }
                        .padding(.top,10)
                        .frame(width: 70)
                    }
               
                Button {
                        
                    } label: {
                        VStack{
                            Image("Exchange")
                            Text("Exchange")
                                .foregroundColor(.gray)
                                .font(.footnote)
                                .padding(.top,-5)
                        }
                        .padding(.top,10)
                        .frame(width: 70)
                    }
                Button {
                        
                    } label: {
                        VStack{
                            Image("World")
                           
                        }
                        .padding(.bottom,20)
                        .frame(width: 80)
                    }
               
                Button {
                        
                    } label: {
                        VStack{
                            Image("LunchPad")
                            Text("Lunchpads")
                                .foregroundColor(.gray)
                                .font(.footnote)
                                .padding(.top,-5)
                        }
                        .padding(.top,10)
                        .frame(width: 70)
                    }
                Spacer()
                Button {
                        
                    } label: {
                        VStack{
                            Image("Wallet")
                           
                        }
                        .padding(.top,10)
                        .frame(width: 70)
                    }
            }
            
            .frame(width: 390, height: 80)
            .background(.black)
              .cornerRadius(15)

           
           
           
        }
        .padding()
        .onAppear {
            viewModel.getCrypytoCurrencyData()
        }
    }
}

#Preview {
    ContentView()
}
