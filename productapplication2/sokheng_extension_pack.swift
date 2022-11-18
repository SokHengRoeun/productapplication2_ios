// Written by Roeun SokHeng
// Proudly written in Swift
// Created : 21-Oct-2022
// Updated : 24-Oct-2022
// Updated : 27-Oct-2022 11:16AM(UTC+7)
// Updated : 15-Nov-2022 10:35AM(UTC+7)
//
// swiftlint:disable function_parameter_count

import UIKit
import CryptoKit
import SwiftyRSA

extension UIViewController {
    func showAlertBox(title: String,
                      message: String,
                      buttonAction: ((UIAlertAction) -> Void)?,
                      buttonText: String,
                      buttonStyle: UIAlertAction.Style
    ) {
        let alertBox = UIAlertController(title: title,
                                         message: message,
                                         preferredStyle: .alert
        )
        let alertActions = UIAlertAction(title: buttonText,
                                         style: buttonStyle,
                                         handler: buttonAction
        )
        alertBox.addAction(alertActions)
        DispatchQueue.main.async {
            self.present(alertBox,
                         animated: true,
                         completion: nil
            )
        }
    }
    func showAlertBox(title: String,
                      message: String,
                      firstButtonAction: ((UIAlertAction) -> Void)?,
                      firstButtonText: String,
                      firstButtonStyle: UIAlertAction.Style,
                      secondButtonAction: ((UIAlertAction) -> Void)?,
                      secondButtonText: String,
                      secondButtonStyle: UIAlertAction.Style
    ) {
        let alertBox = UIAlertController(title: title,
                                         message: message,
                                         preferredStyle: .alert
        )
        let yesActions = UIAlertAction(title: firstButtonText,
                                       style: firstButtonStyle,
                                       handler: firstButtonAction
        )
        alertBox.addAction(yesActions)
        let cancelActions = UIAlertAction(title: secondButtonText,
                                          style: secondButtonStyle,
                                          handler: secondButtonAction
        )
        alertBox.addAction(cancelActions)
        DispatchQueue.main.async {
            self.present(alertBox,
                         animated: true,
                         completion: nil
            )
        }
    }
}

class HengBase64Encoding {
    func encryptMessage(yourMessage: String) -> String {
        let encryptedString = yourMessage.data(using: String.Encoding.utf32)!.base64EncodedString()
        return encryptedString
    }
    func decryptMessage(yourMessage: String) -> String {
        let base64Decoded = Data(base64Encoded: yourMessage)!
        let decryptedString = String(data: base64Decoded, encoding: .utf32)
        return decryptedString!
    }
}

// swiftlint:disable force_try
class HengCryptology {
    // Create or pass authendication certificate to another function
    private func requestCertificate() -> (PublicKey, PrivateKey) {
        let fileDirectoryURL = try! FileManager.default.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: true
        )
        // Check if authendication certificate exist, if not create new one
        if FileManager.default.fileExists(atPath: fileDirectoryURL.appending(path: "privateKey.pem").path()) {
            let privateKey = try! PrivateKey(data: Data(contentsOf: fileDirectoryURL.appending(path: "privateKey.pem")))
            let publicKey = try! PublicKey(data: Data(contentsOf: fileDirectoryURL.appending(path: "publicKey.pem")))
            return (publicKey, privateKey)
        } else {
            let genKeyPair = try! SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048)
            let privateKey = genKeyPair.privateKey
            let publicKey = genKeyPair.publicKey
            FileManager.default.createFile(atPath: fileDirectoryURL.appending(path: "privateKey.pem").path(),
                                           contents: try! privateKey.data())
            FileManager.default.createFile(atPath: fileDirectoryURL.appending(path: "publicKey.pem").path(),
                                           contents: try! publicKey.data())
            print("File generated")
            return (publicKey, privateKey)
        }
    }
    // Print the location of the application that we store the certificate
    func printFileLocation() {
        let fileDirectoryURL = try! FileManager.default.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: true)
        print("\n\nFile Location :\n\(fileDirectoryURL)\n")
    }
    // Encrypt Message with Public Key
    func encryptMessage(yourMessage: String) -> String {
        var publicKey = requestCertificate().0
        let str = yourMessage
        let clear = try! ClearMessage(string: str, using: .utf32)
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
        let base64String = encrypted.base64String
        return base64String
    }
    // Decrypt Message back to original form
    func decryptMessage(yourMessage: String) -> String {
        var privateKey = requestCertificate().1
        let encrypted = try! EncryptedMessage(base64Encoded: yourMessage)
        let clear = try! encrypted.decrypted(with: privateKey, padding: .PKCS1)
        let string = try! clear.string(encoding: .utf32)
        return string
    }
}

extension UIView {
    func hasRoundCorner(theCornerRadius: CGFloat) {
        self.layer.cornerRadius = theCornerRadius
    }
    func isMasksToBounds() {
        self.layer.masksToBounds = true
    }
    func sasBorderOutline(outlineColor: CGColor,
                          outlineWidth: CGFloat,
                          cornerRadius: CGFloat
    ) {
        self.layer.borderColor = outlineColor
        self.layer.borderWidth = outlineWidth
        self.layer.cornerRadius = cornerRadius
    }
    func isRound() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    func hasShadow(shadowColor: CGColor,
                   shadowOpacity: Float,
                   shadowOffset: CGSize
    ) {
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
    }
}