//
//  DismissView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 8/6/22.
//

import SwiftUI

struct DismissView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                EmptyView()
                Spacer()
            }
            Spacer()
        }.background(Color.dismissColor)
    }
}

struct DismissView_Previews: PreviewProvider {
    static var previews: some View {
        DismissView()
    }
}
