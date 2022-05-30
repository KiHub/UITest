//
//  ContentView.swift
//  UITest
//
//  Created by  Mr.Ki on 29.05.2022.
//

import SwiftUI
import AVFoundation

class PlayerViewModel: ObservableObject {
    @Published public var maxDuration = 0.0
    private var player: AVAudioPlayer?
    
    public func play() {
        playSong(name: "Alarm 2")
        player?.play()
    }
    
    public func stop() {
        player?.stop()
    }
    
    public func setTime(value: Float) {
        guard let time = TimeInterval(exactly: value)
        else {return}
        player?.currentTime = time
        player?.play()
    }
    
    private func playSong(name: String) {
        guard let audioPath = Bundle.main.path(forResource: name, ofType: "mp3")
        else {return}
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            maxDuration = player?.duration ?? 0.0
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
}

struct ContentView: View {
    @State var isOne = false
    @State var section = 1
    @State var section2 = 2
    @State var onToggle = false
    
    @State private var progress: Float = 0
    @ObservedObject var viewModel = PlayerViewModel()
    
    var settingsTime = ["5 min", "10 min", "15 min"]
    
    var body: some View {
        // showAlert()
        VStack {
            ZStack {
                HStack {
                    VStack {
                        Text("one")
                        Spacer().frame( height: 50)
                        Text("two")
                    }.padding()
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 10).fill(Color.yellow)
                    .offset(x: isOne ? 100 : 0)
                RoundedRectangle(cornerRadius: 10).fill(Color.yellow)
                    .offset(x: isOne ? 100 : 0)
                Text("Hello").offset(x: isOne ? 100 : 0)
            }
            Text("Time - \(settingsTime[section])").padding()
            NavigationView {
                Form {
                    Picker(selection: $section) {
                        ForEach(0..<settingsTime.count) {
                            Text(self.settingsTime[$0])
                        }
                    } label: {
                        Text("Time")
                    }
                        Toggle(isOn: $onToggle) {
                        Text("Avia").foregroundColor(onToggle ? Color.orange : Color.pink)
                                    
                        }
                   
                    Picker(selection: $section2) {
                        ForEach(0..<50) {
                            Text("\($0)")
                        }
                    } label: {
                        Text("Numbers")
                    }

                           

                }.navigationBarTitle("Settings")
            }
            
            
          //  Slider(value: $progress, in: 0...100).padding().accentColor(Color.purple)
            
            Slider(value: Binding(get: {
                Double(self.progress)
            }, set: { newValue in
                print(newValue)
                progress = Float(newValue)
                viewModel.setTime(value: Float(newValue))
            }), in: 0...viewModel.maxDuration).padding()
            
            HStack {
                Button {
                    self.viewModel.play()
                    print("Start")
                } label: {
                    Text("Start")
                        .foregroundColor(Color.white)
                }.frame(width: 100, height: 50)
                    .background(Color.orange)
                    .cornerRadius(20)
                
                Button {
                    self.viewModel.stop()
                    print("Stop")
                } label: {
                    Text("Stop")
                        .foregroundColor(Color.white)
                }.frame(width: 100, height: 50)
                    .background(Color.orange)
                    .cornerRadius(20)

            }
            
            
            
            //  Toggle(isOn: <#T##Binding<Bool>#>, label: <#T##() -> _#>)
            Toggle(isOn: $isOne, label: {
                Text("Show settings")
            }).padding()
        }.animation(.spring(response: 0.5, dampingFraction: 0.4, blendDuration: 0.2))
        
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
