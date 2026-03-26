import SwiftUI

struct AppButton: View {
    let title: String
    var isLoading: Bool = false
    var style: AppButtonStyle = .primary
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                } else {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(style.foregroundColor)
                        .tracking(-0.23)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 43)
            .background(style.backgroundColor)
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
}

enum AppButtonStyle {
    case primary, secondary
    
    var backgroundColor: Color {
        switch self {
        case .primary: return Color(hex: "3B3939")
        case .secondary: return .white
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary: return .white
        case .secondary: return Color(hex: "090909")
        }
    }
}
