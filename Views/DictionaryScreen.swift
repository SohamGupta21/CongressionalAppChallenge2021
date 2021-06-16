//
//  DictionaryScreen.swift
//  QuickDictionary
//
//  Created by Saksham Gupta on 6/13/21.
//

import SwiftUI
import Foundation

struct DictionaryScreen: View {
    @State private var isPresented = false
    @State var results = [TaskEntry]()
    @State var word = "insult"
    @State var cards: [CardComponent] = []

    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Text("Quictionary").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.largeTitle).foregroundColor(.clear).padding([.trailing]).overlay(LinearGradient(gradient: Gradient(colors: [Color.red,Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing).mask(Text("Quictionary").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.largeTitle).scaledToFill()))
                        .padding(.top)
                    Spacer()
                }.padding(.top)
                
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("Placeholder", text: $word){
                        loadData()
                    }
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
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        self.cards.removeAll()
        var full_word = "https://api.dictionaryapi.dev/api/v2/entries/en_US/" + word
        guard let url = URL(string: full_word ) else {
            print("Your API end point is Invalid")
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([TaskEntry].self, from: data) {
                    DispatchQueue.main.async {
                        self.results = response
                        print("FWIUWEIFUWEIUFWEIFYGWEIYFGK", response)
                        for meaning in response[0].meanings{
                            self.cards.append(CardComponent(word: response[0].word, sound: response[0].phonetics[0].audio ?? "sdfsd", meaning: meaning.definitions?[0].definition ?? "sdfsf", upvotes: 5, downvotes: 5, partOfSpeech: meaning.partOfSpeech ?? "sdfdfs", image: "swiftui-button"))
                        }
                    }
                    return
                }else{
                    print("ERROR")
                }
            }
        }.resume()
//        print("ifygweifgwefi", self.results)
    }
}

struct DictionaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryScreen()
    }
}

struct TaskEntry: Codable  {
    var word: String
    var phonetics: [Phonetics]
    var meanings: [Meanings]
}

struct Phonetics: Codable {
    var text: String?
    var audio: String?
}

struct Meanings: Codable{
    var partOfSpeech: String?
    var definitions: [Definitions]?
}

struct Definitions: Codable{
    var definition: String?
    var example: String?
    var synonyms: [String]?
}
