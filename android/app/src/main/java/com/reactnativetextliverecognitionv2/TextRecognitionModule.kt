package com.reactnativetextliverecognitionv2

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import com.facebook.react.bridge.*
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions

class TextRecognitionModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName() = "TextRecognitionModule"

    @ReactMethod
    fun recognizeText(imageBase64: String, promise: Promise) {
        try {
            val decodedString = Base64.decode(imageBase64, Base64.DEFAULT)
            val bitmap = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.size)
            val image = InputImage.fromBitmap(bitmap, 0)

            val recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)
            recognizer.process(image)
                .addOnSuccessListener { visionText ->
                    val recognizedText = visionText.text
                    promise.resolve(recognizedText)
                }
                .addOnFailureListener { e ->
                    promise.reject("TEXT_RECOGNITION_ERROR", e.message)
                }
        } catch (e: Exception) {
            promise.reject("IMAGE_PROCESSING_ERROR", e.message)
        }
    }
}

