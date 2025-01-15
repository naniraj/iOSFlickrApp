//
//  FlickrBaseView.swift
//  CVSAssignment
//
//  Created by Rajesh Bandarupalli on 1/15/25.
//

import SwiftUI

struct FlickrBaseView: View {
    @StateObject private var viewModel = FlickrBaseViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                switch viewModel.apiState {
                    case .idle:
                    Text(AppConstants.idleMessage)
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding()
                    case .loading:
                        ProgressView()
                            .scaleEffect(2)
                            .padding(.top, 20)

                    case .success:
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                                ForEach(viewModel.items) { item in
                                    FlickrImageCardView(flickrItem: item)
                                        .frame(width: 100, height: 100)
                                }
                            }
                        }
                    case .empty:
                    Text(AppConstants.noResultsFound)
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding()
                    case .error(let message):
                    Text("\(AppConstants.error) \(message)")
                            .foregroundColor(.red)
                            .font(.headline)
                            .padding()
                }
                Spacer()
            }
            .searchable(text: $viewModel.searchText, prompt: "Search by tags")
            .navigationBarTitle(AppConstants.flickrBaseViewTitle, displayMode: .inline)
        }
    }
}

#Preview {
    FlickrBaseView()
}
