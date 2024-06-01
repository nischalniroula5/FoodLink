import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    var primaryGreen = Color(red: 117 / 255.0, green: 185 / 255.0, blue: 110 / 255.0)
    var primaryOrange = Color(red: 254 / 255.0, green: 109 / 255.0, blue: 64 / 255.0)
    var primaryDarkBlue = Color(red: 24 / 255.0, green: 30 / 255.0, blue: 42 / 255.0)
    
    @State private var showingHomeScreen = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("background") // Make sure to add the correct image in your assets
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                // Contents
                VStack {
                    Spacer()
                    
                    HStack {
                        Text("FOOD FOR EVERY ONE")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(primaryGreen)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                        
                        Spacer()
                    }

                    Spacer()

                    // Sign in with Google
                    Button(action: signInWithGoogle) {
                        HStack {
                            Text("Sign In With Google")
                                .fontWeight(.semibold)
                                .padding(.leading, 20)
                                .font(.system(size: 24))
                            Spacer()
                            Image("googlelogo")
                                .padding(.trailing, 20)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .padding(.vertical, 10)
                        .foregroundColor(primaryDarkBlue)
                        .background(primaryOrange)
                        .cornerRadius(7)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 80)

                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showingHomeScreen) {
                MainView()
            }
        }
    }

    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        let presentingViewController = self.getRootViewController()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                print("Error signing in with Google: \(error.localizedDescription)")
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            // Use the credential to authenticate with Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign in error: \(error.localizedDescription)")
                    return
                }
                
                // User is signed in to Firebase with Google.
                print("User signed in with Google: \(authResult?.user.uid ?? "")")
                self.showingHomeScreen = true
            }
        }
    }
}

extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return UIViewController()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return UIViewController()
        }

        return root
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
