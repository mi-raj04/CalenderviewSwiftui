//
//  Model.swift
//  taskmanagement
//
//  Created by mind on 21/03/24.
//

import Foundation
import SwiftUI
struct totalMinutes:Identifiable {
    var min:Int
    var color:Color
    var id = UUID()
    
    init(min: Int, color: Color) {
        self.min = min
        self.color = color
    }
}

struct manageEventMinutes {
    var date:Date
    var arraTotalMinutes:[Int]
}

struct titleWithSpace:Identifiable {
    var id = UUID()
    var date:Date
    var title:String
    var space:Int
    var height:Int
}
