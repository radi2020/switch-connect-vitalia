//
//  socketlayerdelegate.swift
//  swimbox
//
//  Created by FILALI MOHAMED on 23/12/2021.
//  Copyright © 2021 FILALI MOHAMED. All rights reserved.
//

import Foundation
import UIKit


//Protocol For Handling Receive Message Action.

protocol socketlayerdelegate {
    func receive(message: String)
}
