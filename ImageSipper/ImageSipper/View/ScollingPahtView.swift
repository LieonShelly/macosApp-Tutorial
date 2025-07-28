//
//  ScollingPahtView.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/27.
//

import SwiftUI

struct ScollingPahtView: View {
    @Binding var url: URL?

    var body: some View {
        ScrollView(.horizontal) {
            if url != nil {
                PathView(url: url)
                    .frame(height: 40)
                    .padding(.horizontal)
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(5)
        .frame(height: 30)
        .frame(maxWidth: .infinity)
    }
}
