import SwiftUI

struct AppButton: View {
    let title: String
    var isLoading: Bool = false
    var style: AppButtonStyle = .primary
    let action: () -> Void
    
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

struct AppTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 17))
                .foregroundColor(.black)
                .frame(width: 80, alignment: .leading)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .autocapitalization(.none)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(Color.white)
        .cornerRadius(12)
    }
}
