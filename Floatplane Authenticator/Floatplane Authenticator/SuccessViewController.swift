//
//  SuccessViewController.swift
//  Floatplane Authenticator
//
//  Created by Jonas Franz on 15.11.17.
//  Copyright © 2017 Jonas Franz. All rights reserved.
//

import UIKit
import Voucher
import LocalAuthentication
import CookieStore

class SuccessViewController: UIViewController, CookieStore {
    var authenticationCookies: [HTTPCookie] = [] {
        didSet {
            print(String(data: authenticationData!, encoding: .utf8)!)
        }
    }
    var server: VoucherServer?

    override func viewDidLoad() {
        super.viewDidLoad()
        startVoucherServer()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressLogout(_ sender: UIButton) {
    }

    func startVoucherServer() {
        let uniqueId = "FloatplaneAuthenticator"
        self.server = VoucherServer(uniqueSharedId: uniqueId)

        self.server!.startAdvertising { (displayName, responseHandler) -> Void in
            self.authenticateViaAlert(displayName: displayName, responseHandler: responseHandler)
        }
    }

    private func authenticateViaAlert(displayName: String, responseHandler: @escaping (Optional<Data>, Optional<Error>) -> ()) {
        let alertController = UIAlertController(title: "Allow Auth?", message: "Allow \"\(displayName)\" access to Floatplane?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: { action in
            responseHandler(nil, nil)
        }))

        alertController.addAction(UIAlertAction(title: "Allow", style: .default, handler: { action in
            let context = LAContext()
            var error:NSError?
            guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
                responseHandler(self.authenticationData, nil)
                return
            }
            context.evaluatePolicy(.deviceOwnerAuthentication,
                    localizedReason: "Allow \"\(displayName)\" access to Floatplane?",
                    reply: { [unowned self] (success, error) -> Void in

                        if (success) {
                            // Fingerprint recognized
                            // Send cookies
                            responseHandler(self.authenticationData, error)
                        } else {
                            responseHandler(nil, error)
                        }
                    }
            )
        }))

        self.present(alertController, animated: true, completion: nil)
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
