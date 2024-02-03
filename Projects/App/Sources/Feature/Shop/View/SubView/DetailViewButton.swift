//
//  DetailViewButton.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct DetailViewButton: View {
    
    var body: some View {
        HStack{
            
        }
    }
    
    func makeButton(image: String, buttonName: String) -> some View {
        return
            HStack{
                Image(systemName: image)
                Text(buttonName)
            }.padding()
    }
}

#Preview {
    DetailViewButton()
}
