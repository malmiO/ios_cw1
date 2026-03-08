//
//  Medicine.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation
import SwiftUI

//  Medicine Category

enum MedicineCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case painRelief = "Pain Relief"
    case coldAndFlu = "Cold & Flu"
    case vitamins = "Vitamins"
    case firstAid = "First Aid"
    case prescription = "Prescription"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .painRelief: return "pills.fill"
        case .coldAndFlu: return "thermometer"
        case .vitamins: return "leaf.fill"
        case .firstAid: return "cross.case.fill"
        case .prescription: return "doc.text.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .all: return Color(red: 0.15, green: 0.35, blue: 0.75)
        case .painRelief: return Color(red: 0.85, green: 0.25, blue: 0.25)
        case .coldAndFlu: return Color(red: 0.15, green: 0.35, blue: 0.75)
        case .vitamins: return Color(red: 0.20, green: 0.65, blue: 0.45)
        case .firstAid: return Color(red: 0.85, green: 0.25, blue: 0.45)
        case .prescription: return Color(red: 0.55, green: 0.35, blue: 0.75)
        }
    }
    
    var bgColor: Color {
        switch self {
        case .all: return Color(red: 0.90, green: 0.94, blue: 0.98)
        case .painRelief: return Color(red: 1.0, green: 0.91, blue: 0.91)
        case .coldAndFlu: return Color(red: 0.90, green: 0.94, blue: 0.98)
        case .vitamins: return Color(red: 0.90, green: 0.98, blue: 0.94)
        case .firstAid: return Color(red: 1.0, green: 0.91, blue: 0.94)
        case .prescription: return Color(red: 0.94, green: 0.91, blue: 0.98)
        }
    }
    
    // OTC filter categories (used in medicine list filter pills)
    static var otcFilters: [MedicineCategory] {
        [.all, .painRelief, .coldAndFlu, .vitamins, .firstAid]
    }
}


//  Medicine Model

struct Medicine: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let genericName: String
    let description: String
    let category: MedicineCategory
    let price: Double
    let dosage: String
    let packSize: String
    let requiresPrescription: Bool
    let inStock: Bool
    let imageURL: String?
    
    init(
        id: UUID = UUID(),
        name: String,
        genericName: String = "",
        description: String = "",
        category: MedicineCategory,
        price: Double,
        dosage: String = "",
        packSize: String = "",
        requiresPrescription: Bool = false,
        inStock: Bool = true,
        imageURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.genericName = genericName
        self.description = description
        self.category = category
        self.price = price
        self.dosage = dosage
        self.packSize = packSize
        self.requiresPrescription = requiresPrescription
        self.inStock = inStock
        self.imageURL = imageURL
    }
    
    static func == (lhs: Medicine, rhs: Medicine) -> Bool {
        lhs.id == rhs.id
    }
}


//  Sample Medicines Data

struct SampleMedicines {
    
