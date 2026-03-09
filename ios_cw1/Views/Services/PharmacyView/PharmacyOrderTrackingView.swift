//
//  PharmacyOrderTrackingView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import SwiftUI

struct PharmacyOrderTrackingView: View {
    
    @ObservedObject var viewModel: PharmacyViewModel
    @Binding var isPresented: Bool
    let order: PharmacyOrder
    
    @State private var showPaymentOptions = false
    @State private var showShareSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Order Header
                    orderHeaderSection
                    
                    // QR Code Section
                    qrCodeSection
                    
                    // Status Timeline
                    statusTimelineSection
                    
                    // Order Details
                    if !order.medicines.isEmpty {
                        orderDetailsSection
                    }
                    
                    // Payment Section (if not paid)
                    if !order.isPaid && order.status == .readyForPayment {
                        paymentSection
                    }
                    
                    // Action Buttons
                    actionButtonsSection
                    
                    Spacer().frame(height: 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Order #\(order.orderNumber)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showPaymentOptions) {
                PharmacyOrderPaymentSheet(
                    pharmacyViewModel: viewModel,
                    order: order,
                    isPresented: $showPaymentOptions
                )
                .presentationDetents([.large])
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [orderShareText])
            }
        }
    }
    
    var orderShareText: String {
        """
        🏥 Pharmacy Order #\(order.orderNumber)
        
        Status: \(order.status.rawValue)
        \(order.status.description)
        
        Order Number: \(order.orderNumber)
        Total: LKR \(String(format: "%.2f", order.totalAmount))
        
        Show this or scan the QR code at the pharmacy counter.
        """
    }
}


//  Order Header Section

extension PharmacyOrderTrackingView {
    
    var orderHeaderSection: some View {
        VStack(spacing: 12) {
            // Status Icon
            ZStack {
                Circle()
                    .fill(statusColor.opacity(0.15))
                    .frame(width: 80, height: 80)
                
                Image(systemName: order.status.icon)
                    .font(.system(size: 36))
                    .foregroundColor(statusColor)
            }
            
            // Status Text
            Text(order.status.rawValue)
                .font(.system(size: 22, weight: .bold))
            
            Text(order.status.description)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            // Estimated Time
            if order.status != .completed && order.status != .cancelled {
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                    Text(order.estimatedTime)
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(20)
            }
        }
        .padding(.vertical, 20)
    }
    
    var statusColor: Color {
        switch order.status {
        case .completed, .readyForPickup:
            return .green
        case .cancelled:
            return .red
        case .readyForPayment:
            return .orange
        default:
            return .blue
        }
    }
}


// QR Code Section

extension PharmacyOrderTrackingView {
    
    var qrCodeSection: some View {
        VStack(spacing: 16) {
            Text("Your Order Number")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            // Large Order Number
            Text("#\(order.orderNumber)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
            
            // QR Code
            if let qrImage = viewModel.generateQRCode(for: order) {
                VStack(spacing: 8) {
                    Image(uiImage: qrImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Text("Scan at pharmacy counter")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
    }
}


//  Status Timeline Section

extension PharmacyOrderTrackingView {
    
    var statusTimelineSection: some View {
        let steps = order.orderType == .overTheCounter ?
            PharmacyOrderStatus.otcTrackingSteps :
            PharmacyOrderStatus.trackingSteps
        
        return VStack(alignment: .leading, spacing: 0) {
            Text("Order Progress")
                .font(.system(size: 16, weight: .semibold))
                .padding(.bottom, 16)
            
            ForEach(Array(steps.enumerated()), id: \.offset) { index, status in
                HStack(alignment: .top, spacing: 16) {
                    // Timeline indicator
                    VStack(spacing: 0) {
                        // Circle
                        ZStack {
                            Circle()
                                .fill(stepColor(for: status))
                                .frame(width: 32, height: 32)
                            
                            if isStepCompleted(status) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            } else if isCurrentStep(status) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 12, height: 12)
                            }
                        }
                        
                        // Line (except for last item)
                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(isStepCompleted(status) ? Color.green : Color.gray.opacity(0.3))
                                .frame(width: 3, height: 40)
                        }
                    }
                    
                    // Step info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(status.rawValue)
                            .font(.system(size: 15, weight: isCurrentStep(status) ? .semibold : .regular))
                            .foregroundColor(isStepCompleted(status) || isCurrentStep(status) ? .black : .gray)
                        
                        if isCurrentStep(status) {
                            Text(status.description)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 4)
                    
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
    }
    
    func isStepCompleted(_ status: PharmacyOrderStatus) -> Bool {
        let steps = order.orderType == .overTheCounter ?
            PharmacyOrderStatus.otcTrackingSteps :
            PharmacyOrderStatus.trackingSteps
        
        guard let currentIndex = steps.firstIndex(of: order.status),
              let statusIndex = steps.firstIndex(of: status) else {
            return false
        }
        
        return statusIndex < currentIndex
    }
    
    func isCurrentStep(_ status: PharmacyOrderStatus) -> Bool {
        return order.status == status
    }
    
    func stepColor(for status: PharmacyOrderStatus) -> Color {
        if isStepCompleted(status) {
            return .green
        } else if isCurrentStep(status) {
            return Color(red: 0.15, green: 0.35, blue: 0.75)
        } else {
            return Color.gray.opacity(0.3)
        }
    }
}


//  Order Details Section

extension PharmacyOrderTrackingView {
    
    var orderDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Details")
                .font(.system(size: 16, weight: .semibold))
            
            ForEach(order.medicines) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.medicine.name)
                            .font(.system(size: 15, weight: .medium))
                        
                        Text("Qty: \(item.quantity)")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("LKR \(String(format: "%.2f", item.subtotal))")
                        .font(.system(size: 15))
                }
                
                if item.id != order.medicines.last?.id {
                    Divider()
                }
            }
            
            Divider()
            
            HStack {
                Text("Total")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text("LKR \(String(format: "%.2f", order.totalAmount))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
    }
}


//  Payment Section

extension PharmacyOrderTrackingView {
    
    var paymentSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.orange)
                Text("Payment Required")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
            }
            
