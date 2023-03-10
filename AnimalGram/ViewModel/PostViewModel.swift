//
//  PostViewModel.swift
//  AnimalGram
//
//  Created by Zheng yu hsin on 2023/2/27.
//

import Foundation
import FirebaseFirestore
import SwiftUI

private let store = Firestore.firestore()

class PostViewModel: ObservableObject {
    
    private var postCollection = store.collection(K.FireStore.Post.collectionName)
    private var reportCollection = store.collection(K.FireStore.Report.collectionName)
    
    enum PostConfirmationOption {
        case general,reporting
    }
    
    
    @Published var postImage:UIImage  = UIImage(named: "dog1")!
    @Published var animateLike: Bool = false
    @Published var showConfirmation: Bool  = false
    @Published var dialogType: PostConfirmationOption = .general
    
    @Published var isLoading: Bool = false
    
    //MARK: - Error Properties
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    //MARK: - Handle Error
    func handleError(_ error: Error, msg: String?){
        alertMessage = msg ?? error.localizedDescription
        showAlert.toggle()
    }
    
    func handleSuccess(_ msg: String) {
        alertMessage = msg
        showAlert.toggle()
    }
    
    
    //MARK: - PostView's methods
    
    func likePost(post:Post, postID: String, userID: String){
        //Update animation
        self.animateLike = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            animateLike = false
        }
        
        //Update db data
        let increment: Int64 = 1
        let data: [String: Any] = [
            K.FireStore.Post.likeCountField : FieldValue.increment(increment) ,
            K.FireStore.Post.likeByField : FieldValue.arrayUnion([userID])
            //FiledValue -> Firebase's method
            //union -> pass in an arr to cur arr
        ]
        
        postCollection.document(postID).updateData(data) {
            error in
            if let error = error {
                self.handleError(error, msg: nil)
                return
            }
        }
    }
    
    func unlikePost(post: Post, postID: String, userID: String) {
        
        //Update db data
        let increment: Int64 = -1
        let data: [String: Any] = [
            K.FireStore.Post.likeCountField : FieldValue.increment(increment) ,
            K.FireStore.Post.likeByField : FieldValue.arrayRemove([userID])
           
        ]
        
        postCollection.document(postID).updateData(data)
    }
    
    @MainActor
    func reportPost(reason: String, postID: String) async {
        self.isLoading = true
        
        let data: [String : Any] = [
            K.FireStore.Report.contentField : reason,
            K.FireStore.Report.postIDField : postID,
            K.FireStore.Report.createdAtField : FieldValue.serverTimestamp()
        ]
        
        do {
            try await reportCollection.addDocument(data: data)
            
            self.dialogType = .general
            
            self.isLoading = false
            self.handleSuccess("Thanks for reporting this post. We will review it shortly and take the appropriate action!")

        }catch {
            self.isLoading = false
            self.handleError(error, msg: "Error! There was an error uploading the report. Please restart the app and try again.")
        }
    }
   
    func sharePost(_ post: Post) {
        let defaultText = "Just checking in at \(post.displayName)'s post"
        
        //let image = post.postImage
        let image = Image("dog1")
        let link = URL(string: "https://www.youtube.com/watch?v=x5ZeAfz4G3s&list=RDx5ZeAfz4G3s&start_radio=1")!
        
        let activityViewController = UIActivityViewController(activityItems:[defaultText,image,link], applicationActivities: nil)
        
        //get the background view controller
        //grabbing the first key window that is found in the whole application,
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        guard let firstWindow = firstScene.windows.first else {
            return
        }

        let viewController = firstWindow.rootViewController
        
        viewController?.present(activityViewController, animated: true, completion: nil)
    }

    func createPost(with caption: String,images: [UIImage],userID: String, imageURL: String ,userName: String, email: String) {
        
        self.isLoading = true
        
        let postID = generatePostIDForCreatingPost()
        
        let group = DispatchGroup()
        
        var imageURLs: [String] = [String]()
        
        for image in images {
            print(image,"this is image(single)")
            group.enter()
            
            ImageManager.instance.uploadImageAndGetURL(type: "post", id: postID, image: image) { [self] url, error in
                if let error = error {
                    self.handleError(error, msg: nil)
                }
                
                imageURLs.append(url!)
                group.leave()
            }
        }
        group.notify(queue: .main) { [self] in
            print(imageURLs,"this is imageUrl")
            let postData: [String: Any] = [
                K.FireStore.Post.postIDField: postID,
                K.FireStore.Post.userIDField: userID,
                K.FireStore.Post.emailField: email,
                K.FireStore.Post.displayNameField: userName,
                K.FireStore.Post.postImageURLField: imageURLs,
                K.FireStore.Post.userImageURLField : imageURL ,
                K.FireStore.Post.captionField: caption,
                K.FireStore.Post.createdAtField: Int(Date().timeIntervalSince1970),
                K.FireStore.Post.likeCountField: 0,
                K.FireStore.Post.likeByField: []
            ]
            
            postCollection.document(postID).setData(postData) { error in
                if let error = error {
                    self.isLoading = false
                    self.handleError(error, msg: nil)
                    return
                } else {
                    self.isLoading = false
                    print("Successfully post!")
                    self.handleSuccess("Successfully post!")
                }
            }
        }
                
               
    }
        
    @MainActor
    func deletePost(_ postID: String) async  {
        do {
            try await postCollection.document(postID).delete()

        } catch {
            self.handleError(error, msg: nil)
        }
    }
    
    //MARK: - Utility method
    func generatePostIDForCreatingPost() -> String {
        return postCollection.document().documentID
    }
    
    
    
}
