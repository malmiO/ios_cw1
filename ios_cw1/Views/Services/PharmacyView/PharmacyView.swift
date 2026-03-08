//
//  PharmacyView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import SwiftUI

struct PharmacyView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = PharmacyViewModel()
    @State private var showPrescriptionUpload = false
    @State private var showOrderTracking = false
    @State private var showPaymentSheet = false
    @State private var navigateToCart = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.96, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer().frame(height: 70)
                    
                    // Active Order Notification Banner (if any)
                    if let activeOrder = viewModel.activeOrders.first {
                        activeOrderBanner(activeOrder)
                    }
                    
                    // Order Medicines Section
                    orderMedicinesSection
                    
                    // Over the Counter Section
                    overTheCounterSection
                    
                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 20)
            }
            
            // Sticky Header
            VStack(spacing: 0) {
                headerSection
            }
            .background(Color(red: 0.90, green: 0.94, blue: 0.98))
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToCart) {
            PharmacyCartView(viewModel: viewModel)
        }
        .sheet(isPresented: $showPrescriptionUpload, onDismiss: {
            // After prescription upload, go directly to cart
            if viewModel.hasPrescription {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    navigateToCart = true
                }
            }
        }) {
            PrescriptionUploadSheet(viewModel: viewModel, isPresented: $showPrescriptionUpload)
                .presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: $showOrderTracking) {
            if let order = viewModel.currentOrder {
                PharmacyOrderTrackingView(
                    viewModel: viewModel,
                    isPresented: $showOrderTracking,
                    order: order
                )
            }
        }
        .sheet(isPresented: $showPaymentSheet) {
            if let order = viewModel.currentOrder {
                PharmacyOrderPaymentSheet(
                    pharmacyViewModel: viewModel,
                    order: order,
                    isPresented: $showPaymentSheet
                )
                .presentationDetents([.large])
            }
        }
        .onChange(of: viewModel.showOrderTracking) { _, newValue in
            showOrderTracking = newValue
        }
        .onChange(of: viewModel.showPaymentSheet) { _, newValue in
            if newValue {
                showPaymentSheet = true
                viewModel.showPaymentSheet = false
            }
        }
        .onChange(of: viewModel.shouldPopToPharmacy) { _, newValue in
            if newValue {
                navigateToCart = false
                viewModel.shouldPopToPharmacy = false
            }
        }
    }
}


// Header Section

extension PharmacyView {
    
    var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("ClinicFlow Pharmacy")
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
            
            // Cart Button
            Button(action: { navigateToCart = true }) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "cart")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    
                    if viewModel.cartItemCount > 0 {
                        Text("\(viewModel.cartItemCount)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 8, y: -8)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}


// Active Order Notification Banner

extension PharmacyView {
    
    func activeOrderBanner(_ order: PharmacyOrder) -> some View {
        VStack(spacing: 0) {
            switch order.status {
            case .prescriptionUploaded, .underReview:
                reviewingBanner(order)
            case .readyForPayment:
                payNowBanner(order)
            case .paymentCompleted, .preparingMedicine:
                preparingBanner(order)
            case .readyForPickup:
                pickupReadyBanner(order)
            default:
                defaultBanner(order)
            }
        }
    }
    
    // Reviewing banner - waiting for pharmacist
    func reviewingBanner(_ order: PharmacyOrder) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "eye.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.orderNumber)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Waiting for pharmacist to review your prescription...")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            HStack(spacing: 8) {
                ProgressView()
                    .scaleEffect(0.8)
                
                Text("Please wait, this may take a few minutes")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.05))
            .cornerRadius(8)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // Pay Now banner - prescription reviewed, ready to pay
    func payNowBanner(_ order: PharmacyOrder) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.orange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Prescription Reviewed ✅")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Your prescription has been approved. Total: LKR \(String(format: "%.2f", order.totalAmount))")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Button(action: {
                viewModel.currentOrder = order
                showPaymentSheet = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 16))
                    Text("Pay Now - LKR \(String(format: "%.2f", order.totalAmount))")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(red: 0.15, green: 0.35, blue: 0.75))
                .cornerRadius(12)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // Preparing banner - payment done, preparing order
    func preparingBanner(_ order: PharmacyOrder) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "pills.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Order #\(order.orderNumber)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Payment received! Preparing your medicines...")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            ProgressView()
                .scaleEffect(0.9)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // Pickup ready banner - with queue number and counter
    func pickupReadyBanner(_ order: PharmacyOrder) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "bag.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order Ready")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Pick up at Pharmacy Counter \(order.counterNumber ?? 3)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.green)
                }
                
                Spacer()
            }
            
            // Queue info card
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("QUEUE")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                        .tracking(1)
                    
                    Text(order.queueNumber ?? "Q-7")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(red: 0.90, green: 0.94, blue: 0.98))
                .cornerRadius(10)
                
                VStack(spacing: 4) {
                    Text("COUNTER")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                        .tracking(1)
                    
                    Text("\(order.counterNumber ?? 3)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(red: 0.90, green: 0.94, blue: 0.98))
                .cornerRadius(10)
                
                VStack(spacing: 4) {
                    Text("WAIT")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                        .tracking(1)
                    
                    Text("~5 min")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(red: 0.90, green: 0.94, blue: 0.98))
                .cornerRadius(10)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // Default banner for other statuses
    func defaultBanner(_ order: PharmacyOrder) -> some View {
        Button(action: {
            viewModel.currentOrder = order
            showOrderTracking = true
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(statusColor(for: order.status).opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: order.status.icon)
                        .font(.system(size: 22))
                        .foregroundColor(statusColor(for: order.status))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.orderNumber)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(order.status.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(order.estimatedTime)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(statusColor(for: order.status))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    func statusColor(for status: PharmacyOrderStatus) -> Color {
        switch status {
        case .completed, .readyForPickup:
            return .green
        case .cancelled:
            return .red
        case .readyForPayment:
            return .orange
        default:
            return Color(red: 0.15, green: 0.35, blue: 0.75)
        }
    }
}


// Order Medicines Section

extension PharmacyView {
    
    var orderMedicinesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Medicine")
                .font(.system(size: 18, weight: .semibold))
            
            VStack(spacing: 12) {
                // Upload Icon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.90, green: 0.94, blue: 0.98))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "square.and.arrow.up.on.square")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                }
                
                Text("Upload Prescription")
                    .font(.system(size: 16, weight: .semibold))
                
                Text("Have a doctor's prescription? Upload it\nsecurely and we'll prepare your medication.")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Button(action: { showPrescriptionUpload = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "camera")
                            .font(.system(size: 14))
                        
                        Text("Scan or Upload")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.black)
                    .cornerRadius(22)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(18)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
                    .foregroundColor(Color.gray.opacity(0.3))
            )
        }
    }
}


// Over the Counter Section

extension PharmacyView {
    
    var overTheCounterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Over the Counter")
                .font(.system(size: 18, weight: .semibold))
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(viewModel.otcCategories) { category in
                    NavigationLink(destination: MedicineListView(viewModel: viewModel, initialCategory: category)) {
                        OTCCategoryCard(
                            icon: category.icon,
                            title: category.rawValue,
                            iconColor: category.iconColor,
                            bgColor: category.bgColor
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}


// OTC Category Card

struct OTCCategoryCard: View {
    let icon: String
    let title: String
    let iconColor: Color
    let bgColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(bgColor)
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(iconColor)
            }
            
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}


#Preview {
    NavigationStack {
        PharmacyView()
    }
}


