import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?   
    var location: String?
    var profileImageUrl: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        
        self.location = dictionary["location"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
