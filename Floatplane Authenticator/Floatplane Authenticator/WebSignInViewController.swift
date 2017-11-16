//
//  WebSignInViewController.swift
//  Floatplane Authenticator
//
//  Created by Jonas Franz on 15.11.17.
//  Copyright © 2017 Jonas Franz. All rights reserved.
//

import UIKit
import WebKit
import CookieStore

class WebSignInViewController: UIViewController, WKNavigationDelegate, CookieStore {


    @IBOutlet weak var webView: WKWebView!

    var authenticationCookies: [HTTPCookie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Loading LTT Login page
        // https://linustechtips.com/main/login
        self.webView.navigationDelegate = self
        self.webView.load(URLRequest(url: URL(string: "https://linustechtips.com/main/login")!))
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
            var isSuccessful: Bool = false
            self.authenticationCookies = []
            for cookie in cookies {
                if cookie.isSecure && cookie.name.starts(with: "ips4_") {
                    if cookie.name == "ips4_member_id" {
                        isSuccessful = true
                    }
                    print(cookie)
                    self.authenticationCookies.append(cookie)
                }
            }
            if isSuccessful {
                self.performSegue(withIdentifier: "redirectToSuccess", sender: webView)
            }
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var cookieStore = segue.destination as? CookieStore
        if cookieStore == nil && segue.destination is UINavigationController {
            let destinationNavigationController = segue.destination as! UINavigationController
            cookieStore = destinationNavigationController.topViewController as? CookieStore
        }
        cookieStore?.authenticationCookies = self.authenticationCookies

    }


}
