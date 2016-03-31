//
//  ViewController.swift
//  testing
//
//  Created by Joao Silva on 31/03/2016.
//  Copyright © 2016 Joao Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var panView: UIView!
    @IBOutlet weak var imagesView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var _panRec: UIPanGestureRecognizer!
    var _panImagesRec: UIPanGestureRecognizer!
    
    var _filterInitialOriginY: CGFloat = 0
    var _filterOpenOriginY: CGFloat = 0
    var _filterInitialHeight: CGFloat = 0
    var _originalImageCenter: CGPoint!
    
    var Users: [User] = [
        User(
            name: "Cool cat",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            image: "cat1.png"
        ),
        User(
            name: "Awesome cat",
            description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.",
            image: "cat2.png"
        ),
        User(
            name: "Lovely cat",
            description: "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful.",
            image: "cat3.jpg"
        ),
        User(
            name: "Mega cat",
            description: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio.",
            image: "cat4.gif"
        )
    ]
    
    var imagePos = 0;
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {   
        super.viewDidLoad()
        
        //Register for touch events
        _panRec = UIPanGestureRecognizer()
        _panRec.addTarget(self, action: #selector(ViewController.draggedPanView(_:)))
        panView.addGestureRecognizer(_panRec)
        
        _panImagesRec = UIPanGestureRecognizer()
        _panImagesRec.addTarget(self, action: #selector(ViewController.draggedImagesPanView(_:)))
        imagesView.addGestureRecognizer(_panImagesRec)
    }
    
    override func viewDidAppear(animated: Bool) {
        _filterInitialOriginY = panView.frame.origin.y
        _filterOpenOriginY = 0
        _filterInitialHeight = panView.bounds.size.width
        
        _originalImageCenter = imagesView.center
        
        self.ChangeToUser(arc4random_uniform(4).hashValue)
    }
    
    //Swiping left and right
    func draggedImagesPanView(sender:UIPanGestureRecognizer){
        switch (sender).state {
        case .Began:
            break
        case .Changed:
            
            self.view.bringSubviewToFront(sender.view!)
            let translation = sender.translationInView(self.view)
            sender.view!.center = CGPointMake(sender.view!.center.x + translation.x, sender.view!.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: self.view)
            
        case .Ended, .Cancelled:
            let location: CGPoint = _panImagesRec.locationInView(self.view)
            
            if location.x < self.mainView.bounds.size.width / 2 {
                SlideLeftView()
            } else {
                SlideRightView()
            }
        default:
            break
        }
    }
    
    func SlideLeftView(){
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: [], animations: {
            self.imagesView.center = CGPointMake(-self.imagesView.bounds.size.width, self._originalImageCenter.y)
            self.imagesView.alpha = 0;
            }, completion: { _ in
                self.ChangeToUser(arc4random_uniform(4).hashValue)
                self.imagesView.alpha = 1
                self.imagesView.center = self._originalImageCenter
        })
    }
    
    func SlideRightView(){
        UIView.animateWithDuration(0.4, delay: 0.0, options: [], animations: {
            
            self.imagesView.center = CGPointMake(self.imagesView.bounds.size.width*2, self._originalImageCenter.y)
            self.imagesView.alpha = 0;
            }, completion: { _ in
                self.ChangeToUser(arc4random_uniform(4).hashValue)
                self.imagesView.alpha = 1
                self.imagesView.center = self._originalImageCenter
        })
    }
    
    //Sliding Up and Down
    func draggedPanView(sender:UIPanGestureRecognizer){
        switch (sender).state {
        case .Began:
            break
        case .Changed:
            
            let translation: CGPoint = sender.translationInView(self.view)
            
            if (self.panView.frame.origin.y == 0 && translation.y < 0) {return}
            if (self.panView.frame.origin.y == _filterInitialOriginY && translation.y > 0) {return}
            
            if translation.y < 0 {
                self.panView.frame = CGRectMake(self.panView.frame.origin.x, _filterInitialOriginY + translation.y, self.panView.bounds.size.width, self.mainView.bounds.size.height - translation.y)
            }else{
                self.panView.frame = CGRectMake(self.panView.frame.origin.x, translation.y, self.panView.bounds.size.width, self.mainView.bounds.size.height - translation.y)
            }
        
        case .Ended, .Cancelled:
            let location: CGPoint = sender.locationInView(self.view)
            
            if location.y < self.mainView.bounds.size.height / 2 {
                ShowPanView()
            }
            else {
                HidePanView()
            }
        default:
            break
        }
    }

    func ShowPanView(){
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: [], animations: {
            self.panView.frame = CGRectMake(self.panView.frame.origin.x, 0, self.panView.bounds.size.width, self.mainView.bounds.size.height)
            self.panView.alpha = 1;
            }, completion: nil)
    }
    
    func HidePanView(){
        UIView.animateWithDuration(0.4, delay: 0.0, options: [], animations: {
            self.panView.frame = CGRectMake(self.panView.frame.origin.x, self._filterInitialOriginY, self.panView.bounds.size.width, self._filterInitialHeight)
            self.panView.alpha = 0.8;
            }, completion: nil)
    }
    
    func ChangeToUser(number: Int){
        nameLabel.text = Users[number].name
        descriptionLabel.text = Users[number].description
        imagesView.image = UIImage(named: Users[number].image)
    }

}

class User {
    var name: String!
    var description: String!
    var image: String!
    
    init(name: String, description: String, image: String){
        self.name = name
        self.image = image
        self.description = description
    }
}

