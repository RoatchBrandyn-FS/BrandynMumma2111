//
//  TabbedViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/12/21.
//

import UIKit
import Firebase

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var postsTV: UITableView!
    
    //MARK: Variables
    
    //arrays
    var allRoomPosts = [Post]()
    var sortedPosts = [Post]()
    
    //room
    var selectedRoom: Room!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tabbar = tabBarController as! TabBarController
        
        selectedRoom = tabbar.selectedRoom
        
        postsTV.delegate = self
        postsTV.dataSource = self
        
        postsTV.layer.cornerRadius = 20
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ReadPostsDoc()
        
    }
    
    //MARK: Methods
    func ReadPostsDoc() {
        //clear lists
        allRoomPosts.removeAll()
        sortedPosts.removeAll()
        
        //set database
        let database = Firestore.firestore()
        
        //read document for posts
        database.collection("Posts").getDocuments { (snapshot, error) in
            
            if error == nil {
                
                //Get posts and orgianize based on selected room
                DispatchQueue.main.async {
                    
                    snapshot?.documents.forEach({ (post) in
                        
                        guard let creator = post["creator"] as? String, let roomName = post["roomName"] as? String
                        else {return}
                        
                        if creator == self.selectedRoom.creator && roomName == self.selectedRoom.name {
                            
                            guard let activity = post["activity"] as? String, let petName = post["petName"] as? String, let petType = post["petType"] as? String, let tStamp = post["tStamp"] as? String, let user = post["user"] as? String
                            else {return}
                            
                            self.allRoomPosts.append(Post(activity: activity, petName: petName, petType: petType, tStamp: tStamp, user: user, creator: creator, roomName: roomName, postID: post.documentID))
                            
                        }
                        
                        self.sortedPosts = self.allRoomPosts.sorted(by: {$0.tStamp.compare($1.tStamp) == .orderedDescending})
                        
                        
                        
                    })
                    
                    self.postsTV.reloadData()
                    
                }
                
                
                
            }
            else {
                print("Error occured loading firebase - All Posts load")
            }
            
        }
        
        
    }
    
    
    //MARK: Table View Callbacks
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set reuse id
        let cell = postsTV.dequeueReusableCell(withIdentifier: "post_cell_01", for: indexPath)
        
        //configure cells
        let post = sortedPosts[indexPath.row]
        
        cell.textLabel?.text = post.postString
        cell.detailTextLabel?.text = post.tStamp.description
        //cell.imageView?.image =
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        switch post.petType {
        
        case "Dog":
            cell.imageView?.image = UIImage.init(named: "dogIcon")
        case "Cat":
            cell.imageView?.image = UIImage.init(named: "catIcon")
        case "Fish":
            cell.imageView?.image = UIImage.init(named: "fishIcon")
        default:
            print("Error loading image - Pet Profile Cells")
        
        }
        
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Pet Activities"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
