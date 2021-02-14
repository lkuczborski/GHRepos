//
//  ButtonStyles.swift
//  CombineDemo
//
//  Created by Łukasz Kuczborski on 14/02/2021.
//

import SwiftUI

extension Text {
    func title() -> Text {
        self
            .font(.title3)
            .foregroundColor(.secondary)
    }
    
    func titleBold() -> Text {
        self
            .title()
            .fontWeight(.black)
    }
    
    func description() -> Text {
        self
            .font(.subheadline)
    }
}
