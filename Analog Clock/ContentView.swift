//
//  ContentView.swift
//  Analog Clock
//
//  Created by Derek Chan on 2020/9/9.
//

import SwiftUI

struct ContentView: View {
    @State var isDark: Bool = false
    var body: some View {
        Home(isDark: $isDark)
            .navigationBarHidden(true)
            .preferredColorScheme(isDark ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @State var currentTime = Time(sec: 0, min: 0, hour: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    @Binding var isDark: Bool
    var width = UIScreen.main.bounds.width
        
    var body: some View {
        VStack {
            HStack {
                Text("Analog Clock")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Spacer()
                
                Button(action: {
                        isDark.toggle()
                    
                }, label: {
                    Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
                        .font(.system(size: 22))
                        .foregroundColor(isDark ? .black : .white)
                        .padding()
                        .background(Color.primary)
                        .clipShape(Circle())
                })
            }
            .padding()
            
            Spacer()
            
            ZStack {// Dial
                Circle()
                    .fill(Color("Color"))
                
                // Seconds And Min dots...
                ForEach(0..<60, id: \.self){ i in
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: (i % 5) == 0 ? 15 : 5)// 60/12 = 5
                        .offset(y: (width - 110) / 2)
                        .rotationEffect(.init(degrees: Double(i) * 6))
                }
                
                //Seconds
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 2, height: (width - 180) / 2)
                    .offset(y: -(width - 180) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.sec) * 6))
                
                //Minutes
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: (width - 150) / 2)
                    .offset(y: -(width - 200) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.min) * 6))
                
                //Hours
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5, height: (width - 240) / 2)
                    .offset(y: -(width - 240) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.hour) * 30))
                
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15, height: 15)
            }
            .frame(width: width - 80, height: width - 80)
            
            
            
            Spacer()
        }
        .onAppear(perform: {
            let calender = Calendar.current
            
            let sec = calender.component(.second, from: Date())
            let min = calender.component(.minute, from: Date())
            let hour = calender.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)){
                currentTime = Time(sec: sec, min: min, hour: hour)
            }
        })
        .onReceive(receiver){ _ in
            let calender = Calendar.current
            
            let sec = calender.component(.second, from: Date())
            let min = calender.component(.minute, from: Date())
            let hour = calender.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)){
                currentTime = Time(sec: sec, min: min, hour: hour)
            }
        }
    }
}
