//
//  CardDetailedView.swift
//  QuickDictionary
//
//  Created by soham gupta on 6/15/21.
//

import SwiftUI
import FirebaseFirestore

struct CardDetailedView: View {
    
    var id = UUID()
    var word: String
    var sound: String
    var meaning: String
    var upvotes: Int
    var downvotes: Int
    var partOfSpeech: String
    var image: String
    var example: String
    
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
        CardDetailedView(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button", example: "IUHRWUI")
    }
}

