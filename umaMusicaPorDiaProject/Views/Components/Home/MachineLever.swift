import SwiftUI

struct MachineLever: View {
    let pullAmount: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "D9D9D9").opacity(0.3))
                .frame(width: 23, height: 96)
            
            ZStack {
                RoundedRectangle(cornerRadius: 19)
                    .fill(Color(hex: "6C6063"))
                    .frame(width: 8, height: 82)
                    .offset(y: 20)
                
                Circle()
                    .fill(Color(hex: "D9D9D9"))
                    .frame(width: 35, height: 35)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .offset(x: 5, y: -5)
            }
            .offset(y: -25 + pullAmount)
        }
    }
}
