//
//  Story.swift
//  RollDice
//
//  Created by aplle on 4/18/23.
//

import SwiftUI

struct Story: View {
    @State var rolllsArray = [Dice]()
    var body: some View {
        NavigationView{
            ZStack{
                Color.background.ignoresSafeArea()
                List(rolllsArray){roll in
                    VStack{
                        Text(String(roll.number))
                        
                    }
                    .listRowBackground(Color.background)
                }
                .onAppear(perform: loadRolls)
            }
        }
    }
    func loadRolls(){
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: "Rolls"){
            if let decoded = try? decoder.decode([Dice].self, from: data){
                rolllsArray = decoded
            }
        }
    }
}

struct Story_Previews: PreviewProvider {
    static var previews: some View {
        Story()
    }
}
