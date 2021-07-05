
import SwiftUI

struct DetailView: View {
    @Binding var renovationProject: RenovationProject
    @State private var showEditView = false
    @State private var renovationProjectForEditing = RenovationProject()
    
    var body: some View {
        VStack(alignment: .leading) {
            Header(renovationProject: $renovationProject)
                
            WorkQuality(renovationProject: renovationProject)
            
            Divider()
            
            PunchList(renovationProject: $renovationProject)
            
            Divider()
            
            Budget(renovationProject: renovationProject)
            
            Spacer()
        }
        .padding(.all)
        .navigationTitle(renovationProject.renovationArea)
        .navigationBarItems(trailing: Button(action: {
            renovationProjectForEditing = self.renovationProject
            showEditView = true
        }, label: {
            Text("Edit")
        }))
        .sheet(isPresented: $showEditView, content: {
            NavigationView {
                EditView(renovationProject: $renovationProjectForEditing)
                    .navigationBarItems(
                        
                        leading: Button(action: {
                            showEditView = false
                        }, label: {
                            Text("Cancel")
                        }),
                        
                        trailing: Button(action: {
                            showEditView = false
                            self.renovationProject = renovationProjectForEditing
                        }, label: {
                            Text("Done")
                        }))
            }
        })
    }
}

// MARK: Header section
struct Header: View {
    @Binding var renovationProject: RenovationProject
    @State private var showProgressInfoCard = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .center) {
                ZStack(alignment: .topTrailing) {
                    Image(renovationProject.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 360)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 5)
                            )
                    
                    VStack {
                        if !showProgressInfoCard {
                            Button(action: {
                                withAnimation {
                                    showProgressInfoCard.toggle()
                                }
                            }, label: {
                                Text(Image(systemName:"info.circle"))
                                    .font(.title)
                            })
                            .padding(3)
                            .background(Color.white)
                            .foregroundColor(.accentColor)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            
                            FlagButton(isFlagged: $renovationProject.isFlagged)
                        }
                    }.padding([.top, .trailing], 20)
                }
                
                if showProgressInfoCard {
                    ProgressInfoCard(renovationProject: renovationProject, isShowing: $showProgressInfoCard.animation())
                        .transition(.asymmetric(insertion: .opacity, removal: .scale.combined(with: .opacity)))
                        .zIndex(1)
                }
            }
        }
    }
}

// MARK: Flag Button
struct FlagButton: View {
    @Binding var isFlagged: Bool
    
    var body: some View {
        ZStack {
            Button(action: {
                withAnimation {
                    isFlagged.toggle()
                }
            }, label: {
                Text(Image(systemName: "flag.circle"))
                    .font(.title)
                    .foregroundColor(isFlagged ? Color.white : Color.accentColor)
            })
            .padding(3)
            .background(isFlagged ? Color.red : Color.white)
            .clipShape(Circle())
            .shadow(radius: 5)
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: isFlagged ? 5 : 0, lineCap: .butt))
                .frame(width: 33, height: 33, alignment: .center)
                .foregroundColor(.white)
                .scaleEffect(isFlagged ? 1 : 0)
                .opacity(isFlagged ? 0.5 : 0)
                .animation(Animation.easeInOut(duration: 0.7), value: isFlagged)
            
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: isFlagged ? 0 : 10, lineCap: .butt, dash: [3, 5]))
                .frame(width: 45, height: 45, alignment: .center)
                .foregroundColor(.white)
                .scaleEffect(isFlagged ? 1.2: 0)
                .rotationEffect(.degrees(isFlagged ? 120 : 0))
                .opacity(isFlagged ? 0.8 : 0)
                .animation(Animation.easeInOut(duration: 0.7).speed(isFlagged ? 1 : 1.5), value: isFlagged)
        }
    }
}

// MARK: Progress Info Card
struct ProgressInfoCard: View {
    var renovationProject: RenovationProject
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2.0))
                    
                    Button(action: {
                        isShowing.toggle()
                    }, label: {
                        Text(Image(systemName:"x.circle"))
                            .font(.title)
                            .foregroundColor(.accentColor)
                    }).padding(5)
                }
                
                VStack {
                    HStack {
                        ProjectProgressView(value: renovationProject.percentComplete)
                    }
                    Text("Due on \(renovationProject.formattedDueDate)")
                }.padding()
            }.frame(width: 310, height: 110)
        }
    }
}

// MARK: Work Quality section
struct WorkQuality: View {
    var renovationProject: RenovationProject
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Work Quality")
                .font(.headline)
                .foregroundColor(.accentColor)
                .padding(.bottom, 2)
            
