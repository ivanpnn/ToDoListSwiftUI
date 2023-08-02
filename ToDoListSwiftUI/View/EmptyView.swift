//
//  EmptyView.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 01/08/23.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        VStack {
            Image(systemName: "eyes")
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            Text("You don't have any tasks yet.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20.0)
                .foregroundColor(.gray)
                .font(.subheadline)
            Text("Let's create it by tap + button")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20.0)
                .foregroundColor(.gray)
                .font(.subheadline)
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
