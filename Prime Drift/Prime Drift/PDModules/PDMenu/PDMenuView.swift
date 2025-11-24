//
//  PDMenuView.swift
//  Prime Drift
//
//

import SwiftUI

struct PDMenuView: View {
    @State private var showGame = false
    @State private var showAchievement = false
    @State private var showSettings = false
    @State private var showCalendar = false
    @State private var showDailyReward = false
    @State private var showShop = false
        
    @StateObject private var settingsVM = CPSettingsViewModel()
    var body: some View {
        
        ZStack {
                
                VStack(spacing: 124) {
                    
                    
                    Image(.menuLogoPD)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 140:190)
                    
                    
                    VStack(spacing: 32) {
                        
                        Button {
                            showGame = true
                        } label: {
                            Image(.playIconPD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:70)
                        }
                        
                        Button {
                            showSettings = true
                        } label: {
                            Image(.settingsconPD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:70)
                        }
                                            
                        Button {
                            showAchievement = true
                        } label: {
                            Image(.achievementsconPD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:70)
                        }
                    }
                    
                }
                
            
            
            if showSettings {
                ZStack {
                    Color.black
                        .opacity(0.5).ignoresSafeArea()
                    
                    ZStack {
                        Image(.settingsViewBgPD)
                            .resizable()
                            .scaledToFit()
                        VStack {
                        VStack(spacing: 24) {
                            HStack {
                                Image(.soundTextPD)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                Spacer()
                                HStack {
                                    Image(settingsVM.soundEnabled ? .onPD : .onOffPD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                    
                                    Image(settingsVM.soundEnabled ? .offOffPD : .offPD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                }.onTapGesture {
                                    settingsVM.soundEnabled.toggle()
                                }
                            }
                            
                            HStack {
                                Image(.musicTextPD)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                Spacer()
                                HStack {
                                    Image(settingsVM.musicEnabled ? .onPD : .onOffPD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                    
                                    Image(settingsVM.musicEnabled ? .offOffPD : .offPD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                }.onTapGesture {
                                    settingsVM.musicEnabled.toggle()
                                }
                            }
                            
                            HStack {
                                Image(.vibrationTextPD)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                Spacer()
                                HStack {
                                    Image(settingsVM.vibraEnabled ? .onPD : .onOffPD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                    
                                    Image(settingsVM.vibraEnabled ? .offOffPD : .offPD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                }.onTapGesture {
                                    settingsVM.vibraEnabled.toggle()
                                }
                            }
                            
                            HStack {
                                Image(.languageTextPD)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 25)
                                Spacer()
                                HStack {
                                    Image(.englishBtnPD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                }
                            }
                        }.padding(.horizontal, 24).frame(maxWidth: 342)
                            Spacer()
                            Button {
                                showSettings.toggle()
                            } label: {
                                Image(.backBtnPD)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                            }
                        }.padding(.top, 100).padding(.bottom, 40)
                    }.frame(maxHeight: 410)
                }
            }
            
            
        }.frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Image(.appBgPD)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
            )
            .fullScreenCover(isPresented: $showGame) {
                BeetleColorPuzzleView()
            }
            .fullScreenCover(isPresented: $showAchievement) {
                PDAchievementsView()
            }
        
    }
}

#Preview {
    PDMenuView()
}
