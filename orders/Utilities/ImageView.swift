//
//  ImageView.swift
//  orders
//
//  Created by Valentina Ungurean on 18.05.2025.
//

import SwiftUI

struct ImageView: View {
    var url: URL
    var maxHeight: CGFloat?
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: maxHeight)
            case .failure:
                Text("Failed to load image")
                    .font(.caption)
            @unknown default:
                EmptyView()
            }
        }
        .padding()
    }
}
