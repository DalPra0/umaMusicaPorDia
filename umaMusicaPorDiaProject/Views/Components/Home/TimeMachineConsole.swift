import SwiftUI

struct TimeMachineConsole: View {
    let viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(hex: "1E1E1E"))
                .frame(width: 341, height: 444)
                .shadow(color: .black.opacity(0.2), radius: 15, y: 10)
            
            WordSlotVisor(viewModel: viewModel)
            
            Text(viewModel.username)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .tracking(0.4)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .frame(width: 300)
                .offset(y: 110)
            
            MachineLever(pullAmount: viewModel.leverPull)
                .offset(x: 130, y: 50)
        }
    }
}
