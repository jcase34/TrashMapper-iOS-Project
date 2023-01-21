//
//  TagLocationViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/28/22.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


//Create outside viewController class to only instantiate a single formatter to be used everytime
private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  return formatter
}()

class CreatePostViewController: UITableViewController {

    
    //outlets for main screen
    @IBOutlet weak var addPhotoButton: UIButton!
    
    //date section
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    //photos section
    @IBOutlet weak var photoCell: UITableViewCell!
    
    //descriptionLabelCell
    @IBOutlet weak var descriptionCell: UITableViewCell!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numCharsLeft: UILabel!
    
    //textFieldSection
    @IBOutlet weak var descriptionTextCell: UITableViewCell!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //image variable for picker and delegates
    var image: UIImage?
    var keyLocation: TaggedLocationAnnotation!
    var coordinate: CLLocationCoordinate2D?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        navigationItem.title = K.createPostViewTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
      
        setupGestureRecognizer()
        setupViewStyles()
        
        //Load information for a bogus/test location
        dateLabel.text = format(date: Date())

        //Delegate assignments
        descriptionTextView.delegate = self
        
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
    
    func setupGestureRecognizer() {
        //create gesture recognizer for tap outside of UITextView
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
}


//MARK: Form styles
extension CreatePostViewController {
    func setupViewStyles() {
        //setup background color of main view
        FormUtlities.setupBackgroundColor(self.view)
        //setup tableview color
        tableView.backgroundColor = UIColor.systemBlue
        
        //UITextView Setup
        descriptionTextView.text = K.descriptionTextFieldText
        descriptionTextView.textColor = FormUtlities.mainColor
        
        //max char length allowed for description text
        numCharsLeft.text = K.numCharsLeft
        //date cell section
        dateCell.backgroundColor = UIColor.systemBlue
        dateTitleLabel.textColor = FormUtlities.mainColor
        dateLabel.textColor = FormUtlities.mainColor
        //photo cell section
        photoCell.backgroundColor = UIColor.systemBlue
        photoCell.textLabel?.textColor = FormUtlities.mainColor
        
        //description label cell section
        descriptionCell.backgroundColor = UIColor.systemBlue
        descriptionLabel.textColor = FormUtlities.mainColor
        numCharsLeft.textColor = FormUtlities.mainColor
        
        //description text cell section
        descriptionTextCell.backgroundColor = UIColor.systemBlue
        descriptionTextView.textColor = FormUtlities.mainColor
    }
    
}


//MARK: - Data Manager Tasks (Firebase)
/*

 
 */


//MARK: - Navigation Buttons functions
extension CreatePostViewController {
    @IBAction func addPhotoButton(_ sender: Any) {
        print("add photo tapped")
        pickPhoto()
    }
    
    @IBAction func cancel(_ sender: Any) {
        print("cancel tapped")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        if let image = image {
            //prompt to select an image
            let path = "images/\(UUID().uuidString).jpg"
            let docRef = FirebaseDataManager.shared.generateNewPostReferenceID()
            FirebaseDataManager.shared.createNewPostInCloud(dateLabel.text!, descriptionTextView.text, coordinate!, imagePath: path, docRef)
            FirebaseDataManager.shared.updateUserDocumentPostsEntries(docRef)
            FirebaseDataManager.shared.uploadPhoto(image: image, imagePath: path)
            
            navigationController?.popViewController(animated: true)
        } else {
            return
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.tintColor = FormUtlities.mainColor
    }
}


//MARK: - Image Picker and Selection
extension CreatePostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //After photo picked, grap photo from infokeys
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if let theSelectedImage = image {
            //display photo within button "addPhoto"
            displayImageOnButton(theSelectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
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
            textView.textColor = FormUtlities.mainColor
        }
    }
    
    //once user starts typing, change text to black
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == FormUtlities.mainColor {
            textView.text = nil
        }
    }
    
    //show number of characters left for description field
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        /*
         Reference Link - https://stackoverflow.com/questions/32935528/setting-maximum-number-of-characters-of-uitextview-and-uitextfield
         */
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        //grab the current text count
        let charLength = K.charLength - (numberOfChars)
        //update the cell detail label
        numCharsLeft.text = "Characters left: \(charLength)"
        return numberOfChars < 100

    }
}