            HStack {
                workQualitySymbol
                    .foregroundColor(renovationProject.workQuality == .na ? .gray : .yellow)
                    .font(.title3)
                    .accessibility(hidden: true)
                
                Spacer()
                
                NavigationLink(
                    destination: InspectionLogView(inspectionLog: renovationProject.inspectionLog),
                    label: {
                        HStack {
                            Text("View Inspection Log")
                            Image(systemName: "arrow.right.circle")
                        }
                    })
            }
        }
    }
    
    var workQualitySymbol: some View {
        HStack {
            // First Star
            if [.poor, .fair, .good, .excellent].contains(renovationProject.workQuality) {
                Image(systemName: "star.fill")
            } else {
                Image(systemName: "star")
            }
            
            // Second Star
            if [.fair, .good, .excellent].contains(renovationProject.workQuality) {
                Image(systemName: "star.fill")
                    .transition(.opacity)
            } else {
                Image(systemName: "star")
            }
            
            // Third Star
            if [.good, .excellent].contains(renovationProject.workQuality) {
                Image(systemName: "star.fill")
                    .transition(.opacity)
            } else {
                Image(systemName: "star")
            }
            
            // Fourth Star
            if [.excellent].contains(renovationProject.workQuality) {
                Image(systemName: "star.fill")
                    .transition(.opacity)
            } else {
                Image(systemName: "star")
            }
        }
    }
}

// MARK: Punch List section
struct PunchList: View {
    @Binding var renovationProject: RenovationProject
    @State private var showPunchListItemStatusChange = false
    @State private var punchListItemToUpdate = PunchListItem()
        
    var body: some View {
        VStack(alignment: .leading) {
            Text("Punch List")
                .font(.headline)
                .foregroundColor(.accentColor)
                .padding(.bottom, 2)
            
            ForEach(renovationProject.punchList, id: \.task) { punchListItem in
                Label(
                    title: { Text(punchListItem.task) },
                    icon: { punchListItem.completionStatusSymbol })
                    .onTapGesture(count: 2, perform: {
                        punchListItemToUpdate = punchListItem
                        punchListItemToUpdate.status = .notStarted
                        
                        let itemIndex = renovationProject.punchList.firstIndex(where: {
                            $0.task == punchListItemToUpdate.task
                        })!
                        
                        renovationProject.punchList[itemIndex] = punchListItemToUpdate
                    })
                    .onTapGesture {
                        punchListItemToUpdate = punchListItem
                        punchListItemToUpdate.status = .complete
                        
                        let itemIndex = renovationProject.punchList.firstIndex(where: {
                            $0.task == punchListItemToUpdate.task
                        })!
                        
                        renovationProject.punchList[itemIndex] = punchListItemToUpdate
                    }
                    .gesture(LongPressGesture().onEnded({ _ in
                        punchListItemToUpdate = punchListItem
                        
                        showPunchListItemStatusChange = true
                    }))
            }
        }.actionSheet(isPresented: $showPunchListItemStatusChange, content: {
            ActionSheet(title: Text("Change status"), buttons: [
                ActionSheet.Button.default(Text("Not Started"), action: {
                    punchListItemToUpdate.status = .notStarted
                    
                    let itemIndex = renovationProject.punchList.firstIndex(where: { $0.task == punchListItemToUpdate.task
                    })!
                    
                    self.renovationProject.punchList[itemIndex] = punchListItemToUpdate
                }),
                
                ActionSheet.Button.default(Text("In Progress"), action: {
                    punchListItemToUpdate.status = .inProgress
                    
                    let itemIndex = renovationProject.punchList.firstIndex(where: { $0.task == punchListItemToUpdate.task
                    })!
                    
                    self.renovationProject.punchList[itemIndex] = punchListItemToUpdate
                }),
                
                ActionSheet.Button.default(Text("Complete"), action: {
                    punchListItemToUpdate.status = .complete
                    
                    let itemIndex = renovationProject.punchList.firstIndex(where: { $0.task == punchListItemToUpdate.task
                    })!
                    
                    self.renovationProject.punchList[itemIndex] = punchListItemToUpdate
                }),
                
                ActionSheet.Button.cancel()
            ])
        })
    }
}


// MARK: Budget section
struct Budget: View {
    var renovationProject: RenovationProject
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Budget")
                .font(.headline)
                .foregroundColor(.accentColor)
                .padding(.bottom, 2)
            
            Label(
                title: { Text(renovationProject.budgetStatus.rawValue) },
                icon: { renovationProject.budgetStatusSymbol
                    .foregroundColor(renovationProject.budgetStatusForegroundColor) }
            )
            
            HStack {
                Text("Amount Allocated:")
                Spacer()
                Text(renovationProject.formattedBudgetAmountAllocated)
            }
            
            HStack {
                Text("Spent to-date:")
                Spacer()
                Text(renovationProject.formattedBudgetSpentToDate)
                    .underline()
            }
            
            HStack {
                Text("Amount remaining:")
                    .bold()
                Spacer()
                Text(renovationProject.formattedBudgetAmountRemaining)
                    .bold()
            }
        }
    }
}

// MARK: Previews
struct DetailView_Previews: PreviewProvider {
    struct StatefulPreviewWrapper: View {
        @State private var testProject = RenovationProject.testData[0]
        
        var body: some View {
            DetailView(renovationProject: $testProject)
        }
    }
    
    static var previews: some View {
        Group {
            NavigationView {
                StatefulPreviewWrapper()
                
            }
            
            NavigationView {
                StatefulPreviewWrapper()                    .preferredColorScheme(.dark)
            }
        }
    }
}
