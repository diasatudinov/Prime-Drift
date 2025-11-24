//
//  PDLevelsView.swift
//  Prime Drift
//
//

import SwiftUI

struct PDLevelsView: View {
    @StateObject var user = ZZUser.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            
            VStack {
                
                HStack(alignment: .center) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(.backIconPD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                    }
                    
                    Spacer()
                    
                    ZZCoinBg()
                    
                }.padding(.horizontal).padding([.top])
                
                Spacer()
                
            }
        }.background(
            ZStack {
                Image(.appBgPD)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            }
        )
    }
}

#Preview {
    PDLevelsView()
}
