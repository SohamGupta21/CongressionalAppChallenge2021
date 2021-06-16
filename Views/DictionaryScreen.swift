//
//  DictionaryScreen.swift
//  QuickDictionary
//
//  Created by Saksham Gupta on 6/13/21.
//

import SwiftUI

struct DictionaryScreen: View {
    @State private var isPresented = false
    var body: some View {
        let cards = [CardComponent(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button"),CardComponent(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button"),CardComponent(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button"),CardComponent(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button"),CardComponent(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button"),CardComponent(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button")]
        NavigationView{
            VStack{
                HStack{
                    Text("Quictionary").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.largeTitle).foregroundColor(.clear).padding([.trailing]).overlay(LinearGradient(gradient: Gradient(colors: [Color.red,Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing).mask(Text("Quictionary").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.largeTitle).scaledToFill()))
                        .padding(.top)
                    Spacer()
                }.padding(.top)
                
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
                            Button(action:{
                                isPresented = true
                            },label:{
                                cards[card]
                                    .onTapGesture {
                                        print("got here")
                                        isPresented = true
                                    }
                                    .foregroundColor(Color.white)
                            })
                            
                            
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .sheet(isPresented: $isPresented){
                NavigationView{
                    CardDetailedView(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button")
                        .navigationBarHidden(true)
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
