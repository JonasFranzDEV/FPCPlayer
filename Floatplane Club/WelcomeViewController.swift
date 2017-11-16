//
//  WelcomeViewController.swift
//  Floatplane Club
//
//  Created by Jonas Franz on 14.11.17.
//  Copyright © 2017 Jonas Franz. All rights reserved.
//

import UIKit
import Voucher
import CookieStore

class WelcomeViewController: UIViewController, CookieStore {
    var authenticationCookies: [HTTPCookie] = []

    let voucher = VoucherClient(uniqueSharedId: "FloatplaneAuthenticator")
    var authAlert: UIAlertController? = nil

    func startVoucher() {
        self.voucher.startSearching { [unowned self] authData, displayName, error in

            // (authData is of type NSData)
            if authData != nil {
                // User granted permission on iOS app!
                print(String(data: authData!, encoding: .utf8)!)
                let cookies = self.convertToCookies(from: authData)
                if cookies.count != 0 {
                    self.authenticationCookies = cookies
                    for cookie in self.authenticationCookies {
                        print(cookie.name)
                        if cookie.name == "ips4_login_key" {
                            DispatchQueue.main.async {
                                if self.authAlert != nil && !self.authAlert!.isBeingDismissed {
                                    self.authAlert!.dismiss(animated: false, completion: {
                                        print("hey")
                                    })
                                    self.showSuccessAlert(becauseOf: displayName ?? "Unknown Device")
                                } else {
                                    self.showSuccessAlert(becauseOf: displayName ?? "Unknown Device")
                                }
                            }

                            break
                        }
                    }
                }
            } else if error != nil {
                print(error!)
            } else if displayName != nil {
                DispatchQueue.main.async {
                    self.authAlert?.message! += "\n🚫 \"\(displayName!)\" rejected access"
                }
            }
        }
    }

    func showSuccessAlert(becauseOf displayName: String) {
        let alert = UIAlertController(title: "Received credentials!", message: "Your login cookies were transfered from \"\(displayName)\".", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue & Login", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.authenticationCookies = []
            self.showAuthAlert()
        }))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func useFloatplaneAuthenticator(_ sender: UIButton) {
        showAuthAlert()
    }

    private func showAuthAlert() {
        authAlert = UIAlertController(title: "Authenticate with the Floatplane Authenticator", message: "Please start the Floatplane Authenticator App at your iOS device and follow the steps. \n\n", preferredStyle: .alert)
        authAlert!.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.voucher.stop()
        }))

        self.present(authAlert!, animated: true) {
            self.startVoucher()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
