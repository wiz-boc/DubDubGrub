//
//  DDGAnnotation.swift
//  DubDubGrub
//
//  Created by wizz on 7/17/23.
//

import SwiftUI

struct DDGAnnotation: View {
    
    var number: Int
    var location: DDGLocation
    var body: some View {
        VStack{
            ZStack{
                MapBalloon()
                    .fill(Color.brandPrimary.gradient)
                    .frame(width: 100, height: 70)
                    //.foregroundColor(.brandPrimary)
                    
                Image(uiImage: location.squareImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .offset(y: -11)
                
                if number > 0 {
                    Text("\(min(number,99))")
                        .font(.system(size: 11, weight: .bold))
                        .frame(width: 26, height: 18)
                        .background(Color.grubRed)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .offset(x: 20, y: -28)
                }
            }
            
            Text(location.name).font(.caption).fontWeight(.semibold)
        }
        .accessibilityLabel(Text("Map Pin \(location.name) \(number) checked in."))
    }
}

struct DDGAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        DDGAnnotation(number: 2, location: DDGLocation(record: MockData.location))
    }
}
