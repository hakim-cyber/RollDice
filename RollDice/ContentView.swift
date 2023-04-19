//
//  ContentView.swift
//  RollDice
//
//  Created by aplle on 4/17/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var diceNumber = 1
    @State  var diceNumbersArray = [1]
    @State var rotation = 0.0
    
    @State  var diceCount = 1
    let dicecounts = Array(1...100)
    @State  var diceType = 6

    @State var isChanging = false
    @State var rollsArray = [Dice]()
    @State private var showSettings = false
    @State var total = 0
    
    @State private var showHistory = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
            NavigationView{
                ZStack{
                   
                    Color.background
                        .ignoresSafeArea()
                    VStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.Lightbackground)
                            .frame(width: 350,height: 100)
                            .overlay{
                                Text("Total :\(calculateTotal(for:diceNumbersArray))")
                                    .scaledToFill()
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .fixedSize()
                                    .padding()
                            }
                            .padding(30)
                        
                        ScrollView{
                            LazyVGrid(columns: columns){
                                
                                ForEach(diceNumbersArray.indices,id: \.self){index in
                                    
                                    if diceNumbersArray[index] <= 6{
                                        Image("dice \(diceNumbersArray[index])")
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .frame(width: 50, height: 50)
                                        .rotation3DEffect(
                                                       .degrees(rotation),
                                                       axis: (x: 0.0, y: 1.0, z: 0.0)
                                                   )
                                        .padding()
                                        
                                        
                                    }else{
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(.white)
                                            .frame(width: 50, height: 50)
                                            .overlay {
                                                    Text("\(diceNumbersArray[index])")
                                                    .foregroundColor(.black)
                                            }
                                            .rotation3DEffect(
                                                           .degrees(rotation),
                                                           axis: (x: 0.0, y: 1.0, z: 0.0)
                                                       )
                                            .padding()
                                            
                                    }
                                }
                                
                                
                                
                                
                            }
                            .padding()
                            .scaledToFill()
                        }
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal,20)
                    
                            
                        Button{
                            isChanging = false
                            total = 0
                            loadRolls()
                            roll.startTimer()
                            save()
                            
                            withAnimation(Animation.linear(duration: 1)) {
                                   rotation += 360
                               }
                           
                        }label:{
                            Text("Roll")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .frame(width:350,height:100)
                                .background(.gray)
                                .clipShape(Capsule())
                                
                        }
                       
                     
                        
                    }
                    .onChange(of: rollsArray){_ in
                        save()
                    }
                     
                }
                .navigationTitle("RollDice")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                  
                    self.roll = Roll(diceNumberArray: self.$diceNumbersArray,rollsArray: self.$rollsArray, diceType: self.$diceType,total:self.$total)
                }
                .onChange(of: diceCount){newValue in
                    diceNumbersArray = Array(repeating: 1, count: newValue)
                }
                
                .onChange(of: diceType){newValue in
                    diceType = newValue
                }
                .toolbar{
                    ToolbarItem(placement:.navigationBarTrailing){
                        Button{
                            showSettings = true
                            
                        }label: {
                            Image(systemName: "gearshape.2.fill")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                    }
                    ToolbarItem(placement:.navigationBarLeading){
                        Button{
                            showHistory = true
                            
                        }label: {
                            Image(systemName: "arrow.down.app.fill")
                                .font(.largeTitle)
                            
                        }
                    }
                }
                .sheet(isPresented: $showHistory){
                    Story()
                        
                }
                .sheet(isPresented: $showSettings){
                    SettingsView(diceType: $diceType, diceCount: $diceCount)
                        .preferredColorScheme(.dark)
                        
                }
                
                
            }
           
    }
    func loadRolls(){
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: "roll"){
            if let decoded = try? decoder.decode([Dice].self, from: data){
                rollsArray = decoded
            }
        }
    }
    func save(){
           let encoder = JSONEncoder()
           if let encoded = try? encoder.encode(rollsArray){
               UserDefaults.standard.set(encoded, forKey: "roll")
           }
       }
    func calculateTotal(for dice:[Int]) -> Int{
        var total = 0
        for number in dice{
            total += number
        }
        return total
        
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
    @Binding var diceNumberArray:[Int]
    @Binding var rollsArray:[Dice]
    @Binding var diceType:Int
    @Binding var total:Int
    
    private var rollCount: Int = 0
        private let maxRollCount: Int = 6
    
    init(diceNumberArray: Binding<[Int]>,rollsArray: Binding<[Dice]>,diceType: Binding<Int>,total: Binding<Int>) {
           self._diceNumberArray = diceNumberArray
        self._diceType = diceType
        self._total = total
        self._rollsArray = rollsArray
        
        
       }
       
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ [self]timer in
            withAnimation {
                
                for  i in 0..<diceNumberArray.count{
               
                    if self.rollCount < self.maxRollCount {
                        diceNumberArray[i] = Int.random(in: 1...diceType)
                       
                        self.rollCount += 1
                    } else {
                        self.total += diceNumberArray[i]
                        self.stop()
                       
                        
                        
                    }
                   
                }
                let newroll = Dice(numbersArray:  diceNumberArray)
                self.rollsArray.append(newroll)
               
            }
            
        }
    }
    func stop(){
        timer?.invalidate()
        timer = nil
        self.rollCount = 0
        
    }
   
   
}
