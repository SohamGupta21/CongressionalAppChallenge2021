//
//  HomeScreen.swift
//  QuickDictionary
//
//  Created by soham gupta on 6/13/21.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationView{
            NavigationLink(
                destination: CameraScreen(),
                label: {
                    Text("Home")
            }).navigationTitle("Hello Abgay")
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
