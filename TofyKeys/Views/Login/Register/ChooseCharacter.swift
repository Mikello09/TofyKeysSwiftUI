//
//  ChooseCharacter.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 29/4/22.
//

import SwiftUI

struct Character: Hashable {
    var name: String
    var selected: Bool
}

struct ChooseCharacter: View {
    
    @State var characters: [Character] = [Character(name: "man_1", selected: true),
                                   Character(name: "woman_1", selected: false)]
    @Binding var choosenCharacter: String
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyHStack(spacing: 8){
                ForEach(characters, id: \.self) { character in
                    Image(character.name)
                        .resizable()
                        .frame(width: 96, height: 96)
                        .aspectRatio(contentMode: .fit)
                        .border(character.selected ? Color.primaryColor : Color.blackTofy, width: character.selected ? 4 : 2)
                        .cornerRadius(4)
                        .onTapGesture {
                            self.characters = self.characters.map({ ch -> Character in
                                var newCharacter = ch
                                newCharacter.selected = ch.name == character.name
                                return newCharacter
                            })
                            self.choosenCharacter = self.characters.filter({$0.selected}).first?.name ?? "man_1"
                        }
                }
            }
        }
    }
}

struct ChooseCharacter_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCharacter(choosenCharacter: .constant("man_1"))
    }
}
