//
//  CustomToastView.swift
//  event-finder
//
//  Created by Indra Kumar on 5/3/23.
//

import SwiftUI

struct CustomToastView: View {
   @State var message: String
       var dismissAfter: TimeInterval
       
       @State private var isShowing = true
       
       var body: some View {
           VStack {
               Text(message)
                   .foregroundColor(.black)
                   .padding(15)
                   .background(Color.gray.opacity(0.6))
                   .cornerRadius(10)
           }
           .padding()
           .opacity(isShowing ? 1 : 0)
           .animation(.easeInOut(duration: 0.3))
           .onAppear {
               DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
                   isShowing = false
               }
           }
       }
}

//struct CustomToastView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomToastView()
//    }
//}