    //Pain Relief
    static let painRelief: [Medicine] = [
        Medicine(
            name: "Panadol Extra",
            genericName: "Paracetamol + Caffeine",
            description: "Fast relief from headaches, migraines, and body pain",
            category: .painRelief,
            price: 350.00,
            dosage: "500mg + 65mg",
            packSize: "24 Tablets"
        ),
        Medicine(
            name: "Brufen",
            genericName: "Ibuprofen",
            description: "Anti-inflammatory pain relief for muscle and joint pain",
            category: .painRelief,
            price: 280.00,
            dosage: "400mg",
            packSize: "20 Tablets"
        ),
        Medicine(
            name: "Disprin",
            genericName: "Aspirin",
            description: "Pain relief and fever reducer",
            category: .painRelief,
            price: 150.00,
            dosage: "300mg",
            packSize: "16 Tablets"
        ),
        Medicine(
            name: "Voltaren Gel",
            genericName: "Diclofenac",
            description: "Topical gel for muscle and joint pain",
            category: .painRelief,
            price: 850.00,
            dosage: "1%",
            packSize: "50g Tube"
        ),
        Medicine(
            name: "Tiger Balm",
            genericName: "Menthol + Camphor",
            description: "Herbal ointment for pain relief",
            category: .painRelief,
            price: 450.00,
            dosage: "N/A",
            packSize: "30g Jar"
        ),
        Medicine(
            name: "Moov Cream",
            genericName: "Diclofenac + Menthol",
            description: "Fast acting pain relief cream",
            category: .painRelief,
            price: 380.00,
            dosage: "N/A",
            packSize: "50g Tube"
        ),
        Medicine(
            name: "Crocin Advance",
            genericName: "Paracetamol",
            description: "Advanced formula for quick pain relief",
            category: .painRelief,
            price: 220.00,
            dosage: "500mg",
            packSize: "15 Tablets"
        ),
        Medicine(
            name: "Saridon",
            genericName: "Paracetamol + Propyphenazone",
            description: "Triple action headache relief",
            category: .painRelief,
            price: 180.00,
            dosage: "N/A",
            packSize: "10 Tablets"
        ),
        Medicine(
            name: "Flexon",
            genericName: "Ibuprofen + Paracetamol",
            description: "Dual action pain reliever",
            category: .painRelief,
            price: 320.00,
            dosage: "400mg + 325mg",
            packSize: "15 Tablets"
        ),
        Medicine(
            name: "Combiflam",
            genericName: "Ibuprofen + Paracetamol",
            description: "For fever and pain relief",
            category: .painRelief,
            price: 290.00,
            dosage: "400mg + 325mg",
            packSize: "20 Tablets"
        )
    ]
    
    //  Cold & Flu
    static let coldAndFlu: [Medicine] = [
        Medicine(
            name: "Actifed",
            genericName: "Pseudoephedrine + Triprolidine",
            description: "Relief from cold and allergy symptoms",
            category: .coldAndFlu,
            price: 420.00,
            dosage: "60mg + 2.5mg",
            packSize: "100ml Syrup"
        ),
        Medicine(
            name: "Benadryl Cough Syrup",
            genericName: "Diphenhydramine",
            description: "Cough suppressant and antihistamine",
            category: .coldAndFlu,
            price: 380.00,
            dosage: "14mg/5ml",
            packSize: "100ml Bottle"
        ),
        Medicine(
            name: "Vicks VapoRub",
            genericName: "Menthol + Camphor + Eucalyptus",
            description: "Topical relief for cold symptoms",
            category: .coldAndFlu,
            price: 350.00,
            dosage: "N/A",
            packSize: "50g Jar"
        ),
        Medicine(
            name: "Strepsils",
            genericName: "Amylmetacresol + Dichlorobenzyl",
            description: "Sore throat lozenges",
            category: .coldAndFlu,
            price: 280.00,
            dosage: "N/A",
            packSize: "24 Lozenges"
        ),
        Medicine(
            name: "Sinarest",
            genericName: "Paracetamol + Phenylephrine",
            description: "Relief from sinus and cold",
            category: .coldAndFlu,
            price: 190.00,
            dosage: "500mg + 10mg",
            packSize: "10 Tablets"
        ),
        Medicine(
            name: "Coldarin",
            genericName: "Chlorpheniramine + Paracetamol",
            description: "Cold and flu relief tablets",
            category: .coldAndFlu,
            price: 150.00,
            dosage: "N/A",
            packSize: "10 Tablets"
        ),
        Medicine(
            name: "Otrivin Nasal Spray",
            genericName: "Xylometazoline",
            description: "Fast nasal congestion relief",
            category: .coldAndFlu,
            price: 520.00,
            dosage: "0.1%",
            packSize: "10ml Spray"
        ),
        Medicine(
            name: "Tixylix Cough Syrup",
            genericName: "Promethazine",
            description: "Children's cough medicine",
            category: .coldAndFlu,
            price: 450.00,
            dosage: "N/A",
            packSize: "100ml Bottle"
        ),
        Medicine(
            name: "Corex-D Syrup",
            genericName: "Chlorpheniramine + Dextromethorphan",
            description: "Dry cough relief",
            category: .coldAndFlu,
            price: 320.00,
            dosage: "N/A",
            packSize: "100ml Bottle"
        ),
        Medicine(
            name: "Halls Menthol",
            genericName: "Menthol",
            description: "Throat soothing lozenges",
            category: .coldAndFlu,
            price: 80.00,
            dosage: "N/A",
            packSize: "9 Lozenges"
        )
    ]
    
