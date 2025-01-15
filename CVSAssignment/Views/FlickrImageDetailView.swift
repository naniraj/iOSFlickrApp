//
//  FlickrImageDetailView.swift
//  CVSAssignment
//
//  Created by Rajesh Bandarupalli on 1/15/25.
//

import SwiftUI

struct FlickrImageDetailView: View {
    let flickrItem: FlickrItem
    var flickrImage: Image? = nil
    @State private var isAnimating = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if flickrImage != nil {
                flickrImage
                    .frame(maxWidth: .infinity)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                            self.isAnimating = true
                        }
                    }
            }
            //                .accessibilityLabel(Text(flickrItem.title ?? "Image"))
            //                .accessibilityHint(Text("Double tap to view full image"))
            
            Text(flickrItem.title ?? "")
                .font(.headline)
                .padding(.horizontal)
            
            if let description = flickrItem.description {
                descriptionView(with: description)
            }
            
            Text("\(AppConstants.author) \(flickrItem.author ?? "")")
                .font(.subheadline)
                .padding(.horizontal)
            
            Text("\(AppConstants.publishedDate) \(flickrItem.published?.formattedPublishedDate ?? "")")
                .font(.subheadline)
                .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarTitle(AppConstants.flickrDetailViewTitle, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    shareImage()
                }) {
                    Image(systemName: "square.and.arrow.up") // Share icon
                }
            }
        }
    }
    
    private func shareImage() {
            let items = [
                flickrItem.title,
                flickrItem.description,
                "Image URL: \(flickrItem.media?.m ?? "")",
                "Author: \(flickrItem.author ?? "")",
                "Published Date: \(flickrItem.published?.formattedPublishedDate ?? "")"
            ]
            
            let activityVC = UIActivityViewController(activityItems: items.compactMap { $0 }, applicationActivities: nil)
            
            // Get the current window scene
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
            }
        }
}

extension FlickrImageDetailView {
    
    @ViewBuilder
    func descriptionView(with text: String) -> some View {
        Text(parseHTML(for: text))
            .font(.subheadline)
            .padding(.horizontal)
            .multilineTextAlignment(.center)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func parseHTML(for text: String) -> String {
        do {
            let data = text.data(using: .utf8)!
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error parsing HTML: \(error.localizedDescription)")
            return ""
        }
    }
}

//#Preview {
//    FlickrImageDetailView()
//}
