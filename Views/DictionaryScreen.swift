//
//  DictionaryScreen.swift
//  QuickDictionary
//
//  Created by Saksham Gupta on 6/13/21.
//

import SwiftUI

struct DictionaryScreen: View {
    var body: some View {
        var cards = [CardComponent(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button")]
        VStack{
            HStack{
                Image(systemName: "magnifyingglass")
                TextField("Placeholder", text: .constant(""))
            }
            .padding()
            ScrollView{
                VStack{
//                    for card in 0..<cards.count {
//                        cards[card]
//                            .on
//                    }
                    ForEach(cards.indices, id: \.self){ card in
                        cards[card]
                            .onTapGesture {
//                                cards[card].downvotes = cards[card].downvotes + 1
                                print("got here")
                            }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct DictionaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryScreen()
    }
}
