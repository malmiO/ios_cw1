//
//  PharmacyOrder.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation

//Order Status

enum PharmacyOrderStatus: String, CaseIterable, Codable {
    case prescriptionUploaded = "Prescription Uploaded"
    case underReview = "Under Review"
    case reviewCompleted = "Review Completed"
    case preparingMedicine = "Preparing Medicine"
    case readyForPayment = "Ready for Payment"
    case paymentCompleted = "Payment Completed"
    case readyForPickup = "Ready for Pickup"
    case completed = "Completed"
    case cancelled = "Cancelled"
    
    var icon: String {
        switch self {
        case .prescriptionUploaded: return "doc.text.fill"
        case .underReview: return "eye.fill"
        case .reviewCompleted: return "checkmark.seal.fill"
        case .preparingMedicine: return "pills.fill"
        case .readyForPayment: return "creditcard.fill"
        case .paymentCompleted: return "checkmark.circle.fill"
        case .readyForPickup: return "bag.fill"
        case .completed: return "hand.thumbsup.fill"
        case .cancelled: return "xmark.circle.fill"
        }
    }
    
    var description: String {
        switch self {
        case .prescriptionUploaded: return "Your prescription has been received"
        case .underReview: return "Pharmacist is reviewing your prescription"
        case .reviewCompleted: return "Prescription approved, preparing your order"
        case .preparingMedicine: return "Your medicines are being prepared"
        case .readyForPayment: return "Please complete payment to proceed"
        case .paymentCompleted: return "Payment received, finalizing your order"
        case .readyForPickup: return "Your order is ready! Visit the counter"
        case .completed: return "Order completed. Thank you!"
        case .cancelled: return "Order has been cancelled"
        }
    }
    
    // Steps for tracking UI (excluding cancelled)
    static var trackingSteps: [PharmacyOrderStatus] {
        [.prescriptionUploaded, .underReview, .preparingMedicine, .readyForPayment, .readyForPickup]
    }
    
    // For OTC orders (no prescription review)
    static var otcTrackingSteps: [PharmacyOrderStatus] {
        [.preparingMedicine, .readyForPayment, .readyForPickup]
    }
}


// Order Type

enum PharmacyOrderType: String, Codable {
    case prescription = "Prescription"
    case overTheCounter = "Over the Counter"
    case mixed = "Mixed Order"
}


// MPayment Method

enum PharmacyPaymentMethod: String, Codable {
    case online = "Online Payment"
    case counter = "Pay at Counter"
    case applePay = "Apple Pay"
}


// Pharmacy Order Model

struct PharmacyOrder: Identifiable, Codable {
    let id: UUID
    let orderNumber: String
    let orderType: PharmacyOrderType
    var status: PharmacyOrderStatus
    let createdAt: Date
    var updatedAt: Date
    
    // Prescription details (optional for OTC orders)
    var prescriptionImageURL: String?
    var prescriptionNotes: String?
    
    // Order items
    var medicines: [OrderedMedicine]
    
    // Payment
    var paymentMethod: PharmacyPaymentMethod?
    var totalAmount: Double
    var isPaid: Bool
    
    // Queue info (assigned after payment)
    var queueNumber: String?
    var counterNumber: Int?
    
    // QR Code data
    var qrCodeData: String {
        "PHARM-\(orderNumber)"
    }
    
    init(
        id: UUID = UUID(),
        orderNumber: String = PharmacyOrder.generateOrderNumber(),
        orderType: PharmacyOrderType,
        status: PharmacyOrderStatus = .prescriptionUploaded,
        createdAt: Date = Date(),
        prescriptionImageURL: String? = nil,
        prescriptionNotes: String? = nil,
        medicines: [OrderedMedicine] = [],
        paymentMethod: PharmacyPaymentMethod? = nil,
        totalAmount: Double = 0.0,
        isPaid: Bool = false,
        queueNumber: String? = nil,
        counterNumber: Int? = nil
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.orderType = orderType
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = createdAt
        self.prescriptionImageURL = prescriptionImageURL
        self.prescriptionNotes = prescriptionNotes
        self.medicines = medicines
        self.paymentMethod = paymentMethod
        self.totalAmount = totalAmount
        self.isPaid = isPaid
        self.queueNumber = queueNumber
        self.counterNumber = counterNumber
    }
    
    // Generate simple 4-digit order number
    static func generateOrderNumber() -> String {
        let number = Int.random(in: 1000...9999)
        return "\(number)"
    }
    
    // Computed property for estimated time
    var estimatedTime: String {
        switch status {
        case .prescriptionUploaded, .underReview:
            return "~15 mins"
        case .reviewCompleted, .preparingMedicine:
            return "~10 mins"
        case .readyForPayment:
            return "Waiting for payment"
        case .paymentCompleted:
            return "~5 mins"
        case .readyForPickup:
            if let queue = queueNumber {
                return "Queue \(queue)"
            }
            return "Ready now!"
        case .completed, .cancelled:
            return "-"
        }
    }
    
    // Get current step index for tracking
    var currentStepIndex: Int {
        let steps = orderType == .overTheCounter ? PharmacyOrderStatus.otcTrackingSteps : PharmacyOrderStatus.trackingSteps
        return steps.firstIndex(of: status) ?? 0
    }
}


// Ordered Medicine

struct OrderedMedicine: Identifiable, Codable {
    let id: UUID
    let medicine: Medicine
    var quantity: Int
    
    var subtotal: Double {
        medicine.price * Double(quantity)
    }
    
    init(id: UUID = UUID(), medicine: Medicine, quantity: Int = 1) {
        self.id = id
        self.medicine = medicine
        self.quantity = quantity
    }
}
