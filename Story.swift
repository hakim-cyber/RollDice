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
                    ScrollView(.horizontal){
                        VStack(alignment: .leading){
                            Text("Total:\(calculateTotal(for:roll))")
                                .bold()
                                .padding(0.5)
                            HStack{
                               
                                ForEach(roll.numbersArray.indices,id:\.self) { index in
                                    
                                    
                                    Text("\(roll.numbersArray[index])")
                                    
                                }
                                
                            }
                        }
                        .padding()
                        
                    }
                    .background(Color.Lightbackground)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                   
                    .listRowBackground(Color.background)
                }
                .listStyle(.plain)
                .onAppear(perform: loadRolls)
            }
        }
    }
    func loadRolls(){
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: "roll"){
            if let decoded = try? decoder.decode([Dice].self, from: data){
                rolllsArray = decoded
            }
        }
    }
    func calculateTotal(for dice:Dice) -> Int{
        var total = 0
        for number in dice.numbersArray{
            total += number
        }
        return total
        
    }
    
}

struct Story_Previews: PreviewProvider {
    static var previews: some View {
        Story()
    }
}
