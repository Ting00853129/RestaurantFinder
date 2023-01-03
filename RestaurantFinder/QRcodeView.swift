//
//  QRcodeView.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2023/1/3.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRcodeView: View {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    let url: String
    var body: some View {
        Image(uiImage: generateQRcodeImage(url: url))
            .interpolation(.none )
            .resizable()
            .frame(width: 50,height: 50)
    }
    
    func generateQRcodeImage(url : String) -> UIImage {
        let data = Data(url.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        
        return UIImage(systemName: "xmark") ?? UIImage()
    }
}
