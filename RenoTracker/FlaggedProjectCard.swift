
import SwiftUI

struct FlaggedProjectCard: View {
    let renovationProject: RenovationProject
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(renovationProject.imageName)
                .resizable()
                .aspectRatio(3/2, contentMode: .fit)
                .overlay(TextOverlay(renovationProject: self.renovationProject))
            
            ZStack {
                Text(Image(systemName: "flag.circle"))
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(3)
                    .background(Color.red)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .butt))
                    .frame(width: 33, height: 33, alignment: .center)
                    .foregroundColor(.white)
                    .scaleEffect(1)
                    .opacity(0.5)
            }.padding()
        }
    }
}

struct TextOverlay: View {
    let renovationProject: RenovationProject
    
    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.black.opacity(0.6), Color.black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle().fill(gradient)
            VStack(alignment: .leading) {
                Text(renovationProject.renovationArea)
                    .font(.title)
                    .bold()
                Text("Due on \(renovationProject.formattedDueDate)")
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}


struct FlaggedProjectCard_Previews: PreviewProvider {
    static var previews: some View {
        FlaggedProjectCard(renovationProject: RenovationProject.testData[1])
    }
}
