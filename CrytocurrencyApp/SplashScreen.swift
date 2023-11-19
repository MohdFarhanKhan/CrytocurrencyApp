//
//  SplashScreen.swift
//  CrytocurrencyApp
//
//  Created by Najran Emarah on 05/05/1445 AH.
//

import SwiftUI

struct SplashScreen: View {
    @State var isActive: Bool = false
    var body: some View {
        VStack{
            if self.isActive == false{
                Image("SplashScreen")
                    .resizable()
                    .scaledToFit()
            }
            else{
                ContentView()
            }
            
        }
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                withAnimation {
                   self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
