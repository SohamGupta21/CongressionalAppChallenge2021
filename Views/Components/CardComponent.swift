//
//  CardComponent.swift
//  QuickDictionary
//
//  Created by Saksham Gupta on 6/13/21.
//

import SwiftUI

struct CardComponent: View {
    var body: some View {
        VStack(alignment: .leading) {
            //image, phonetics, word, definition
            Text("Discombobulate")
                .font(.headline)
            Image("systemName:person.fill")
            Spacer()
            HStack {
                Label("14", systemImage: "person.3")
                Spacer()
                Label("20", systemImage: "clock")
                    .padding(.trailing, 20)
            }
            .font(.caption)
        }
        .padding()
        
    }
}

struct CardComponent_Previews: PreviewProvider {
    static var previews: some View {
        CardComponent()
    }
}
