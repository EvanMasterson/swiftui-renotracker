
import SwiftUI

struct ProjectProgressView: View {
    var value: Double = 0.75
    
    var formattedProgressValue: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        
        return numberFormatter.string(from: NSNumber(value: value)) ?? "0%"
    }
    
    var body: some View {
        HStack {
            GeometryReader { geometryProxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .opacity(0.3)
                        .foregroundColor(.accentColor)
                    
                    Capsule()
                        .opacity(1.0)
                        .foregroundColor(.accentColor)
                        // Want this to be a percentage of the width, but to do that, you need to know how wide the parent view where it's used has offered.  That's where GeometryReader comes in -- it allows this View to know how much space, in terms of width and height, that the parent has offered a child. With this information, the child can use it to choose its size __based on__ that available space rather than just following the default SwiftUI rules.
                        .frame(width: geometryProxy.size.width * CGFloat(value), height: geometryProxy.size.height)
                    
                    if value > 0.0 {
                        Snowflake()
                            .stroke(Color.white)
                            .frame(width: geometryProxy.size.height - 2 , height: geometryProxy.size.height - 2)
                            .offset(x: (geometryProxy.size.width * CGFloat(value)) - geometryProxy.size.height)
                            
                    }
                }.animation(.spring(response: 1, dampingFraction: 0.75), value: self.value)
            }
            .frame(maxHeight: 20)
            Spacer()
            Text("\(formattedProgressValue) complete")
        }
    }
}

struct ProjectProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectProgressView(value: 0.8)
    }
}
