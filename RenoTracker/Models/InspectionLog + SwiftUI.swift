
import Foundation

extension InspectionLogEntry {
    var formattedEntryDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: entryDate)
    }
}
