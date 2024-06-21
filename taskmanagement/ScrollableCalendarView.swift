//
//  ScrollableCalendarView.swift
//  taskmanagement
//
//  Created by mind on 22/03/24.
//

import SwiftUI

struct Event {
    let date: Date
    let eventName: String
}

struct ScrollableCalendarView: View {
    @Binding var selectedDate: Date
    @Binding var events: [Event]
    @State var visibleIndex: [Date] = [Date(),Date(),Date(),Date(),Date()]
    @State var dateName:[String] = []
    @State var dragDateWeek:[[Date]] = [[Date]]()
    @State private var selectedIndex: [Date]?
    @State var count = -1
    @State var selectedDateMonthChang:Date?
    
    var loadData:(() -> Void)?
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"
        return formatter
    }()
    
    private func dateStringRemoveTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    private func isInView(innerRect:CGRect, isIn outerProxy:GeometryProxy) -> Bool {
        let innerOrigin = innerRect.origin.x
        let imageWidth = innerRect.width
        let scrollOrigin = outerProxy.frame(in: .global).origin.x
        let scrollWidth = outerProxy.size.width
        if innerOrigin + imageWidth < scrollOrigin + scrollWidth && innerOrigin + imageWidth > scrollOrigin ||
            innerOrigin + imageWidth > scrollOrigin && innerOrigin < scrollOrigin + scrollWidth {
            return true
        }
        return false
    }
    
    var body: some View {
        GeometryReader { outerProxy in
            VStack(spacing:0) {
                
                
                //                Text("\(selectedIndex?[0] ?? Date(), formatter: dateFormatter)")
                ScrollViewReader { scrollview in
                    VStack(spacing:0) {
                        HStack(spacing:0) {
                            Button {
                                selectedDateMonthChang = nil
                                count = count - 1
                                scrollview.scrollTo(dragDateWeek[count])
                            }label: {
                                HStack {
                                    Text("Previous")
                                        .foregroundStyle(.red)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                }.frame(width: 100)

                                

                            }
                            Spacer()
                            
                            
                            Text("\((selectedDateMonthChang == nil ? count == -1 ?  Date() : dragDateWeek[count][0] : selectedDateMonthChang) ?? Date(),formatter: dateFormatter)")

                            Spacer()
                            
                            Button {
                                selectedDateMonthChang = nil
                                count = count + 1
                                scrollview.scrollTo(dragDateWeek[count])
                            }label: {
                                HStack{
                                    
                                    Spacer()
                                    Text("Next")
                                        .foregroundStyle(.red)
                                        
                                    

                                }.frame(width: 100)
                                
                            }
                        }
                        .padding()
                        
                        HStack(alignment:.center,spacing:0){
                            ForEach(dateName,id: \.self) { str in
                                Text(str)
                                    .foregroundStyle(str == "Sun" ? .red : str == "Sat" ? .red : .black)
                                    .frame(width:outerProxy.size.width
                                           / 7)
                            }
                        }

                    }
                    GeometryReader { inner in
                        ScrollView(.horizontal,showsIndicators: false) {
                            HStack(alignment:.center,spacing: 0){
                                ForEach(dragDateWeek,id: \.self) { str in
                                    HStack(alignment:.center,spacing: 0) {
                                        ForEach(str,id: \.self) { date in
                                            VStack {
                                                Text("\(dayOfMonth(date))")
                                                    .frame(width:inner.size.width
                                                           / 7,height: outerProxy.size.width / 7)
                                                    .foregroundColor(self.isSelected(date) ? .white : .black)
                                                    .background(self.isSelected(date) ? Color.blue : Color.clear)
                                                    .cornerRadius(outerProxy.size.width / 7)
                                                    .onTapGesture {
                                                        self.selectedDate = date
                                                        self.selectedDateMonthChang = date
                                                        loadData!()
                                                    }
                                                    .onAppear {
                                                        print(inner.size)
                                                    }
                                                
                                                
                                                let count =  eventCount(for: date)
                                                if count > 0 {
                                                    EventIndicator(count: count)
                                                }
                                                else {
                                                    Circle()
                                                        .fill(Color.clear)
                                                        .frame(width: 6, height: 6)
                                                }
                                            }
                                        }
                                    }
                                    
                                    .simultaneousGesture(
                                        DragGesture().onChanged({ value in
                                            let translation = value.translation.width
                                            if translation > 0 {
                                                print(str)
                                                selectedDateMonthChang = nil
                                                count -= 1
                                                selectedIndex = str
                                                print(count)
                                            } else {
                                                selectedDateMonthChang = nil
                                                print(str)
                                                selectedIndex = str
                                                count += 1
                                                print(count)
                                            }
                                            
                                        })
                                        .onEnded({ value in
                                            print(value)
                                        })
                                    )
                                    .id(str)
                                    
                                    .onAppear {
                                        scrollview.scrollTo(selectedIndex)
                                    }
                                }
                            }
                            
                        }
                        .scrollTargetLayout()
                        .onAppear{
                         
                                getDatesInNext365Days().forEach { date in
                                    let name = weekNameOfMonth(date.date)
                                    if dateName.count < 7 {
                                        dateName.append(name)
                                    }
                                }
                                var dateArray:[Date] = []
                                getDatesInNext365Days().forEach { date in
                                    dateArray.append(date.date)
                                }
                                dragDateWeek = splitArray(array: dateArray, intoChunksOf: 7)
                                print(dateArray)
                                print(dateName)
                                
                                for i in dragDateWeek {
                                    for d in i {
                                        if (dateStringRemoveTime(from: d) == dateStringRemoveTime(from: Date())) {
                                            selectedIndex = i
                                            print(selectedIndex)
                                            count = dragDateWeek.firstIndex(where: { countfound in
                                                countfound == i
                                            }) ?? 0
                                            
                                        }
                                    }
                                }
                                
                            }
                        
                    }
                    
                    
                }
                
                .scrollTargetBehavior(.paging)
                    .coordinateSpace(name: "scrollView")
                    .padding(.zero)
                
            }
        }
    }
    
    func splitArray(array: [Date], intoChunksOf chunkSize: Int) -> [[Date]] {
        var index = 0
        var chunks = [[Date]]()
        
        while index < array.count {
            let endIndex = min(index + chunkSize, array.count)
            chunks.append(Array(array[index..<endIndex]))
            index += chunkSize
        }
        
        return chunks
    }
    
    private func dayOfMonth(_ date: Date) -> String {
        let calendar = Calendar.current
        return String(calendar.component(.day, from: date))
    }
    
    
    private func getDatesInNext365Days() -> [calendarScrollview] {
        var dates = [calendarScrollview]()
        let calendar = Calendar.current
        for i in -694..<694 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfToday()) {
                dates.append(calendarScrollview(id: i, date: date))
            }
        }
        return dates
    }
    
    private func weekNameOfMonth(_ date: Date) -> String {
        let calendar = Calendar.current
        let weekDay =  String(calendar.component(.weekday, from: date))
        
        switch weekDay {
        case "1":
            return "Sun"
        case "2":
            return "Mon"
        case "3":
            return "Tue"
        case "4":
            return "Wed"
        case "5":
            return "Thu"
        case "6":
            return "Fri"
        case "7":
            return "Sat"
        default:
            return ""
        }
    }
    
    
    private func startOfToday() -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return today
    }
    
    private func isSelected(_ date: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    private func eventCount(for date: Date) -> Int {
        return events.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.count
    }
}

