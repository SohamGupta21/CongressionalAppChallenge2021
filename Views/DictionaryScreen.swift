//
//  DictionaryScreen.swift
//  QuickDictionary
//
//  Created by Saksham Gupta on 6/13/21.
//

import SwiftUI
import Foundation
import FirebaseFirestore

struct DictionaryScreen: View {
    @State private var isPresented = false
    @State var results = [TaskEntry]()
    @State var word:String
    @State var cards: [CardComponent] = []
    @State var cardToDisplay = 0
    
    let database = Firestore.firestore()

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
                    TextField("Search", text: $word, onCommit: {
                        loadData()
                    })
                }
                .padding()
                ScrollView{
                    VStack{
                        ForEach(cards.indices, id: \.self){ card in
                            Button(action:{
                                isPresented = true
                            },label:{
                                cards[card]
                                    .onTapGesture {
                                        isPresented = true
                                        cardToDisplay = cards[card].index
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

                    CardDetailedView(word: cards[cardToDisplay].word, sound: cards[cardToDisplay].sound, meaning: cards[cardToDisplay].meaning, upvotes: cards[cardToDisplay].upvotes, downvotes: cards[cardToDisplay].downvotes, partOfSpeech: cards[cardToDisplay].partOfSpeech, image: "swiftui-button", example: cards[cardToDisplay].example, synonyms: cards[cardToDisplay].synonyms, index: cardToDisplay, upvoters: cards[cardToDisplay].upvoters, downvoters: cards[cardToDisplay].downvoters)
                        .navigationBarHidden(true)
                }
                
            }
        }.onAppear(perform: loadData)
    }
    
    func checkFirebase(){
        print("CHECKING FIREBASE")
        let docRef = database.collection("wordsindb").document("words")
        var bool: Bool = false

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()?["words"] as? [String] ?? []
                for wordin in dataDescription{
                    if(wordin == word){
                        bool = true
                    }
                }
                if(bool){
                    print("BOOL IS TRUE")
                    cards.removeAll()
                    database.collection("words").whereField("word", isEqualTo: word)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                print("GOT DOCUMENT")
                                for document in querySnapshot!.documents {
                                    print("GOT SNAPSHOT")
                                    var data = document.data() as? [String:Any]

                                    var definitions : [String:Any]  = document.data()["meaning-definitions"] as? [String:Any] ?? [:]
                                    var keys = definitions.keys as? [[String]]
                                    
                                    for (key, val) in definitions{
                                        var map = val as! [String:Any]
//                                        print(map[key])
                                        
                                        let def = map["definition"] as? String ?? ""
                                        let synonyms = map["synonyms"] as? [String] ?? []
                                        let example = map["example"] as? String ?? ""
                                        let partOfSpeech = map["partOfSpeech"] as? String ?? ""
                                        let upvotes = map["upvotes"] as? Int ?? 0
                                        let downvotes = map["downvotes"] as? Int ?? 0

                                        var cardToAdd = CardComponent(word: data?["word"] as! String, sound: data?["phonetics-text"] as! String, meaning: def, upvotes: upvotes, downvotes: downvotes, partOfSpeech: partOfSpeech, image: "swiftui-button", example: example, synonyms: synonyms, upvoters: [], downvoters: [], index: Int(key)!)
                                        cards.append(cardToAdd)
                                        
                                    }
//                                    print(keys)
//                                    print(definitions?.keys)
//                                        for definition in definitions ?? [] {
                                            
//                                        }
                                    }
                                }
                            }
                    }else{
                        print("IT CALLED THE APIPIPIPIPIPIPIPPIPIIPIPI")
                        callApi()
                    }
                }
            }
        }
    
    func callApi(){
        self.cards.removeAll()
        let full_word = "https://api.dictionaryapi.dev/api/v2/entries/en_US/" + word
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
                        var word = response[0].word
                        var sound = response[0].phonetics[0].text
                        var count = 0
                        var meaningsDefinitionsToAdd = [String: Any]()
                
                        for meaning in response[0].meanings{
                            cards.append(CardComponent(word: response[0].word, sound: response[0].phonetics[0].text ?? "", meaning: meaning.definitions?[0].definition ?? "", upvotes: 0, downvotes: 0, partOfSpeech: meaning.partOfSpeech ?? "", image: "swiftui-button", example: meaning.definitions?[0].example ?? "", synonyms:meaning.definitions?[0].synonyms ?? [], upvoters: [], downvoters: [], index: count))
                            var docData:[String:Any] = [:]
                            docData["definition"] = meaning.definitions?[0].definition ?? ""
                            docData["example"] = meaning.definitions?[0].example ?? ""
                            docData["partOfSpeech"] = meaning.partOfSpeech ?? ""
                            docData["synonyms"] = meaning.definitions?[0].synonyms ?? []
                            docData["upvotes"] = 0
                            docData["downvotes"] = 0
                            docData["upvoters"] = []
                            docData["downvoters"] = []
                            meaningsDefinitionsToAdd[String(count)] = docData
                            count += 1
                            
                        }
                        database.collection("words").document(word).setData([
                            "phonetics-text": sound ?? "",
                            "word": word,
                            "phonetics-audio": response[0].phonetics[0].audio ?? "",
                            "meaning-definitions": meaningsDefinitionsToAdd
                        ])
                        database.collection("wordsindb").document("words").updateData(["words" : FieldValue.arrayUnion([word])]) { (error) in

                                if let error = error {
                                    print(error.localizedDescription)
                                }
                        }
                    }
                    return
                }else{
                    print("ERROR")
                }
            }
        }.resume()
    }
    
    func loadData() {
        if(word != ""){
            checkFirebase()
        }
        print("END OF LOAD DATA")
    }
}

struct DictionaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryScreen(word: "")
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
