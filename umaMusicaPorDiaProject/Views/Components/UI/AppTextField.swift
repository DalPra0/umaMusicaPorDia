import SwiftUI

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
