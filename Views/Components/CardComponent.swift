//
//  CardComponent.swift
//  QuickDictionary
//
//  Created by Saksham Gupta on 6/13/21.
//

import SwiftUI


struct CardComponent: View {
    
    var id = UUID()
    var word: String
    var sound: String
    var meaning: String
    var upvotes: Int
    var downvotes: Int
    var partOfSpeech: String
    var image: String
    //upvotes, downvotes, speaker button, image, part of speech
    
    var body: some View {
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
                        .padding(.top, -4)
//                            .padding(.leading)
                    
                }
                .layoutPriority(100)
 
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
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing), lineWidth: 2)
        )
        .padding([.top, .horizontal])
    }
}

struct AllButtonStyle: ButtonStyle{
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
    }
}

struct CardComponent_Previews: PreviewProvider {
    static var previews: some View {
        CardComponent(word: "insanity", sound: "/inˈsanədē/", meaning: "the state of being seriously mentally ill", upvotes: 5, downvotes: 3, partOfSpeech: "noun", image: "swiftui-button")
    }
}
