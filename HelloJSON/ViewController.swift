//
//  ViewController.swift
//  HelloJSON
//
//  Created by 洪德晟 on 2016/10/14.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let somePerson = Person(name: "Dan", email: "abc@gmil.com", number: "123-456-789", photo: "http://jjj.jpg")
    }
    
    func setInfo(person: Person) {
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

