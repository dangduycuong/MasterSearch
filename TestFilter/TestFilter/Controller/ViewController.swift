//
//  ViewController.swift
//  TestFilter
//
//  Created by Đặng Duy Cường on 2/4/20.
//  Copyright © 2020 Ngô Bảo Châu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sourceArrayLabel: UILabel!
    @IBOutlet weak var resultArrayLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noteLabel: UILabel!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var sourceArray = ["Khanh Linh", "Huyen Linh", "Hien Linh", "Dieu Linh", "Ngoc Tram"]
    var resultArray = [String]()
    
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        setDisplay()
        
        // SearchBar
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        noteLabel.text = note
        
        // Ẩn bàn phím khi ấn ra bên ngoài
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureReconizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureReconizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    let note = """
    Lưu ý khi thực hiện xong bài này. Nhập xong với lọc và vừa nhập vừa lọc ra kết quả. Action trong keyboard, textField...
    Ẩn bàn phím khi thực hiện action. Ẩn khi ấn ra ngoài.
    """
    func setDisplay() {
        var source: String = """
        \(sourceArray)
        """
        let vowels: Set<Character> = ["\\", "[", "]"]
        source.removeAll(where: { vowels.contains($0) })
        
        sourceArrayLabel.text = source
        var result: String = """
        \(resultArray)
        """
        result.removeAll(where: { vowels.contains($0) })
        resultArrayLabel.text = result
    }
    
    func filtering(keyWord: String) {
        resultArray = sourceArray.filter({ (laptop: String) in
            laptop.lowercased().contains(keyWord.lowercased())
        })
    }
    
    @IBAction func onClickedFilter(_ sender: UIButton) {
        filtering(keyWord: searchTextField.text!)
        setDisplay()
        view.endEditing(true)
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == searchTextField {
//            filtering(keyWord: searchTextField.text!)
//            setDisplay()
//        }
//    }
    
    // Action cho textField
    // Dùng func
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        filtering(keyWord: searchTextField.text!)
        setDisplay()
        return true
    }
    // Kéo Action  @IBAction func onClickToFiltering(_ sender: UITextField) {
//        filtering(keyWord: searchTextField.text!)
//        setDisplay()
//        view.endEditing(true)
//    }
    
    
    @IBAction func nextCooktail(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "CocktaildbVC") as! Youtube v3VC
//        present(vc, animated: true, completion: nil)
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        resultArray = sourceArray.filter({ (laptop: String) in
            laptop.lowercased().contains(searchBar.text!.lowercased())
        })
        setDisplay()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        filterContentForSearch(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        filtering(keyWord: searchBar.text!)
    }
    
    // khi bắt dầu chạm vào search
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        filtering(keyWord: searchBar.text!)
        setDisplay()
        view.endEditing(true)
    }
    
    // Nhập đến đâu lọc đến đó
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text ?? ""
        
        resultArray = sourceArray.filter { word in
            word.lowercased().contains(searchText.lowercased())
        }
        
        
        if (resultArray.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        setDisplay()
    }
}
