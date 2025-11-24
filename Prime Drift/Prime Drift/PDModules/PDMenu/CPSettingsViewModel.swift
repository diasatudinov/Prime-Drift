//
//  CPSettingsViewModel.swift
//  Prime Drift
//
//


import SwiftUI

class CPSettingsViewModel: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    @AppStorage("vibraEnabled") var vibraEnabled: Bool = true
}
