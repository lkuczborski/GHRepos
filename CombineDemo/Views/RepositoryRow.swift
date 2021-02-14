//
//  RepositoryView.swift
//  CombineDemo
//
//  Created by Łukasz Kuczborski on 14/02/2021.
//

import SwiftUI

struct RepositoryRow: View {
    let viewModel: RepositoryViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.name)
                .titleBold()
            if let description = viewModel.description {
                Text(description)
                    .description()
                    .padding()
            }
        }
    }
}

struct RepositoryView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryRow(viewModel: RepositoryViewModel.preview)
    }
}