            Text("Complete your payment online or pay at the counter when you pick up your order.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Button(action: { showPaymentOptions = true }) {
                Text("Pay Now")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(red: 0.15, green: 0.35, blue: 0.75))
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(16)
    }
}


//  Action Buttons Section

extension PharmacyOrderTrackingView {
    
    var actionButtonsSection: some View {
        VStack(spacing: 12) {
            if order.status == .readyForPickup {
                // Prominent pickup reminder
                HStack(spacing: 12) {
                    Image(systemName: "bag.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ready for Pickup!")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.green)
                        Text("Visit the pharmacy counter with your order number or QR code")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Cancel button (only if not ready for pickup or completed)
            if order.status != .readyForPickup && order.status != .completed && order.status != .cancelled {
                Button(action: {
                    viewModel.cancelOrder(order)
                    isPresented = false
                }) {
                    Text("Cancel Order")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
    }
}


//  Pharmacy Order Payment Sheet (for paying from order tracking)

struct PharmacyOrderPaymentSheet: View {
    @ObservedObject var pharmacyViewModel: PharmacyViewModel
    let order: PharmacyOrder
    @Binding var isPresented: Bool
    
    @StateObject private var paymentVM: PaymentViewModel
    
    init(pharmacyViewModel: PharmacyViewModel, order: PharmacyOrder, isPresented: Binding<Bool>) {
        self.pharmacyViewModel = pharmacyViewModel
        self.order = order
        self._isPresented = isPresented
        self._paymentVM = StateObject(wrappedValue: PaymentViewModel(totalPrice: order.totalAmount))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if paymentVM.paymentSuccess {
                    orderPaymentSuccessView
                } else {
                    VStack(spacing: 0) {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                // Amount
                                VStack(spacing: 8) {
                                    Text("Total Amount")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                    Text("LKR \(String(format: "%.2f", order.totalAmount))")
                                        .font(.system(size: 32, weight: .bold))
                                }
                                .padding(.top, 20)
                                
                                // Payment Methods
                                paymentMethodsSection
                            }
                            .padding(.bottom, 100)
                        }
                        
                        payNowButton
                    }
                }
            }
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !paymentVM.paymentSuccess {
                        Button("Cancel") {
                            isPresented = false
                        }
                    }
                }
            }
            .sheet(isPresented: $paymentVM.showAddCardSheet) {
                AddCardSheet(
                    isPresented: $paymentVM.showAddCardSheet,
                    onCardAdded: { card, save in
                        paymentVM.addCard(card, saveForFuture: save)
                    }
                )
                .presentationDetents([.large])
            }
            .alert("Apple Pay", isPresented: $paymentVM.showApplePayPrompt) {
                Button("Cancel", role: .cancel) { }
                Button("Simulate Payment") {
                    pharmacyViewModel.completePayment(for: order, method: .applePay)
                    paymentVM.processPayment()
                }
            } message: {
                Text("Double-click the side button and authenticate with Face ID to pay with Apple Pay.\n\n(Simulated for demo)")
            }
        }
    }
    
    // Payment Methods Section
    
    var paymentMethodsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Apple Pay Option
            Button(action: { paymentVM.selectedPaymentMethod = .applePay }) {
                HStack(spacing: 12) {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(width: 40)
                    
                    Text("Pay")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    radioButton(isSelected: paymentVM.selectedPaymentMethod == .applePay)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            
            Divider()
                .padding(.leading, 68)
            
            // Credit/Debit Card Option
            Button(action: { paymentVM.selectedPaymentMethod = .card }) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 40, height: 28)
                        
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Credit/Debit Card")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text("Visa, Mastercard, Amex")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    radioButton(isSelected: paymentVM.selectedPaymentMethod == .card)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            
            // Show saved cards or add card option when card is selected
            if paymentVM.selectedPaymentMethod == .card {
                if paymentVM.savedCards.isEmpty {
                    Button(action: { paymentVM.showAddCardSheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Add a new card")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        .padding(.leading, 68)
                        .padding(.vertical, 8)
                    }
                } else {
                    ForEach(paymentVM.savedCards) { card in
                        Button(action: { paymentVM.selectedCard = card }) {
                            HStack(spacing: 12) {
                                Image(systemName: "creditcard")
                                    .foregroundColor(.gray)
                                    .frame(width: 40)
                                
                                Text("•••• \(card.lastFourDigits)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                                
                                Text(card.cardType)
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                if paymentVM.selectedCard?.id == card.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.leading, 68)
                            .padding(.trailing, 16)
                            .padding(.vertical, 8)
                        }
                    }
                    
                    Button(action: { paymentVM.showAddCardSheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Add a new card")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        .padding(.leading, 68)
                        .padding(.vertical, 8)
                    }
                }
            }
            
            Divider()
                .padding(.leading, 68)
            
            // Pay at Counter Option
            Button(action: { paymentVM.selectedPaymentMethod = .counter }) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 40, height: 28)
                        
                        Image(systemName: "banknote")
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pay at Counter")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text("Cash or Card on pickup")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    radioButton(isSelected: paymentVM.selectedPaymentMethod == .counter)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    // Radio Button
    
    func radioButton(isSelected: Bool) -> some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.4), lineWidth: 2)
                .frame(width: 22, height: 22)
            
            if isSelected {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
            }
        }
    }
    
    // Pay Now Button
    
    var payNowButton: some View {
        VStack {
            Button(action: {
                handlePayment()
            }) {
                HStack {
                    if paymentVM.isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 8)
                    }
                    Text(paymentVM.isProcessing ? "Processing..." : "Pay Now")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(paymentVM.canProceed ? Color.blue : Color.gray)
                .cornerRadius(30)
            }
            .disabled(!paymentVM.canProceed || paymentVM.isProcessing)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
    }
    
    // Payment Success View
    
    var orderPaymentSuccessView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                
                // Success Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                }
                
                Text("Payment Successful!")
                    .font(.system(size: 24, weight: .bold))
                
                Text("Your payment has been completed.\nYour order is being prepared.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Payment Details Card
                VStack(spacing: 16) {
                    VStack(spacing: 10) {
                        HStack {
                            Text("Amount Paid")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("LKR \(String(format: "%.2f", order.totalAmount))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.green)
                        }
                        
                        HStack {
                            Text("Payment Method")
                                .foregroundColor(.gray)
                            Spacer()
                            HStack(spacing: 6) {
                                Image(systemName: paymentVM.selectedPaymentMethod == .applePay ? "apple.logo" : "creditcard.fill")
                                    .foregroundColor(.blue)
                                Text(paymentVM.selectedPaymentMethod.rawValue)
                                    .font(.system(size: 15, weight: .medium))
                            }
                        }
                        
                        HStack {
                            Text("Status")
                                .foregroundColor(.gray)
                            Spacer()
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 12))
                                Text("Paid")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)
                
                // Done Button
                Button("Done") {
                    isPresented = false
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
    }
    
    // Handle Payment
    
    private func handlePayment() {
        switch paymentVM.selectedPaymentMethod {
        case .applePay:
            paymentVM.showApplePayPrompt = true
        case .card, .counter:
            let method: PharmacyPaymentMethod = paymentVM.selectedPaymentMethod == .counter ? .counter : .online
            pharmacyViewModel.completePayment(for: order, method: method)
            paymentVM.processPayment()
        }
    }
}
