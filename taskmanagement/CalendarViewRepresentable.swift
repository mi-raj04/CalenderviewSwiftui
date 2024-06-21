////
////  CalendarView.swift
////  taskmanagement
////
////  Created by mind on 19/03/24.
////
//
//
//import SwiftUI
//import FSCalendar
//
//struct CalendarViewRepresentable: UIViewRepresentable {
//    typealias UIViewType = FSCalendar
//    
//    var calendar = FSCalendar()
//    @Binding var selectedDate: Date
//    @Binding var eventData:[(date: Date, events: [String])]
//    
//    var changeDate:(() -> Void)?
//    
//    func makeUIView(context: Context) -> FSCalendar {
//        calendar.delegate = context.coordinator
//        calendar.dataSource = context.coordinator
//        calendar.appearance.todayColor = UIColor(displayP3Red: 0,
//                                                 green: 0,
//                                                 blue: 0, alpha: 0)
//        calendar.appearance.titleTodayColor = .black
//        calendar.appearance.selectionColor = .red
//        calendar.appearance.eventDefaultColor = .red
//        calendar.appearance.titleTodayColor = .blue
//        calendar.appearance.titleFont = .boldSystemFont(ofSize: 12)
//        calendar.appearance.weekdayTextColor = .systemPink
//        
//        calendar.appearance.headerMinimumDissolvedAlpha = 0.12
//        calendar.appearance.headerTitleFont = .systemFont(
//            ofSize: 18,
//            weight: .black)
//        calendar.appearance.headerTitleColor = .darkGray
//        calendar.appearance.headerDateFormat = "MMMM-YYYY"
//        calendar.scrollDirection = .horizontal
//        calendar.scope = .week
//        calendar.clipsToBounds = true
//        
//        return calendar
//    }
//    
//    func updateUIView(_ uiView: FSCalendar, context: Context) {
//        uiView.select(self.selectedDate)
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject,
//                       FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
//        var parent: CalendarViewRepresentable
//        
//        init(_ parent: CalendarViewRepresentable) {
//            self.parent = parent
//        }
//        
//        func calendar(_ calendar: FSCalendar,
//                      didSelect date: Date,
//                      at monthPosition: FSCalendarMonthPosition) {
//            parent.selectedDate = date
//            parent.changeDate!()
//        }
//        
//        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//            
//            if isWeekend(date: date) {
//                return .orange
//            } else {
//                return .black
//            }
//        }
//        
//        func calendar(_ calendar: FSCalendar,
//                      numberOfEventsFor date: Date) -> Int {
//            
//            var ListOfeventDate:[Date] = []
//            for i in parent.eventData {
//                for _ in i.events {
//                    ListOfeventDate.append(i.date)
//                }
//            }
//            
//            var eventCount = 0
//            ListOfeventDate.forEach { eventDate in
//                if eventDate.formatted(date: .complete,
//                                       time: .omitted) == date.formatted(
//                                        date: .complete, time: .omitted){
//                    eventCount += 1;
//                }
//            }
//            
//            return eventCount
//        }
//        
//        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//            return true
//        }
//    }
//}
//
//func isWeekend(date: Date) -> Bool {
//    let calendar = Calendar.current
//    let weekday = calendar.component(.weekday, from: date)
//    return weekday == 1 || weekday == 7
//}
