//
//  CardDetailedView.swift
//  QuickDictionary
//
//  Created by soham gupta on 6/15/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CardDetailedView: View {
    
    var id = UUID()
    var word: String
    var sound: String
    var meaning: String
    @State var upvotes: Int
    @State var downvotes: Int
    var partOfSpeech: String
    var image: String
    var example: String
    var synonyms: [String]
    var index: Int
    @State var upvoters: [String]
    @State var downvoters: [String] = []
    
    let database = Firestore.firestore()

    //upvotes, downvotes, speaker button, image, part of speech
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView{
                VStack(alignment: .leading){
                    
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    VStack(alignment: .leading){
                        Text(word)
                            .font(.title)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                        Text(sound)
                            .font(.title3)
                            .padding(.top, -8)
                        Text(partOfSpeech.lowercased())
                            .font(.callout)
                            .italic()
                            .foregroundColor(.secondary)
                        Text(meaning)
                            .padding(.top, -4)
                            .padding(.leading)
                        
                    }
                    .layoutPriority(100)
                    .padding(.top)
                    .padding(.leading)
                  
                }
                VStack(alignment: .leading){
                    HStack{
                        VStack(alignment:.leading){
                            Text("Examples:")
                                .font(.headline)
                            Text(example)
                                .padding(.leading)
                                .padding(.trailing)
                        }
                        Spacer()
                    }
                    .padding(.leading)
                    .layoutPriority(100)
                }
                
                HStack {
                    Button(action: {
                        //firebase right here
                        print("CLICKED UPVOTE")
                        let user = Auth.auth().currentUser?.email
                        var docData:[String:Any] = [:]
                        if(downvoters.contains(user!)){
                            docData["downvotes"] = downvotes - 1
                            docData["downvoters"] = FieldValue.arrayRemove([user!])
                            self.downvotes -= 1
                            self.downvoters.remove(at: downvoters.firstIndex(of: user!)!)
                        }
                        docData["upvotes"] = upvotes + 1
                        docData["upvoters"] = FieldValue.arrayUnion([user!])
                        database.collection("words").document(word).setData([
                            "meaning-definitions": [String(index): docData]
                        ], merge: true)
                        self.upvotes += 1
                        self.upvoters.append(user!)
                    }, label: {
                        Label(String(upvotes), systemImage: "hand.thumbsup")
                            .font(.callout)
                    })
                    .buttonStyle(AllButtonStyle())
                    
                    Spacer()
                    Button(action: {
                        //firebase right here
                        print("CLICKED DOWNVOTE")
                        let user = Auth.auth().currentUser?.email
                        var docData:[String:Any] = [:]
                        if(upvoters.contains(user!)){
                            docData["upvotes"] = upvotes - 1
                            docData["upvoters"] = FieldValue.arrayRemove([user!])
                            self.upvotes -= 1
                            print(upvoters)
                            self.upvoters.remove(at: downvoters.firstIndex(of: user!) ?? 0)
                        }
                        docData["downvotes"] = downvotes + 1
                        database.collection("words").document(word).setData([
                            "meaning-definitions": [String(index): docData]
                        ], merge: true)
                        
                        self.downvotes += 1
                        self.upvoters.append(user!)
                    }, label: {
                        Label(String(downvotes), systemImage: "hand.thumbsdown.fill")
                            .font(.callout)
                    })
                    .buttonStyle(AllButtonStyle())
                    
                }
                .font(.caption)
                .padding()
                .padding(.leading)
                .padding(.trailing)
            }
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing), lineWidth: 2)
            )
            .padding([.top, .horizontal, .bottom])
            
        }
        .foregroundColor(Color.primary)
    }
}



struct CardDetailedView_Previews: PreviewProvider {
    static var previews: some View {
    CardDetailedView(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button", example: "IUHRWUI", synonyms: [], index: 0, upvoters: [], downvoters: [])
    }
}

