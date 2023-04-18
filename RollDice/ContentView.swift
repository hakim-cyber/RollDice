//
//  ContentView.swift
//  RollDice
//
//  Created by aplle on 4/17/23.
//

import SwiftUI

struct ContentView: View {
    @State private var diceNumber = 1
    @State private var diceNumbersArray = [Int]()
    
    @State private var diceCount = 1
    
    @State private var diceType = 6

    @State var isChanging = false
    @State var rollsArray = [Dice]()
    
    @State private var showHistory = false
    
    var body: some View {
            NavigationView{
                ZStack{
                    Color.background
                        .ignoresSafeArea()
                    VStack{
                       RoundedRectangle(cornerRadius:  30)
                            .fill(.white)
                            .frame(width: 100,height: 100)
                            .padding(100)
                            .overlay{
                                Text("\(diceNumber)")
                                    .font(.headline)
                                    .bold()
                            }
                           
                            
                            
                        Button("Roll"){
                            loadRolls()
                            roll.startTimer()
                            save()
                           
                        }
                        
                    }
                    .onChange(of: rollsArray){_ in
                        save()
                    }
                     
                }
                .navigationTitle("RollDice")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    self.roll = Roll(diceNumber: self.$diceNumber,rollsArray: self.$rollsArray)
                }
                .toolbar{
                    Button{
                            showHistory = true
                        
                    }label: {
                        Image(systemName: "arrow.down.app.fill")
                            .font(.headline)
                    }
                }
                .sheet(isPresented: $showHistory){
                    Story()
                        
                }
                
                
            }
           
    }
    func loadRolls(){
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: "Rolls"){
            if let decoded = try? decoder.decode([Dice].self, from: data){
                rollsArray = decoded
            }
        }
    }
    func save(){
           let encoder = JSONEncoder()
           if let encoded = try? encoder.encode(rollsArray){
               UserDefaults.standard.set(encoded, forKey: "Rolls")
           }
       }
    @State private var roll: Roll!
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}













class Roll:ObservableObject{
    var timer:Timer?
    @Binding var diceNumber:Int
    @Binding var rollsArray:[Dice]
    
    private var rollCount: Int = 0
        private let maxRollCount: Int = 6
    
    init(diceNumber: Binding<Int>,rollsArray: Binding<[Dice]>) {
           self._diceNumber = diceNumber
        self._rollsArray = rollsArray
        
       }
       
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){timer in
            withAnimation {
                
                
                if self.rollCount < self.maxRollCount {
                    self.diceNumber = Int.random(in: 1...6)
                    self.rollCount += 1
                } else {
                    
                    self.stop()
                    let newroll = Dice(number: self.diceNumber)
                    self.rollsArray.append(newroll)
                    
                   
                }
               
            }
            
        }
    }
    func stop(){
        timer?.invalidate()
        timer = nil
        self.rollCount = 0
        
    }
   
   
}
