//
//  ProductDetailTableViewController.swift
//  CoreDataDemo
//
//  Created by Teewa on 03/03/17.
//  Copyright © 2017 Teewa. All rights reserved.
//

import UIKit
import CoreData

class ProductDetailTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var productPriceTextField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext?{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSaveButton()
        
    }

    func setSaveButton(){
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector (ProductDetailTableViewController.saveProduct))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func saveProduct(){
        print("Price: \(productPriceTextField.text!) - Name: \(productNameTextField.text!) - Description: \(productDescriptionTextView.text!) ")
        
        if productPriceTextField.text!.isEmpty || productNameTextField.text!.isEmpty || productDescriptionTextView.text!.isEmpty  || productImageView.image == nil{
            let alertController = UIAlertController(title: "OOPS", message: "You need to give all the information requered to save this product.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        
        }else{
            //Save Here
            
            if let moc = managedObjectContext{
                let product = Product(context: moc)
                product.productName = productNameTextField.text!
                product.productPrice = Float(productPriceTextField.text!)!
                product.productDescritption = productDescriptionTextView.text!
                
                if let data = UIImageJPEGRepresentation(self.productImageView.image!, 1.0){
                    product.productImage = data as NSData
                }
                
                saveToCoreData(){
                    self.navigationController!.popViewController(animated: true)
                }
            }else{
                print("Nao foi")
            }
        }
    }
    
    func saveToCoreData(completion: @escaping()->Void){
        managedObjectContext!.perform{
            do{
                try self.managedObjectContext?.save()
                completion()
                print("Product saved to CoreData.")
            }catch let error{
                print("Could not save Product in CoreData: \(error.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func pickProductImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing  = true
        
        let alertController  = UIAlertController(title: "Add a Picture", message: "Chose Form", preferredStyle: .actionSheet)
        
        let cameraAction  = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let photosLibraryAction  = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true,  completion: nil)
        }
        
        let savedPhotosAction  = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            print("imagem editada")
            self.productImageView.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("imagem original ")
            self.productImageView.image = image
        } else {
            print("Erro na imagem")
            self.productImageView.image = nil
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
