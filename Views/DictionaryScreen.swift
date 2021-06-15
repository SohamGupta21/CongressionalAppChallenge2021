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
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("Placeholder", text: .constant(""))
                }
                .padding()
                Spacer()
                CardComponent()
                    .padding()
                CardComponent()
                    .padding()
            }
            .navigationTitle(Text("Dictionary"))
        }
        
    }
}

struct DictionaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryScreen()
    }
}
