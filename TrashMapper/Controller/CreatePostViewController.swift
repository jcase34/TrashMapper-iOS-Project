//
//  TagLocationViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/28/22.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

//Create outside viewController class to only instantiate a single formatter to be used everytime
private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  return formatter
}()

class CreatePostViewController: UITableViewController {
    
    //coreData vars
//    var managedObjectContext: NSManagedObjectContext!
    
    //outlets for main screen
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numCharsLeft: UILabel!
    
    
    //image variable for picker and delegates
    var image: UIImage?
    var keyLocation: TaggedLocationAnnotation!
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = K.createPostViewTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)

        print("At create post")
        print(coordinate)
        FormUtlities.setupBackgroundColor(self.view)
        
        //create gesture recognizer for tap outside of UITextView
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        
        //Load information for a bogus/test location
        
        dateLabel.text = format(date: Date())
        //UITextView Setup
        descriptionTextView.text = K.descriptionTextFieldText
        descriptionTextView.textColor = UIColor.lightGray
               
        
        //Delegate assignments
        descriptionTextView.delegate = self
        
        //max char length allowed for description text
        numCharsLeft.text = K.numCharsLeft

        
        //ISSUE - addPhotoButton.addDashedBorder() does not work, doesn't cover entire frame.
        //addPhotoButton.addDashedBorder()
        
        //ToDo
        //App Looks better in white for demonstration
        //Update later with custom Xibs, colors, etc.
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    
    //MARK: - Helper Methods
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        
        //refernce point from user tap
        let point = gestureRecognizer.location(in: tableView)
        //match point from tap to location on tableView
        let indexPath = tableView.indexPathForRow(at: point)
        
        //if user tap anywhere outide of UITextView, dismiss keybaord
        if let indexPath = indexPath {
            if indexPath.row != 3 {
                descriptionTextView.resignFirstResponder()
            }
        }
    }
}

//MARK: - Data Manager Tasks (Firebase)
/*

 
 */

//MARK: - UIButton functions
extension CreatePostViewController {
    @IBAction func addPhotoButton(_ sender: Any) {
        print("add photo tapped")
        pickPhoto()
    }
    
    @IBAction func cancel(_ sender: Any) {
        print("cancel tapped")
        navigationController?.popViewController(animated: true)
        //move back to previous view controller
        //ping location?
        //remove picture, and other potential post information
    }
    
    @IBAction func submit(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepping for segue, identifier = \(String(describing: segue.identifier))")
        keyLocation = TaggedLocationAnnotation(coordinate: coordinate, title: dateLabel.text!, subtitle: descriptionTextView.text!)
        if segue.identifier == "PassDataToMap" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.mapAnnotation.append(keyLocation)
            //possible error on not getting current location vs changing to other tab
      }
    }
}


//MARK: - Table View Methods
extension CreatePostViewController {
    //Keyboard activation for description area
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 3 {
            descriptionTextView.becomeFirstResponder()
        }
    }
}


//MARK: - Image Picker and Selection
extension CreatePostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //After photo picked, grap photo from infokeys
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if let theImage = image {
            //display photo within button "addPhoto"
            displayImageOnButton(theImage)
            
            
            /*
             To Dos:
             function to grab directory of app
             assign unique UUID to photo (better strategy?)
             store a compressed image within file via URL (as big as AddPhoto button for consistancy)
             store location of that image, wiping if we cancel out or select different image
             */
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoSelectionMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoSelectionMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in self.takePhotoWithCamera()})
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in self.choosePhotoFromLibrary()})
        alert.addAction(actLibrary)
        present(alert, animated: true)
        
    }
    
    func displayImageOnButton(_ image: UIImage) {
        addPhotoButton.setImage(image, for: .normal)
    }
    
}

//MARK: - Text View Delegate
extension CreatePostViewController : UITextViewDelegate {
    
    //if textview empty, display a placeholder text
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description Here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    //once user starts typing, change text to black
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    //show number of characters left for description field
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //if no text in the view, return
        guard let textField = textView.text else {return true}
    
        //grab the current text count, replacement count, and desired range as a length
        let charLength = K.charLength - (textField.count + text.count - range.length)
        
        //update the cell detail label
        numCharsLeft.text = "Characters left: \(charLength)"
        
        //only allow text update if under 100 chars
        return charLength <= 99
    }
}

