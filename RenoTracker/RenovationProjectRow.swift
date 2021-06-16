
import SwiftUI

struct RenovationProjectRow: View {
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image("front-lobby")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading) {
                    Text("Front Lobby")
                        .font(.headline)
                    VStack(alignment: .leading) {
                        Label("Due on Aug 1, 2021", systemImage: "calendar")
                        Label("5 items", systemImage: "wrench.and.screwdriver.fill")
                        Label("60% complete", systemImage: "percent")
                        Label("On budget", systemImage: "dollarsign.circle")
                    }
                    .font(.callout)
                    .foregroundColor(.accentColor)
                }
                
                Spacer()
            }
        }.padding(.trailing)
    }
}


struct RenovationProjectRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RenovationProjectRow()
                .previewLayout(.fixed(width: 400, height: 100))
            RenovationProjectRow()
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 400, height: 100))
        }
    }
}
