//
//  DictionaryScreen.swift
//  QuickDictionary
//
//  Created by Saksham Gupta on 6/13/21.
//

import SwiftUI

struct DictionaryScreen: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Dictionary")
            //            NavigationLink(
            //                destination: CameraScreen(),
            //                label: {
            //                    Text("Home")
            //            }).navigationTitle("Dictionary")

                TextField("Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant(""))
            }
        }
        
    }
}

struct DictionaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryScreen()
    }
}
