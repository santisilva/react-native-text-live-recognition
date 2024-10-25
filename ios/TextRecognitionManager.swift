import Vision
import UIKit

@objc(TextRecognitionManager)
class TextRecognitionManager: NSObject {
  
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return false
  }
  
  @objc(recognizeText:resolver:rejecter:)
  func recognizeText(_ imageBase64: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
    guard let imageData = Data(base64Encoded: imageBase64),
          let image = UIImage(data: imageData),
          let cgImage = image.cgImage else {
      rejecter("ERROR", "Invalid image data", nil)
      return
    }
    
    let request = VNRecognizeTextRequest { (request, error) in
      guard let observations = request.results as? [VNRecognizedTextObservation] else {
        rejecter("ERROR", "Failed to process image", error)
        return
      }
      
      let recognizedStrings = observations.compactMap { observation in
        return observation.topCandidates(1).first?.string
      }
      
      resolver(recognizedStrings)
    }
    
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    do {
      try handler.perform([request])
    } catch {
      rejecter("ERROR", "Failed to perform recognition", error)
    }
  }
}

