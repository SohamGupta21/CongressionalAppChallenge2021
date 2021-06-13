//
//  DictionaryScreen.swift
//  QuickDictionary
//
//  Created by Saksham Gupta on 6/13/21.
//

import SwiftUI

struct DictionaryScreen: View {
    var body: some View {
        NavigationView {

                    TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)

                
            .navigationTitle(Text("SwiftUI"))
        }
        
    }
}

struct DictionaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryScreen()
    }
}
