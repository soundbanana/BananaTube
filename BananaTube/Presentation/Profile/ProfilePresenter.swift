//
//  ProfilePresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 27.04.2023.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfilePresenter {
    weak var view: ProfileViewController?
    var navigationController: UINavigationController?

    func signIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: view!) { result, error in
            guard error == nil else {
                print("Error because \(String(describing: error?.localizedDescription))")
                return
            }

            guard let user = result?.user,
                let idToken = user.idToken?.tokenString
                else {
                print("Error because \(String(describing: error?.localizedDescription))")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, _ in
                print(result?.user.email ?? "No user found")
            }
            self.view?.dismiss(animated: true)
        }
    }

    func signOut() {
        let firebaseAuth = Auth.auth()

        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }

        self.view?.dismiss(animated: true)
    }

    func configureData() {
        guard let currentUser = Auth.auth().currentUser else {
            view?.setupSignInView()
            return
        }
        view?.setupProfileView()

        let title = currentUser.displayName!
        let email = currentUser.email!

        // Just for better quality
        GIDSignIn.sharedInstance.restorePreviousSignIn { [self] user, error in
            guard error == nil || user == nil else { return }
            guard let imageURL = user?.profile?.imageURL(withDimension: 0) else { return }
            view?.show(title: title, email: email, imageURL: imageURL)
        }
    }
}
