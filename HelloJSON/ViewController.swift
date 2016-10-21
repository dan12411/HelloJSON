//
//  ViewController.swift
//  HelloJSON
//
//  Created by 洪德晟 on 2016/10/14.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // 這代表畫面上的 Table Viw Controller
    var tableViewController: MyTableViewController?
    
    // 要用來下載資料的 URLSession
    lazy var session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
        
    }()
    
    // (方法未成功)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        // 2. 產生 Reachability 類別
//        let reachability = Reachability()
//        let networkStatus = reachability.currentReachabilityStatus().rawValue
//        // 3. 判斷網路狀況(Enum)(未完成)
//        if networkStatus == 0 {
//            // 沒連網
//            print("No Internet!")
//        } else {
//            // 有連網
//            print("OK")
//        }
        
        super.viewDidLoad()
        
        // 更改Navigation Bar Color
        navigationController?.navigationBar.barTintColor = UIColor(red: 225.0/255.0, green: 106.0/255.0, blue: 106.0/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
//        let somePerson = Person(name: "Dan", email: "wtf@gmil.com", number: "0800-092-000", photo: "http://jjj.jpg")
//        setInfo(person: somePerson)
        
        // 連結 API 網址
        if let url = URL(string: "https://randomuser.me/api/") {
            
            let downloadTask = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                // 如果有錯誤就不要處理了
                if error != nil {
                    return
                }
                // 如果沒錯的話，開始解析資料
                if let okData = data {
                    // 四個變數，準備存解析的結果
                    var nameResult: String?
                    var phoneResult: String?
                    var emailResult: String?
                    var imageResult: String?
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: okData, options: []) as! [String:Any]
                        print("json: \(json)")
                        if let results = json["results"] as? [Any] {
                            if let person1 = results[0] as? [String:Any] {
                                if let emailAdress = person1["email"] as? String {
                                    emailResult = emailAdress
                                }
                                if let phoneNumber = person1["phone"] as? String {
                                    phoneResult = phoneNumber
                                }
                                if let nameInfo = person1["name"] as? [String:String] {
                                    if let okFirst = nameInfo["first"],
                                        let okLast = nameInfo["last"] {
                                        nameResult = okFirst + " " + okLast
                                    }
                                }
                                if let imageInfo =  person1["picture"] as? [String:String] {
                                    if let image = imageInfo["large"] {
                                        imageResult = image
                                    }
                                }
                                
                            }
                        }
                        // 用下載的資料生出一個 person
                        let loadedPerson = Person(name: nameResult, email: emailResult, number: phoneResult, photo: imageResult)
                        // 用 main thread 去更新畫面
                        DispatchQueue.main.async {
                            self.setInfo(person: loadedPerson)
                        }
                        
                    } catch {
                        print("Can not download information!")
                    }
                }
            })
            // 開始下載
            downloadTask.resume()
        }
    }
    
    func setInfo(person: Person) {
        nameLabel.text = person.name
        tableViewController?.emailAdressLabel.text = person.email
        tableViewController?.phoneNumberLabel.text = person.number
        if let okImageLink = person.photo {
            if let url = URL(string: okImageLink) {
                DispatchQueue.global().async {
                    do {
                        let data = try Data(contentsOf: url)
                        let downloadImage = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.myImage.image = downloadImage
                            // 設定圓角是寬度的一半
                            self.myImage.layer.cornerRadius = self.myImage.frame.size.width / 2
                            self.myImage.clipsToBounds = true
                        }
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 確定是連結到 TableViewController 的 segue
        if segue.identifier == "connect" {
            // 把那個 View Controller 轉型成 My TAbleViewController
            // 存在屬性 TableViewController
            // 就可以用 TableViewController 這個屬性，拿到畫面上的 table view
            tableViewController = segue.destination as? MyTableViewController
        }
    }
    
    var statusBarStyle: UIStatusBarStyle? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}

