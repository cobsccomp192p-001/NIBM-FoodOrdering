
import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var MobileTextField: UITextField!
    
    let db = Firestore.firestore()
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text{
        
            Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
            if let e=error
            {
                print(e)
            }
            else
            {
                if let Mobile = MobileTextField.text,let currUser = Auth.auth().currentUser?.uid {
                    
                    db.collection(K.fire.userCollection).addDocument(data: [
                        K.fire.uid: currUser,
                        "mobile": Mobile
                    
                    ]) { (error) in
                        if let e = error{
                            print("Failed o save data \(e)")
                        }
                        else{
                            print("Saved successfully")
                        }
                    }
                    
                }
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
          
            }
        }
        
    }
    
}
