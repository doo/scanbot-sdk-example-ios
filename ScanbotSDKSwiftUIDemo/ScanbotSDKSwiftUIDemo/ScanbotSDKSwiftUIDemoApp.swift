//
//  ScanbotSDKSwiftUIDemoApp.swift
//  ScanbotSDKSwiftUIDemo
//
//  Created by Danil Voitenko on 14.10.21.
//

import SwiftUI
import ScanbotSDK

@main
struct ScanbotSDKSwiftUIDemoApp: App {
    
    init() {
        ScanbotSDK.setLicense(
        "e/Yja/KIcfTf1KK2TZagJIs69+oimt" +
        "hJI7C6FePMxWygNf7Tquw9z50bVzaB" +
        "lF9+293NaSbuoLSTSN5Wyzs9J+JdsP" +
        "PxuzGXm3BPzWYZcDglgd4ID6Hjh049" +
        "xWcCXQxkk1VFGHsByMFvr/ongdXUTM" +
        "jNqGlQJRqNaYptNhPQytv8VE/ECxE+" +
        "48lUxembvwgiCAVSJhuh6Egkq03fM8" +
        "466S0JKTTVNT8RyowE9pI8pzjB4bH5" +
        "UR0QImZ9bH1dBkktaflHSlEbdCHXqI" +
        "TlR1MrS8vwMyL+ECWH14+9UL67Xr4Z" +
        "etoVQY+kHGynaHir5T8oFj/bJN5jeB" +
        "4Cxc5QEDudBg==\nU2NhbmJvdFNESw" +
        "ppby5zY2FuYm90LlNjYW5ib3RTREtT" +
        "d2lmdFVJRGVtbwoxNjM2OTM0Mzk5Cj" +
        "gzODg2MDcKMQ==\n")
    }
    
    var body: some Scene {
        WindowGroup {
            MainListView()
        }
    }
}