struct calendarScrollview : Identifiable{
    var id:Int
    var date:Date
}

struct CalendarDateView: View {
    let date: Date
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text("\(weekNameOfMonth(date))")
                .foregroundStyle(weekNameOfMonth(date) == "Sun" || weekNameOfMonth(date) == "Sat" ?  .red : .black)
            Text("\(dayOfMonth(date))")
                .foregroundStyle(weekNameOfMonth(date) == "Sun" || weekNameOfMonth(date) == "Sat" ?  .red : .black)
                .frame(width: 40,height: 40)
                .foregroundColor(isSelected ? .white : .black)
                .background(isSelected ? Color.blue : Color.clear)
                .cornerRadius(40)
        }
    }
    
    private func dayOfMonth(_ date: Date) -> String {
        let calendar = Calendar.current
        return String(calendar.component(.day, from: date))
    }
    
    private func weekNameOfMonth(_ date: Date) -> String {
        let calendar = Calendar.current
        let weekDay =  String(calendar.component(.weekday, from: date))
        
        switch weekDay {
        case "1":
            return "Sun"
        case "2":
            return "Mon"
        case "3":
            return "Tue"
        case "4":
            return "Wed"
        case "5":
            return "Thu"
        case "6":
            return "Fri"
        case "7":
            return "Sat"
        default:
            return ""
        }
    }
}

struct EventIndicator: View {
    let count: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<count, id: \.self) { _ in
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
            }
        }
    }
}

struct ScrollableCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollableCalendarView(selectedDate: .constant(Date()), events: .constant([        Event(date: Date().addingTimeInterval(86400 * 2), eventName: "Meeting"),Event(date: Date().addingTimeInterval(86400 * 4), eventName: "Party"),Event(date: Date().addingTimeInterval(86400 * 6), eventName: "Conference"),Event(date: Date().addingTimeInterval(86400 * 6), eventName: "Workshop")]))
    }
}




