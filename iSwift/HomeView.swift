//
//  HomeView.swift
//  iSwift
//
//  Created by Miguel Teixeira on 12/11/2020.
//

import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        
        if viewModel.developers.isEmpty {
            ProgressView()
        } else {
            List {
                ForEach(viewModel.developers) { dev in
                    Text(dev.dev!)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
