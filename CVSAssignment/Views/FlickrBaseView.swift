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
                    textView(with: AppConstants.idleMessage)
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
                    textView(with: AppConstants.noResultsFound)
                case .error(let message):
                    textView(with: "\(AppConstants.error) \(message)", isError: true)
                }
                Spacer()
            }
            .searchable(text: $viewModel.searchText, prompt: AppConstants.searchBarPlaceHolder)
            .navigationBarTitle(AppConstants.flickrBaseViewTitle, displayMode: .inline)
        }
    }
    
    private func textView(with message: String, isError: Bool = false) -> some View {
        return Text(message)
            .foregroundColor(isError ? .red: .gray)
            .font(.headline)
            .padding()
    }
}

#Preview {
    FlickrBaseView()
}
