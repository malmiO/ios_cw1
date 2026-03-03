//
//  HomeView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI

struct HomeView: View {
    
    @State private var selectedTab: Int = 0
    @State private var animatePulse: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Background (unchanged)
            VStack(spacing: 0) {
                Color(.systemGroupedBackground)
                
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.35),
                        Color.blue.opacity(0.20)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 420)
                .clipShape(
                    RoundedCorner(radius: 40,
                                  corners: [.topLeft, .topRight])
                )
            }
            .ignoresSafeArea()
            
            
            // SCROLLABLE CONTENT (WITHOUT HEADER)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Spacer()
                        .frame(height: 30) // content below header
                    
                    activeQueueCard
                    quickServicesSection
                    bookAppointmentCard
                    topDoctorsSection
                    
                    Spacer(minLength: 160)
                }
                .padding(.horizontal, 20)
            }
            
            
            // header - sticky
            headerSection
                .padding(.top,0)
                .padding(.horizontal, 20)
                .padding(.bottom,0.5)
                .background(Color.white)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                directionsBar
                    .padding(.horizontal, 16)
                floatingNavBar
            }
        }
    }
}


extension HomeView {
    
    var headerSection: some View {
        HStack(spacing: 12) {
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 44, height: 44)
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
                    .foregroundColor(.black.opacity(0.6))
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                Text("Search")
                    .foregroundColor(.black.opacity(0.6))
                Spacer()
                Image(systemName: "mic.fill")
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding(10)
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 36, height: 36)
                Image(systemName: "bell")
                    .font(.system(size: 18))
                    .foregroundColor(.black.opacity(0.6))
            }
        }
        .foregroundColor(.black)
    }
    
    var activeQueueCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Turn in 10 minutes")
                        .font(.headline)
                    
                    Text("OPD Room 2\nCurrent Queue 3 of 17")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack {
                    Text("Queue no.")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    Text("#6")
                        .font(.title)
                        .bold()
                        .foregroundColor(.blue)
                }
            }
            
            HStack {
                Button("Leave Queue") {}
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray5))
                    .cornerRadius(20)
                
                Spacer()
                
                Button("Reschedule") {}
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(radius: 4)
        .offset(y: 6)
    }
    
    var bookAppointmentCard: some View {
        VStack(spacing: 12) {
            
            Button(action: {}) {
                Text("Book Appointment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [Color(#colorLiteral(red: 0.0, green: 0.48, blue: 0.78, alpha: 1)), Color(#colorLiteral(red: 0.09, green: 0.59, blue: 0.83, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
            }
            .scaleEffect(animatePulse ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animatePulse)
            
            Text("Find a doctor and schedule your visit instantly")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(radius: 4)
    }
    
    var quickServicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Quick Services")
                .font(.headline)
            
            HStack(spacing: 0) {
                quickServiceItem(icon: "stethoscope", title: "Find\nDoctor", color: .blue)
                quickServiceItem(icon: "cross.case.fill", title: "Lab\nReports", color: .green)
                quickServiceItem(icon: "pills.fill", title: "Pharmacy", color: .orange)
                quickServiceItem(icon: "waveform.path.ecg", title: "Scans", color: .purple)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    
    }
    
    func quickServiceItem(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
    
    var topDoctorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Top Doctors")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    doctorCard
                    doctorCard
                }
            }
        }
    }
    
    var doctorCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .topLeading) {
                //  image doctor
                if UIImage(named: "doctor_placeholder") != nil {
                    Image("doctor_placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 220)
                        .clipped()
                        .cornerRadius(24)
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(#colorLiteral(red: 0.88, green: 0.94, blue: 0.98, alpha: 1)))
                        .frame(width: 220, height: 220)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color(#colorLiteral(red: 0.36, green: 0.62, blue: 0.86, alpha: 1)))
                        )
                }
                
                Text("⭐ 5.0")
                    .font(.caption)
                    .padding(6)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(8)
            }
            
            Text("Dr. Emma Wilson")
                .font(.headline)
            
            Text("Neurologist")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 220)
    }
}

// MARK: - Fixed Bottom Overlays
extension HomeView {

    // Dark "Need directions?" bar — fixed, not scrolling
    var directionsBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "paperplane.fill")
                .font(.system(size: 18))
                .foregroundColor(.white)
                .padding(10)
                .background(Color(#colorLiteral(red: 0.07, green: 0.39, blue: 0.64, alpha: 1)))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 1) {
                Text("Need directions?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Text("Find your way inside the clinic")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            Image(systemName: "arrow.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.82))
        .cornerRadius(20)
        .shadow(radius: 8)
    }

    // Floating glass nav bar — pinned to bottom
    var floatingNavBar: some View {
        let selectorSize: CGFloat = 54
        
        return ZStack {
            // Background capsule (glass)
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            
            // HStack for nav items
            HStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    navItem(icon: navIcon(for: index), label: navLabel(for: index), index: index)
                        .background(
                            GeometryReader { itemGeo in
                                Color.clear
                                    .preference(key: NavItemPreferenceKey.self,
                                                value: [index: itemGeo.frame(in: .named("navBar"))])
                            }
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .coordinateSpace(name: "navBar")
            .overlayPreferenceValue(NavItemPreferenceKey.self) { prefs in
                GeometryReader { geo in
                    if let frame = prefs[selectedTab] {
                        // Glass circular selector - very transparent so icon shows through clearly
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.8), Color.white.opacity(0.3)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: Color.white.opacity(0.4), radius: 6, x: 0, y: 0)
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                            .frame(width: selectorSize, height: selectorSize)
                            .position(x: frame.midX, y: geo.size.height / 2)
                            .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.2), value: selectedTab)
                            .allowsHitTesting(false)
                    }
                }
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    func navIcon(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "square.grid.2x2.fill"
        case 2: return "calendar"
        case 3: return "location.fill"
        default: return "circle"
        }
    }
    
    func navLabel(for index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Services"
        case 2: return "Appointments"
        case 3: return "Navigation"
        default: return ""
        }
    }

    func navItem(icon: String, label: String, index: Int) -> some View {
        let isSelected = selectedTab == index
        return Button {
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? Color(#colorLiteral(red: 0.0, green: 0.48, blue: 0.78, alpha: 1)) : .gray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                Text(label)
                    .font(.system(size: 9, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color(#colorLiteral(red: 0.0, green: 0.48, blue: 0.78, alpha: 1)) : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

// Preference key to track nav item frames
struct NavItemPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// RoundedCorner helper
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    HomeView()
}
