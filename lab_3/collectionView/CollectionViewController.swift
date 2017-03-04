//
//  CollectionViewController.swift
//  collectionView
//
//  Created by Siddharth on 2/21/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{

    var actionImages: [String] = ["action1","action2","action3", "action4"]
    var comedyImage: [String] = ["comedy1", "comedy2"]
    var dramaImages: [String] = ["drama1", "drama2"]
    var crimeImages: [String] = ["crime1","crime2","crime3", "crime4"]

    let sectionInsets = UIEdgeInsetsMake(25.0, 10.0, 25.0, 10.0)
    
    var selectedImageName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes. Commented out since it is done in storyboard also.
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0)
        {
            return actionImages.count
        }
        if(section == 1)
        {
            return comedyImage.count
        }
        if(section == 2)
        {
            return crimeImages.count
        }
        if(section == 3)
        {
            return dramaImages.count
        }
        else
        {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        if(indexPath.section == 0)
        {
            cell.imageView.image = UIImage(named: actionImages[indexPath.row])
        }
        if(indexPath.section == 1)
        {
            cell.imageView.image = UIImage(named: comedyImage[indexPath.row])
        }
        if(indexPath.section == 2)
        {
            cell.imageView.image = UIImage(named: crimeImages[indexPath.row])
        }
        if(indexPath.section == 3)
        {
            cell.imageView.image = UIImage(named: dramaImages[indexPath.row])
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        var header: CollectionSupplementaryView?
        var footer: CollectionSupplementaryView?
        
        if kind == UICollectionElementKindSectionHeader
        {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? CollectionSupplementaryView
            if(indexPath.section == 0)
            {
                header?.headerLabel.text = "Action"
            }
            if(indexPath.section == 1)
            {
                header?.headerLabel.text = "Comedy"
            }
            if(indexPath.section == 2)
            {
                header?.headerLabel.text = "Crime"
            }
            if(indexPath.section == 3)
            {
                header?.headerLabel.text = "Drama"
            }
            return header!
        }
        
        else if kind == UICollectionElementKindSectionFooter
        {
            footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as? CollectionSupplementaryView
            if(indexPath.section == 0)
            {
                footer?.footerLabel.text = "Feel the adrenaline"
            }
            if(indexPath.section == 1)
            {
                footer?.footerLabel.text = "Have fun and laughter"
            }
            if(indexPath.section == 2)
            {
                footer?.footerLabel.text = "Watch out for the law"
            }
            if(indexPath.section == 3)
            {
                footer?.footerLabel.text = "Enjoy"
            }
            return footer!
        }
        else
        {
            assert(false, "Unexpected element kind")
        }
        
    }

    //UICollectionViewDelegateFlowLayout method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var image = UIImage()
        
        if(indexPath.section == 0)
        {
            image = UIImage(named: actionImages[indexPath.row])!
        }
        if(indexPath.section == 1)
        {
            image = UIImage(named: comedyImage[indexPath.row])!
        }
        if(indexPath.section == 2)
        {
            image = UIImage(named: crimeImages[indexPath.row])!
        }
        if(indexPath.section == 3)
        {
            image = UIImage(named: dramaImages[indexPath.row])!
        }

        
        let newSize:CGSize = CGSize(width: (image.size.width)/2, height: (image.size.height)/2)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let image2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //end resizing
        
        return (image2?.size)!

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(indexPath.section == 0)
        {
            selectedImageName = actionImages[indexPath.row]
        }
        if(indexPath.section == 1)
        {
            selectedImageName = comedyImage[indexPath.row]
        }
        if(indexPath.section == 2)
        {
            selectedImageName = crimeImages[indexPath.row]
        }
        if(indexPath.section == 3)
        {
            selectedImageName = dramaImages[indexPath.row]
        }
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.imageName = selectedImageName
    }
}
