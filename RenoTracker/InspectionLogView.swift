
import SwiftUI

import SwiftUI

struct InspectionLogView: View {
    var inspectionLog: [InspectionLogEntry]
    @State private var sortAscending = true
    
    var sortedLogEntries: [InspectionLogEntry] {
        inspectionLog.sorted(by: { sortAscending ? $0.entryDate < $1.entryDate : $0.entryDate > $1.entryDate })
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation(.linear(duration: 0.3)) {
                    self.sortAscending.toggle()
                }
            }, label: {
                HStack {
                    Text("Sort")
                    Image(systemName: "chevron.up.circle")
                        .rotationEffect(Angle(degrees: sortAscending ? 0 : 180))
                }
                .font(.title3)
            }).padding(.leading)
            
            List {
                ForEach(sortedLogEntries, id: \.details) {
                    entry in
                    VStack(alignment:.leading) {
                        Text(entry.formattedEntryDate)
                            .font(.headline)
                        Text(entry.details)
                    }
                }
            }
            .navigationTitle("Inspection Log")
        }
    }
}

struct WorkLog_Previews: PreviewProvider {
    struct StatefulPreviewWrapper: View {
        @State private var testProject = RenovationProject.testData[0]
        
        var body: some View {
            InspectionLogView(inspectionLog: testProject.inspectionLog)
        }
    }
    static var previews: some View {
        NavigationView {
            StatefulPreviewWrapper()
        }
    }
}
