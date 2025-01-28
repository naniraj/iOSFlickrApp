//
//  FlickrImageCardView.swift
//  CVSAssignment
//
//  Created by Rajesh Bandarupalli on 1/15/25.
//

import SwiftUI

struct FlickrImageCardView: View {
    let flickrItem: FlickrItem
    @State private var selectedImage: Image? = nil
    var body: some View {
        Group {
            if let media = flickrItem.media, let url = media.m {
                NavigationLink(destination: FlickrImageDetailView(flickrItem: flickrItem, flickrImage: selectedImage)) {
                    let image = AsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                                .cornerRadius(AppConstants.viewCornerRadius)
                                .onAppear {
                                    self.selectedImage = image
                                }
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .cornerRadius(AppConstants.viewCornerRadius)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    image
                }
                
            } else {
                EmptyView()
            }
        }
    }
}

//#Preview {
//    FlickrImageCardView()
//}
