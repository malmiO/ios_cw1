//
//  NewCustomerHomeView.swift
//

import SwiftUI

struct NewCustomerHomeView: View {
    
    @State private var selectedTab: Int = 0
    @State private var animatePulse: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            //  Background
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
                    NewRoundedCorner(
                        radius: 40,
                        corners: [.topLeft, .topRight]
                    )
                )
            }
            .ignoresSafeArea()
            
            
            // Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Spacer()
                        .frame(height: 30)
                    
                    quickServicesSection
                    bookAppointmentCard
                    topDoctorsSection
                    
                    Spacer(minLength: 160)
                }
                .padding(.horizontal, 20)
            }
            
            
            // Sticky Header
            headerSection
                .padding(.horizontal, 20)
                .padding(.bottom, 4)
                .background(Color.white)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                directionsBar
                    .padding(.horizontal, 16)
                floatingNavBar
            }
        }
        .onAppear { animatePulse = true }
    }
}

//  Header
extension NewCustomerHomeView {
    
    var headerSection: some View {
        HStack(spacing: 12) {
            
            Image(systemName: "person.circle")
                .font(.system(size: 26))
                .foregroundColor(.black.opacity(0.6))
            
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
            .background(Color(.systemGray6))
            .cornerRadius(20)
            
            Image(systemName: "bell")
                .font(.system(size: 20))
                .foregroundColor(.black.opacity(0.6))
        }
    }
}

// Quick Services
extension NewCustomerHomeView {
    
    var quickServicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Quick Services")
                .font(.headline)
            
            HStack(spacing: 0) {
                quickItem(icon: "stethoscope", title: "Doctor", color: .blue)
                quickItem(icon: "cross.case.fill", title: "Reports", color: .green)
                quickItem(icon: "pills.fill", title: "Pharmacy", color: .orange)
                quickItem(icon: "waveform.path.ecg", title: "Scans", color: .purple)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
    func quickItem(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(color)
                )
            
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// Book Appointment
extension NewCustomerHomeView {
    
    var bookAppointmentCard: some View {
        VStack(spacing: 12) {
            
            Button(action: {}) {
                Text("Book Appointment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
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
}

// Top Doctors
extension NewCustomerHomeView {
    
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
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.blue.opacity(0.15))
                .frame(width: 200, height: 200)
            
            Text("Dr. Emma Wilson")
                .font(.headline)
            
            Text("Neurologist")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 200)
    }
}

// Bottom Bar
extension NewCustomerHomeView {
    
    var directionsBar: some View {
        HStack {
            Image(systemName: "paperplane.fill")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.blue)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("Need directions?")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("Find your way inside clinic")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.85))
        .cornerRadius(20)
        .shadow(radius: 8)
    }
}

// Floating Glass Navbar (Same Design)
extension NewCustomerHomeView {
    
    var floatingNavBar: some View {
        let selectorSize: CGFloat = 54
        
        return ZStack {
            
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            
            HStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    navItem(icon: navIcon(for: index),
                            label: navLabel(for: index),
                            index: index)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(
                                        key: NewNavPreferenceKey.self,
                                        value: [index: geo.frame(in: .named("navBar"))]
                                    )
                            }
                        )
                }
            }
            .coordinateSpace(name: "navBar")
            .overlayPreferenceValue(NewNavPreferenceKey.self) { prefs in
                GeometryReader { geo in
                    if let frame = prefs[selectedTab] {
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.8),
                                                Color.white.opacity(0.3)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .frame(width: selectorSize, height: selectorSize)
                            .position(
                                x: frame.midX,
                                y: geo.size.height / 2
                            )
                            .animation(
                                .interactiveSpring(response: 0.4, dampingFraction: 0.7),
                                value: selectedTab
                            )
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
            withAnimation(.interactiveSpring()) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(label)
                    .font(.system(size: 9))
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

//  Custom PreferenceKey
struct NewNavPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

//  Custom Rounded Corner
struct NewRoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
#Preview {
    NewCustomerHomeView()
}
