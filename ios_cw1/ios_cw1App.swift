//
//  ios_cw1App.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI

@main
struct ios_cw1App: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("hasBooked") private var hasBooked = false
    @StateObject private var appointmentStore = AppointmentStore()

    var body: some Scene {
        WindowGroup {
            if hasBooked {
                HomeView()
                    .environmentObject(appointmentStore)
            } else if hasSeenOnboarding {
                NewCustomerHomeView(onBookingComplete: {
                    hasBooked = true
                })
                .environmentObject(appointmentStore)
            } else {
                OnboardingView()
                    .environmentObject(appointmentStore)
            }
        }
    }
}
