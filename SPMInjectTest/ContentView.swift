//
//  ContentView.swift
//  MyTVUITest
//
//  Created by JeongCheol Kim on 2022/06/07.
//

import SwiftUI
import CoreData
import MyTV


struct ContentView: View {
    @EnvironmentObject var launcher:MyTvLauncherObservable
    enum TestType{
        case player, download
    }
    @State var type:TestType? = nil
    var body: some View {
        ZStack{
            if type == .player {
                MyTvPlayerView()
        
            } else if type == .download {
                MyTvDownLoad()
                   
            } else {
                VStack(spacing:100){
                    Text("MyTV version " + Mytv.version)
                    Button(action: {
                        
                        self.type = .player
                    }) {
                        Text("MyTV TEST")
                    }
                    
                }
                .padding(.all, 30)
            }
            
            
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            AppDelegate.orientationLock = [UIInterfaceOrientationMask.landscapeLeft]
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
        .onReceive(self.launcher.$mytvEvent) { evt in
            switch evt {
            case .close : self.type = .none
            case .ciVerified(let closer) :
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    if let info = Mytv.shared.userInfo as? MytvAdotUserInfoProvider {
                        info.userAdultCertification = true
                        closer(true, "success")
                    }
                }
            
            default : break
            }
        }
    }
}


