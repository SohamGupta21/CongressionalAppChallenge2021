//
//  QuickDictionaryApp.swift
//  QuickDictionary
//
//  Created by soham gupta on 6/13/21.
//

import SwiftUI
import Firebase

@main
struct QuickDictionaryApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
