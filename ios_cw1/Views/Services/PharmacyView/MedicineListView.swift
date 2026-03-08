//
//  MedicineListView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import SwiftUI

struct MedicineListView: View {
    
    @ObservedObject var viewModel: PharmacyViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedCategory: MedicineCategory
    @State private var searchText = ""
    
    init(viewModel: PharmacyViewModel, initialCategory: MedicineCategory = .all) {
        self.viewModel = viewModel
        self._selectedCategory = State(initialValue: initialCategory)
    }
    
    var filteredMedicines: [Medicine] {
        let medicines = SampleMedicines.medicines(for: selectedCategory)
        if searchText.isEmpty {
            return medicines
        }
        return medicines.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.genericName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Search Bar
                searchBarSection
                
                // Category Filter Pills
                categoryFilterSection
                
                // Medicine List
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredMedicines) { medicine in
                            MedicineCard(
                                medicine: medicine,
                                quantity: viewModel.getQuantityInCart(for: medicine),
                                onAdd: { viewModel.addToCart(medicine) },
                                onRemove: { viewModel.removeFromCart(medicine) },
                                onUpdateQuantity: { qty in viewModel.updateQuantity(for: medicine, quantity: qty) }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 100)
                }
            }
            .background(Color(.systemGroupedBackground))
            
            // Cart Button (if items in cart)
            if viewModel.cartItemCount > 0 {
                cartButton
            }
        }
        .navigationBarHidden(true)
    }
}


// Header Section

extension MedicineListView {
    
    var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Medicines")
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
            
            // Cart indicator
            NavigationLink(destination: PharmacyCartView(viewModel: viewModel)) {
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
        .background(Color.white)
    }
    
    var searchBarSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search medicines...", text: $searchText)
                .font(.system(size: 16))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}


// Category Filter Pills

extension MedicineListView {
    
    var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(MedicineCategory.otcFilters) { category in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    } label: {
                        Text(category.rawValue)
                            .font(.system(size: 14))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedCategory == category ?
                                Color(red: 0.15, green: 0.35, blue: 0.75) :
                                Color(.systemGray5)
                            )
                            .foregroundColor(
                                selectedCategory == category ?
                                .white : .black
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .background(Color.white)
    }
}


// Cart Button

extension MedicineListView {
    
    var cartButton: some View {
        NavigationLink(destination: PharmacyCartView(viewModel: viewModel)) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 18))
                    
                    Text("\(viewModel.cartItemCount) items")
                        .font(.system(size: 15, weight: .medium))
                }
                
                Spacer()
                
                Text("LKR \(String(format: "%.2f", viewModel.cartTotal))")
                    .font(.system(size: 16, weight: .bold))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(red: 0.15, green: 0.35, blue: 0.75))
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
    }
}


// Medicine Card

struct MedicineCard: View {
    let medicine: Medicine
    let quantity: Int
    let onAdd: () -> Void
    let onRemove: () -> Void
    let onUpdateQuantity: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                // Medicine Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(medicine.category.bgColor)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: medicine.category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(medicine.category.iconColor)
                }
                
                // Medicine Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(medicine.name)
                        .font(.system(size: 16, weight: .semibold))
                    
                    if !medicine.genericName.isEmpty {
                        Text(medicine.genericName)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 8) {
                        if !medicine.dosage.isEmpty && medicine.dosage != "N/A" {
                            Text(medicine.dosage)
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                        }
                        
                        Text(medicine.packSize)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            
            // Description
            Text(medicine.description)
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .lineLimit(2)
            
            // Price and Add Button
            HStack {
                Text("LKR \(String(format: "%.2f", medicine.price))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                
                Spacer()
                
                if quantity > 0 {
                    // Quantity Stepper
                    HStack(spacing: 0) {
                        Button(action: { onUpdateQuantity(quantity - 1) }) {
                            Image(systemName: "minus")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 36, height: 36)
                                .background(Color(red: 0.15, green: 0.35, blue: 0.75))
                        }
                        
                        Text("\(quantity)")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 44)
                        
                        Button(action: { onUpdateQuantity(quantity + 1) }) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 36, height: 36)
                                .background(Color(red: 0.15, green: 0.35, blue: 0.75))
                        }
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                } else {
                    // Add Button
                    Button(action: onAdd) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Add")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .cornerRadius(10)
                    }
                }
            }
            
            // Stock Status
            if !medicine.inStock {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                    Text("Out of Stock")
                        .font(.system(size: 12))
                }
                .foregroundColor(.red)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
