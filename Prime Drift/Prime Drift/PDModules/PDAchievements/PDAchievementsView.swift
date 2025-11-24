//
//  PDAchievementsView.swift
//  Prime Drift
//
//

import SwiftUI

struct PDAchievementsView: View {
    @StateObject var user = ZZUser.shared
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = ZZAchievementsViewModel()
    @State private var index = 0
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
                
                
                VStack {
                    
                    Image(.achievementsTextPD)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:30)
                        .padding(.bottom)
                    
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(viewModel.achievements, id: \.self) { item in
                                Image(item.isAchieved ? item.image : "\(item.image)Off")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 110)
                                    .onTapGesture {
                                        if item.isAchieved {
                                            user.updateUserMoney(for: 10)
                                        }
                                        viewModel.achieveToggle(item)
                                    }
                                
                            }
                        }
                    }
                    
                }
                
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
    PDAchievementsView()
}
