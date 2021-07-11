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
    @State var image_url = "https://cdn.dribbble.com/users/488402/screenshots/2886180/comp_1_1.gif"
    
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

                    CardDetailedView(word: cards[cardToDisplay].word, sound: cards[cardToDisplay].sound, meaning: cards[cardToDisplay].meaning, upvotes: cards[cardToDisplay].upvotes, downvotes: cards[cardToDisplay].downvotes, partOfSpeech: cards[cardToDisplay].partOfSpeech, image: self.image_url, example: cards[cardToDisplay].example, synonyms: cards[cardToDisplay].synonyms, index: cardToDisplay, upvoters: cards[cardToDisplay].upvoters, downvoters: cards[cardToDisplay].downvoters)
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
    
    func callApi() {
        
        self.cards.removeAll()
        
        print("image api entered: ---------------------")
        
        // code for image API call, result will be passed into CardComponent object in API dictionary call below
        let image_api_link = "https://api.unsplash.com/search/collections?page=1&query=\(word)&client_id=OGVJ9t8SOGeO3_Up8Hjz_cm7jQzA8AdGbsNb6f6jz58"
        guard let image_api_url = URL(string: image_api_link) else {
            print("Image API end point invalid")
            return
        }
        
        let task = URLSession.shared.dataTask(with: image_api_url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                print("we hit an error in the API...")
                return
            }
            
            var result: ImageAPIResponse?
            do {
                result = try JSONDecoder().decode(ImageAPIResponse.self, from: data)
            } catch {
                print("Decoder failed to decode: \(error)")
            }
            
            guard let finalResult = result else {
                print("result was not decoded properly")
                return
            }
            
            print("Data: \(data)")
            print("Title: \(finalResult.results?[0].title)")
            
            self.image_url = finalResult.results?[0].preview_photos?[0].urls?.raw ?? "no url"
            print("IMAGE URL: " + self.image_url)
        })
        
        task.resume()
        
        print("image api exited: ---------------------")
        
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

// code for Unsplash Image API Codable decoder

struct ImageAPIResponse: Codable {
    let total: Int?
    let total_pages: Int?
    let results: [ImageAPIResponseResult]?
}

struct ImageAPIResponseResult: Codable {
    let id: String?
    let title: String?
    var description: String?
    let published_at: String?
    let last_collected_at: String?
    let updated_at: String?
    let curated: Bool?
    let featured: Bool?
    let total_photos: Int?
    let `private`: Bool? ////////////------------------------------------------
    let share_key: String?
    let tags: [ImageAPIResponseTag]?
    let links: ImageAPIResponseLinks?
    let user: ImageAPIResponseUser?
    let cover_photo: ImageAPIResponseCoverPhoto?
    let preview_photos: [ImageAPIResponsePreviewPhoto]?
}

struct ImageAPIResponseTag: Codable {
    let type: String?
    let title: String?
    var source: ImageAPIResponseSource?
}

struct ImageAPIResponseSource: Codable {
    var ancestry: ImageAPIResponseSourceAncestry?
    var title: String?
    var subtitle: String?
    var description: String?
    var meta_title: String?
    var meta_description: String?
    var cover_photo: ImageAPIResponseCoverPhoto?
}

struct ImageAPIResponseSourceAncestry: Codable {
    var type: ImageAPIResponseSlug?
    var category: ImageAPIResponseSlug?
    var subcategory: ImageAPIResponseSlug?
}

struct ImageAPIResponseSlug: Codable {
    var slug: String?
    var pretty_slug: String?
}

struct ImageAPIResponseLinks: Codable {
    let `self`: String? ////////////------------------------------------------
    let html: String?
    let photos: String?
    let related: String?
}

struct ImageAPIResponseUser: Codable {
    let id: String?
    let updated_at: String?
    let username: String?
    let name: String?
    let first_name: String?
    let last_name: String?
    let twitter_username: String?
    let portfolio_url: String?
    let bio: String?
    let location: String?
    let links: ImageAPIResponseUserLinks?
    let profile_image: ImageAPIResponseProfileImage?
    let instagram_username: String?
    let total_collections: Int?
    let total_likes: Int?
    let total_photos: Int?
    let accepted_tos: Bool?
    let for_hire: Bool?
    let social: ImageAPIResponseSocial?
}

struct ImageAPIResponseUserLinks: Codable {
    let `self`: String? ////////////------------------------------------------
    let html: String?
    let photos: String?
    let likes: String?
    let portfolio: String?
    let following: String?
    let followers: String?
}

struct ImageAPIResponseProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct ImageAPIResponseSocial: Codable {
    let instagram_username: String?
    let portfolio_url: String?
    let twitter_username: String?
}

struct ImageAPIResponseCoverPhoto: Codable {
    let id: String?
    let created_at: String?
    let updated_at: String?
    let promoted_at: String?
    let width: Double?
    let height: Double?
    let color: String?
    let blur_hash: String?
    let description: String?
    let alt_description: String?
    let urls: ImageAPIResponseCoverPhotoUrls?
    let links: ImageAPIResponseCoverPhotoLinks?
    let categories: [String]?
    let likes: Int?
    let liked_by_user: Bool?
    let current_user_collections: [String]?
    let sponsorship: String?
    let user: ImageAPIResponseCoverPhotoUser?
}

struct ImageAPIResponseCoverPhotoUrls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

struct ImageAPIResponseCoverPhotoLinks: Codable {
    let `self`: String? ////////////------------------------------------------
    let html: String?
    let download: String?
    let download_location: String?
}

struct ImageAPIResponseCoverPhotoUser: Codable {
    let id: String?
    let updated_at: String?
    let username: String?
    let name: String?
    let first_name: String?
    let last_name: String?
    let twitter_username: String?
    let portfolio_url: String?
    let bio: String?
    let location: String?
    let links: ImageAPIResponseUserLinks?
    let profile_image: ImageAPIResponseProfileImage?
    let instagram_username: String?
    let total_collections: Int?
    let total_likes: Int?
    let total_photos: Int?
    let accepted_tos: Bool?
    let for_hire: Bool?
}

struct ImageAPIResponsePreviewPhoto: Codable {
    let id: String?
    let created_at: String?
    let updated_at: String?
    let blur_hash: String?
    let urls: ImageAPIResponsePreviewPhotoUrls?
}

struct ImageAPIResponsePreviewPhotoUrls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

