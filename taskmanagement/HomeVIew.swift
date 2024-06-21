//
//  HomeVIew.swift
//  taskmanagement
//
//  Created by mind on 29/03/24.
//

import SwiftUI

struct HomeVIew: View {
    var body: some View {
        NavigationStack {
            NavigationLink.init(destination: ContentView(tempArray: [],manageTitle: [], showableTitle: [])) {
                Text("Add Event")
            }
        }
    }
}

#Preview {
    HomeVIew()
}
