//
//  CardComponent.swift
//  QuickDictionary
//
//  Created by Saksham Gupta on 6/13/21.
//

import SwiftUI
import FirebaseFirestore

struct CardComponent: View {
    
    var id = UUID()
    var word: String
    var sound: String
    var meaning: String
    var partOfSpeech: String
    var image: String
    var example: String
    var synonyms: [String]
    var index: Int
    @State var upvotes = 0
    @State var downvotes = 0
    @State private var isPresented = false
    var uid: String

//    var upvotes = 0
//    var downvotes = 0
    //upvotes, downvotes, speaker button, image, part of speech
    
    let database = Firestore.firestore()
    
    func getUpvotesDownvotes() {
        database.collection("upvotes").whereField("uid", isEqualTo: uid)
            .getDocuments() {(querySnapshot, err) in
                upvotes += 1
            }
        
        database.collection("downvotes").whereField("uid", isEqualTo: uid)
            .getDocuments() {(querySnapshot, err) in
                downvotes += 1
            }
    }
    
    
    var body: some View {
        Button(action:{
            isPresented = true
        },label:{
            VStack {
    //                Image(image)
    //                    .resizable()
    //                    .aspectRatio(contentMode: .fit)
     
                HStack {
                    VStack(alignment: .leading) {
                        
    //                        Text(word)
    //                            .font(.title)
    //                            .foregroundColor(.primary)
    //                            .lineLimit(3)
    //                        Text(sound)
    //                            .font(.title3)
    //                            .padding(.top, -8)
                        Text(partOfSpeech.lowercased())
                            .font(.callout)
                            .italic()
                            .foregroundColor(.secondary)
                        Text(meaning)
                            .foregroundColor(.primary)
                            .padding(.top, -4)
    //                            .padding(.leading)
                        
                    }
    //                .layoutPriority(100)
     
                    Spacer()
                }
                .padding(.leading)
                .padding(.top)
                .padding(.trailing)
                HStack {
                    Button(action: {
                        //firebase right here
                    }, label: {
                        Label(String(upvotes), systemImage: "hand.thumbsup")
                            .font(.callout)
                    })
                    .buttonStyle(AllButtonStyle())
                    
                    Spacer()
                    Button(action: {
                        //firebase right here
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
            .sheet(isPresented: $isPresented){
                NavigationView{

                    CardDetailedView(word: word, sound: sound, meaning: meaning, upvotes: upvotes, downvotes: downvotes, partOfSpeech: partOfSpeech, image: image, example: example, synonyms: synonyms, index: 0)
                        .navigationBarHidden(true)
                }
                
            }
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing), lineWidth: 2)
                    .contentShape(Rectangle())
            )
            .padding([.top, .horizontal])
//                                    .onTapGesture {
//                                        isPresented = true
//                                        cardToDisplay = cards[card].index
//                                    }
//                .foregroundColor(Color.white)
        })
        
        
//        .onAppear(perform: getUpvotesDownvotes)
    }
}

struct AllButtonStyle: ButtonStyle{
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.primary)
    }
}

struct CardComponent_Previews: PreviewProvider {
    static var previews: some View {
        CardComponent(word: "insaity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", partOfSpeech: "noun", image: "swiftui-button", example: "WIFUHEF", synonyms: [], index: 0, uid: "WEOUWEF")
    }
}
