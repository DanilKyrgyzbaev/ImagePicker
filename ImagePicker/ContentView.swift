//
//  ContentView.swift
//  ImagePicker
//
//  Created by Macbook on 20/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false // Добавляем переменную для отображения ImagePicker

    
    var body: some View {
        VStack {
            Button("Выбрать фото") {
                self.showImagePicker = true
            }
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
                Button("Преобразовать в массив байтов") {
                    if let image = selectedImage {
                        if let resizedImage = resizeImage(image, targetSize: CGSize(width: 100, height: 100)) {
                            if let imageData = resizedImage.pngData() {
                                var byteArray = [UInt8](repeating: 0, count: imageData.count)
                                (imageData as NSData).getBytes(&byteArray, length: imageData.count)
                                print(byteArray)
                                print("Массив байтов создан успешно")
                            } else {
                                print("Ошибка при создании массива байтов")
                            }
                        }
                    }
                }


            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: self.$selectedImage)
        }
    }
    
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize

        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

#Preview {
    ContentView()
}
