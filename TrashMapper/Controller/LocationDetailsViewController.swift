//
//  TagLocationViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/28/22.
//

import UIKit
import CoreLocation


private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  formatter.timeStyle = .short
  return formatter
}()

class LocationDetailsViewController: UITableViewController {
    
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!

    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var image: UIImage?
    
    @objc func buttonTouchDown(_ button: UIButton) {
        print("button Touch Down")
    }
    
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
        print("submit tapped")
        //create a userPost
        //push to firebase
        //HUD view with "Location Added"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Dummy post information
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        dateLabel.text = format(date: Date())
        
        
        
        //Delegate assignments
        descriptionTextView.delegate = self
        
        
        //UITextView Setup
        descriptionTextView.text = "Enter Description Here"
        descriptionTextView.textColor = UIColor.lightGray
        
        //ISSUE - addPhotoButton.addDashedBorder() does not work, doesn't cover entire frame.
        //addPhotoButton.addDashedBorder()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func displayImageOnButton(_ image: UIImage) {
        addPhotoButton.setImage(image, for: .normal)
    }

    func format(date: Date) -> String {
     return dateFormatter.string(from: date)
   }
    
    
    
    
    
}
//MARK: - Table View Methods
extension LocationDetailsViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            descriptionTextView.becomeFirstResponder()
        }
    }
    
}


//MARK: - Image Picker Delegate
extension LocationDetailsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in self.takePhotoWithCamera()})
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in self.choosePhotoFromLibrary()})
        alert.addAction(actLibrary)
        present(alert, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //After photo picked, grap photo from infokeys
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if let theImage = image {
            
            displayImageOnButton(theImage)
        }
        //display photo within button "addPhoto"
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Text View Delegate
extension LocationDetailsViewController : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description Here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}

