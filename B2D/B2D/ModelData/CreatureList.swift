//
//  SwiftUIView.swift
//  B2D
//
//  Created by  b2d on 1/15/24.
//

import SwiftUI

struct CreatureList: View{
    @Environment(ModelData.self) var modelData
    var egg:EggImg
    
    var body: some View {
        egg.image.resizable().frame(width:60, height: 80)
    }
}

#Preview {
    let eggs = ModelData().eggs
    return
    CreatureList(egg:eggs[0]).environment(ModelData())
}