    //  Vitamins
    static let vitamins: [Medicine] = [
        Medicine(
            name: "Centrum Adult",
            genericName: "Multivitamin",
            description: "Complete daily multivitamin",
            category: .vitamins,
            price: 1850.00,
            dosage: "N/A",
            packSize: "60 Tablets"
        ),
        Medicine(
            name: "Vitamin C 1000mg",
            genericName: "Ascorbic Acid",
            description: "Immune system support",
            category: .vitamins,
            price: 680.00,
            dosage: "1000mg",
            packSize: "30 Tablets"
        ),
        Medicine(
            name: "Vitamin D3",
            genericName: "Cholecalciferol",
            description: "Bone health and immunity",
            category: .vitamins,
            price: 750.00,
            dosage: "1000 IU",
            packSize: "60 Capsules"
        ),
        Medicine(
            name: "Vitamin B Complex",
            genericName: "B Vitamins",
            description: "Energy and nerve support",
            category: .vitamins,
            price: 520.00,
            dosage: "N/A",
            packSize: "30 Tablets"
        ),
        Medicine(
            name: "Omega-3 Fish Oil",
            genericName: "EPA + DHA",
            description: "Heart and brain health",
            category: .vitamins,
            price: 1250.00,
            dosage: "1000mg",
            packSize: "60 Softgels"
        ),
        Medicine(
            name: "Calcium + D3",
            genericName: "Calcium Carbonate + Vitamin D3",
            description: "Strong bones and teeth",
            category: .vitamins,
            price: 680.00,
            dosage: "500mg + 400 IU",
            packSize: "60 Tablets"
        ),
        Medicine(
            name: "Iron Supplement",
            genericName: "Ferrous Sulfate",
            description: "Prevents iron deficiency",
            category: .vitamins,
            price: 380.00,
            dosage: "65mg",
            packSize: "30 Tablets"
        ),
        Medicine(
            name: "Zinc Tablets",
            genericName: "Zinc Gluconate",
            description: "Immune support and healing",
            category: .vitamins,
            price: 450.00,
            dosage: "50mg",
            packSize: "60 Tablets"
        ),
        Medicine(
            name: "Vitamin E",
            genericName: "Tocopherol",
            description: "Antioxidant for skin health",
            category: .vitamins,
            price: 620.00,
            dosage: "400 IU",
            packSize: "30 Capsules"
        ),
        Medicine(
            name: "Folic Acid",
            genericName: "Vitamin B9",
            description: "Essential for cell growth",
            category: .vitamins,
            price: 280.00,
            dosage: "5mg",
            packSize: "30 Tablets"
        )
    ]
    
