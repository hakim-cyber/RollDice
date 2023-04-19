//
//  SettingsView.swift
//  RollDice
//
//  Created by aplle on 4/19/23.
//

import SwiftUI

struct SettingsView: View {
    @Binding var diceType:Int
    @Binding var diceCount:Int
    @Environment(\.dismiss) var dismiss
    let dicecounts = Array(1...100)
    let diceTypes = Array(6...100).filter{$0 % 2 == 0}
    var body: some View {
        NavigationView{
           
                Form{
                    Section{
                        Picker("Dice count", selection: $diceCount){
                            ForEach(dicecounts,id:\.self) { count in
                                Text("\(count)")
                            }
                        }
                        .pickerStyle(.navigationLink)
                        
                        Picker("Dice Type",selection: $diceType){
                            ForEach(diceTypes ,id:\.self){type in
                                Text("\(type) Sided")
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                    
                  
                }
                .scrollContentBackground(.hidden)
                .background(Color.background)
                .listRowSeparatorTint(.blue)
                
                
                
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    Button("Done"){
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .bold()
                   
                }
                
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(diceType: .constant(6), diceCount: Binding<Int>.constant(3))
            
    }
}
