import SwiftUI

struct ContentView: View {
    @State var hoursArray: [String] = []
    @State var colors: [Color] = [.red, .green, .yellow, .blue]
    @State var selectedDate = Date()
    @State var eventData:[(date: Date, events: [String])] = []
    @State var minutesArray:[totalMinutes] = []
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var showingSheets = false
    @State private var taskName: String = ""
    @State var eventListArray:[manageEventMinutes] = []
    @State var tempArray:[Int]
    @State var manageTitle:[titleWithSpace]
    @State var showableTitle:[titleWithSpace]
    @State private var showAlert:Bool = false
    @State var event:[Event] = []
   //
    @State var manageTitleTemp:[titleWithSpace] = []
    
//
    
    var body: some View {
//        NavigationStack {
            VStack {
                
                ScrollableCalendarView(selectedDate: $selectedDate, events: $event) {
                    DispatchQueue.main.async {
                        minutesArray.removeAll()
    //                    showableTitle.removeAll()
    //                    for t in manageTitle {
    //                        if dateStringRemoveTime(from: selectedDate) == dateStringRemoveTime(from: t.date) {
    //                            showableTitle.append(titleWithSpace(date: t.date, title: t.title, space: t.space, height: t.height))
    //                        }
    //                    }
                        
                        //
                        showableTitle.removeAll()
                        manageTitleTemp.removeAll()
                        for m in manageTitle {
                            if dateStringRemoveTime(from: selectedDate) == dateStringRemoveTime(from: m.date) {
                                let data = showableTitle.contains { data in
                                    data.height == m.height && data.space == m.space
                                }
                                if data == false {
                                    showableTitle.append(m)

                                } else {
                                    manageTitleTemp.append(m)
                                }
                            }
                            
                        }
                        
                        //
                        for i in 0...1440 {
                            minutesArray.append(totalMinutes(min: i, color: .clear))
                        }
                        
                        for i in eventListArray {
                            if dateStringRemoveTime(from: selectedDate) == dateStringRemoveTime(from: i.date) {
                                for m in i.arraTotalMinutes {
                                    var index = minutesArray.firstIndex { totalmin in
                                        totalmin.min == m
                                    }
                                }
                            }
                        }
                    }
                }
//                .padding()
                .frame(height: 180)
                .background(.gray.opacity(0.2))
                   
                ScrollView(showsIndicators: false) {
                    HStack(alignment:.top) {
                        VStack (alignment:.leading,spacing: 0) {
                            ForEach(hoursArray,id: \.self) { str in
                                VStack(alignment:.leading) {
                                    Text("\(str)")
                                        .lineLimit(0)
                                    Spacer()
                                }   .frame(height: 60.0)
                            }
                        }.background(.clear)
                            .padding(.horizontal)
                        ZStack(alignment:.top) {
    //                        VStack(alignment:.leading,spacing: 0) {
    //                            ForEach(minutesArray,id:\.id) { min in
    //                                HStack {
    //                                    Spacer()
    //                                    Text("").frame(height: 1)
    //                                    Spacer()
    //                                }
    //                                .background(.clear)
    //                            }
    //                        }.background(.white)
                            
                            VStack {
                                ForEach(hoursArray,id: \.self) { str in
                                    Divider().background(.red)
                                    Spacer()
                                }
                            }
                            
                            ForEach(showableTitle, id:\.id) { title in
                                GeometryReader(content: { geometry in
                                    ZStack(alignment:.top) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(colors.randomElement()!)
                                        HStack {
                                            Text(title.title)
                                                .font(.system(size: 16))
                                                .padding(.leading,8)
                                            
                                            
    //                                            .padding(.horizontal,8)
                                                .padding(.top,8)
                                            Spacer()
                                        }
                                        
                                    }.frame(width:(geometry.size.width / 2 - 20),height: CGFloat(title.height))
                                        .padding(.top,CGFloat(title.space))
                                })
                            }
                            
                            //
                            ForEach(manageTitleTemp, id:\.id) { title in
                                GeometryReader(content: { geometry in
                                    ZStack(alignment:.top) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(colors.randomElement()!)
                                        HStack {
                                            Text(title.title)
    //                                            .padding(.horizontal,8)
                                                .padding(.top,8)
                                            Spacer()
                                        }
                                        
                                    }.frame(width:(geometry.size.width / 2 - 20),height: CGFloat(title.height))
                                        .padding(.top,CGFloat(title.space))
                                        .padding(.leading,150)
                                })
                            }
                            
                            //
                            
                        }
                    }
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(taskName.count > 0 ? "Please Enter Valid Date and Time" : "Enter valid event name"), dismissButton: .default(Text("OK")))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSheets.toggle()
                    }) {
                        Image(.event).resizable().frame(width: 35, height: 35)
                    }
                }
            }
            .sheet(isPresented: $showingSheets, content: {
                VStack {
                    Text("Select Dates and Task Details")
                        .font(.headline)
                        .padding()
                    
                    DatePicker("Start Time", selection: $startDate, in: selectedDate..., displayedComponents: [.date,.hourAndMinute])
                        .padding()
                    
                    DatePicker("End Time", selection: $endDate, in: selectedDate..., displayedComponents: [.date,.hourAndMinute])
                        .padding()
                    
                    TextField("Task Name", text: $taskName,axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Button("Confirm") {
                            if startDate > Date() && dateStringRemoveTime(from: startDate) == dateStringRemoveTime(from: endDate ) && taskName.count > 0 {
                                DispatchQueue.main.async {
                                    tempArray = minuteBlockRange(forStartTime: startDate, endTime: endDate)
                                    print(startDate)
                                    print(endDate)
                                    eventListArray.append(manageEventMinutes(date: startDate, arraTotalMinutes: tempArray))
                                    manageTitle.append(titleWithSpace(date: startDate, title: taskName, space: tempArray[0], height: tempArray.count))
                                    tempArray.removeAll()
                                    addEvent(date: startDate)
                                    for t in manageTitle {
                                        if dateStringRemoveTime(from: selectedDate) == dateStringRemoveTime(from: t.date){
                                            showableTitle.append(titleWithSpace(date: t.date, title: t.title, space: t.space, height: t.height))
                                        }
                                    }
                                    //
                                    showableTitle.removeAll()
                                    manageTitleTemp.removeAll()
                                    for m in manageTitle {
                                        if dateStringRemoveTime(from: selectedDate) == dateStringRemoveTime(from: m.date) {
                                            let data = showableTitle.contains { data in
                                                data.height == m.height && data.space == m.space
                                            }
                                            if data == false {
                                                showableTitle.append(m)
                                            } else {
                                                manageTitleTemp.append(m)
                                            }
                                        }
                                    }
                                    
                                    //
                                    for i in eventListArray {
                                        if dateStringRemoveTime(from: selectedDate) == dateStringRemoveTime(from: i.date) {
                                            for m in i.arraTotalMinutes {
                                                let index = minutesArray.firstIndex { totalmin in
                                                    totalmin.min == m
                                                }
                                                minutesArray[index!].color = .green
                                            }
                                        }
                                    }
                                }
                                showingSheets.toggle()
                            }
                            
                            else {
                                showingSheets.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    showAlert.toggle()
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .padding()

                        .background(Color.blue) // Background color of the button
                        .cornerRadius(10)
                        
                        Button("Cancel") {
                            showingSheets.toggle()
                        }
                        .foregroundColor(.white)

                        .padding()

                        .background(Color.blue) // Background color of the button
                                       
                        .cornerRadius(10)
                    }
                }
                .padding()
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
                
            })

            .onAppear {
                
                DispatchQueue.main.async {
                    hoursArray = ["12 AM","1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM","7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM","1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM","7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
                    
                    minutesArray.removeAll()
                    for i in 0...1441 {
                        minutesArray.append(totalMinutes(min: i, color: .clear))
                    }
                    for i in eventListArray {
                        if dateStringRemoveTime(from: selectedDate) == dateStringRemoveTime(from: i.date) {
                            for m in i.arraTotalMinutes {
                                var index = minutesArray.firstIndex { totalmin in
                                    totalmin.min == m
                                }
                                minutesArray[index!].color = .red
                            }
                        }
                    }
                }
            }
        }
//    
//    }
    
    func minuteBlockRange(forStartTime startTime: Date, endTime: Date) -> [Int] {
        let calendar = Calendar.current
        let startMinute = calendar.component(.minute, from: startTime) + calendar.component(.hour, from: startTime) * 60
        let endMinute = calendar.component(.minute, from: endTime) + calendar.component(.hour, from: endTime) * 60
        
        let range = Array(startMinute...endMinute)
        return range
    }
    
    private func dateStringRemoveTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    func addEvent(date:Date) {
        guard !taskName.isEmpty else { return }
        DispatchQueue.main.async {
            event.append(Event(date: date, eventName: taskName))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tempArray: [],manageTitle: [], showableTitle: [])
    }
}


