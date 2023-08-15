//
//  ConfirmationAlert.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 15/08/23.
//

import Foundation

struct ConfirmationAlert {
    var showAlert: Bool = false
    var description: String = "Você confirma a ação?"
    var action: (() -> ())? = nil
}
