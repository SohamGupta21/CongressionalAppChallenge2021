//
//  ContentView.swift
//  QuickDictionary
//
//  Created by soham gupta on 6/13/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DictionaryScreen()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
        }
    }
}