    //  First Aid
    static let firstAid: [Medicine] = [
        Medicine(
            name: "Betadine Solution",
            genericName: "Povidone-Iodine",
            description: "Antiseptic wound cleanser",
            category: .firstAid,
            price: 450.00,
            dosage: "10%",
            packSize: "100ml Bottle"
        ),
        Medicine(
            name: "Dettol Antiseptic",
            genericName: "Chloroxylenol",
            description: "Multipurpose antiseptic liquid",
            category: .firstAid,
            price: 380.00,
            dosage: "4.8%",
            packSize: "250ml Bottle"
        ),
        Medicine(
            name: "Band-Aid Strips",
            genericName: "Adhesive Bandages",
            description: "Sterile wound dressing strips",
            category: .firstAid,
            price: 180.00,
            dosage: "N/A",
            packSize: "30 Strips"
        ),
        Medicine(
            name: "Cotton Bandage",
            genericName: "Gauze Bandage",
            description: "Wound dressing and support",
            category: .firstAid,
            price: 120.00,
            dosage: "N/A",
            packSize: "5m Roll"
        ),
        Medicine(
            name: "Burnol Cream",
            genericName: "Aminacrine + Cetrimide",
            description: "Burns and wound healing cream",
            category: .firstAid,
            price: 220.00,
            dosage: "N/A",
            packSize: "20g Tube"
        ),
        Medicine(
            name: "Savlon Cream",
            genericName: "Chlorhexidine + Cetrimide",
            description: "Antiseptic cream for cuts",
            category: .firstAid,
            price: 280.00,
            dosage: "N/A",
            packSize: "30g Tube"
        ),
        Medicine(
            name: "Hydrogen Peroxide",
            genericName: "H2O2",
            description: "Wound cleaning solution",
            category: .firstAid,
            price: 150.00,
            dosage: "3%",
            packSize: "100ml Bottle"
        ),
        Medicine(
            name: "Medical Tape",
            genericName: "Surgical Tape",
            description: "Secure bandage tape",
            category: .firstAid,
            price: 95.00,
            dosage: "N/A",
            packSize: "5m Roll"
        ),
        Medicine(
            name: "Sterile Gauze Pads",
            genericName: "Gauze Swabs",
            description: "Wound dressing pads",
            category: .firstAid,
            price: 180.00,
            dosage: "N/A",
            packSize: "10 Pads"
        ),
        Medicine(
            name: "Antiseptic Wipes",
            genericName: "Alcohol Wipes",
            description: "Quick wound cleaning wipes",
            category: .firstAid,
            price: 250.00,
            dosage: "70%",
            packSize: "50 Wipes"
        )
    ]
    
    // Sample Prescription Medicines
    static let prescriptionMedicines: [Medicine] = [
        Medicine(
            name: "Amoxicillin",
            genericName: "Amoxicillin",
            description: "Antibiotic for bacterial infections",
            category: .prescription,
            price: 450.00,
            dosage: "500mg",
            packSize: "21 Capsules",
            requiresPrescription: true
        ),
        Medicine(
            name: "Metformin",
            genericName: "Metformin HCl",
            description: "Diabetes management medication",
            category: .prescription,
            price: 380.00,
            dosage: "500mg",
            packSize: "60 Tablets",
            requiresPrescription: true
        ),
        Medicine(
            name: "Omeprazole",
            genericName: "Omeprazole",
            description: "Acid reflux and ulcer treatment",
            category: .prescription,
            price: 520.00,
            dosage: "20mg",
            packSize: "30 Capsules",
            requiresPrescription: true
        )
    ]
    
    // Get all OTC medicines
    static var allOTCMedicines: [Medicine] {
        painRelief + coldAndFlu + vitamins + firstAid
    }
    
    // Get medicines by category
    static func medicines(for category: MedicineCategory) -> [Medicine] {
        switch category {
        case .all: return allOTCMedicines
        case .painRelief: return painRelief
        case .coldAndFlu: return coldAndFlu
        case .vitamins: return vitamins
        case .firstAid: return firstAid
        case .prescription: return prescriptionMedicines
        }
    }
}


//  Sample Prescription Data

struct SamplePrescription {
    static let samplePrescriptionImage = "sample_prescription"
    
    static let sampleOrder = PharmacyOrder(
        orderNumber: "1234",
        orderType: .prescription,
        status: .underReview,
        prescriptionImageURL: samplePrescriptionImage,
        prescriptionNotes: "Patient: John Doe\nDoctor: Dr. Sarah Wilson\nDate: March 8, 2026\n\nRx:\n1. Amoxicillin 500mg - 1 cap TDS x 7 days\n2. Omeprazole 20mg - 1 cap BD x 14 days\n3. Paracetamol 500mg - PRN for fever",
        medicines: [
            OrderedMedicine(medicine: SampleMedicines.prescriptionMedicines[0], quantity: 3),
            OrderedMedicine(medicine: SampleMedicines.prescriptionMedicines[2], quantity: 2),
            OrderedMedicine(medicine: SampleMedicines.painRelief[0], quantity: 1)
        ],
        totalAmount: 1320.00
    )
}
