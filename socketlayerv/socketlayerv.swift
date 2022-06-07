//
//  socketlayerv.swift
//  swimbox
//
//  Created by FILALI MOHAMED on 23/12/2021.
//  Copyright © 2021 FILALI MOHAMED. All rights reserved.
//

//socketforvitalia

import Foundation
import UIKit


//Main Class for Socket Operations.

class socketlayerv: NSObject {
    
    var msgto="hamza"
    var dragon="hamza"
    var dragonph="hamza"
    var dragonrx="hamza"
    var dragonba="hamza"
    var dragonpu="hamza"
    var dragonvit="hamza"
    var dragonhor="hamza"
    var dragonarma="hamza"
    var dragonhory="hamza"
    var dragoncourant="hamza"
    var dragonbalais="hamza"
    var dragondange="hamza"


    var flagconnect : Bool = false


    var konan="hamza"
    var symba="hamza"
    var togo="hamza"
    var balaiss="hamza"
    var balaisba="hamza"


    var msgend="hamza"
    var firstParta="first"
    
    //Shared Instance For Universal Use.
    
    static let shared: socketlayerv = socketlayerv(maxLength: 40960)
    
    
    //Input & Output Streams.
    
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    
    
    //Max Length In Read.
    
    let maxReadLength: Int
    
    
    //Delegate
    
    var delegate: socketlayerdelegate?
    
    
    //Private Initializer.
    
    private init(maxLength: Int) {
        maxReadLength = maxLength
    }
    
    
    //Setup Connection function.
    
    func setupConnection(host: String, port: UInt32) {
        
        print("lets go")
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host as CFString, port, &readStream, &writeStream)
        
        //Make Streams Managed
        inputStream = readStream?.takeRetainedValue()
        outputStream = writeStream?.takeRetainedValue()
        
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .commonModes)
        outputStream.schedule(in: .current, forMode: .commonModes)
        
        inputStream.open()
        outputStream.open()
        
    }
    
    func closeConnection(host: String, port: UInt32) {
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host as CFString, port, &readStream, &writeStream)
        
        //Make Streams Managed
        inputStream = readStream?.takeRetainedValue()
        outputStream = writeStream?.takeRetainedValue()
        
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .commonModes)
        outputStream.schedule(in: .current, forMode: .commonModes)
        
        inputStream.close()
        outputStream.close()
    }
    
    
    //Send Function.
    
    func send(message: String) {
        if let data = message.data(using: .utf8) {
            data.withUnsafeBytes{ body in
                guard let pointer = body.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    print("Error in creating the pointer")
                    return
                }
                outputStream.write(pointer, maxLength: data.count)
            }
        }
    }
    
    func sendbyte(message: String) {

        let array: [UInt8] = Array(message.utf8)

        array.withUnsafeBufferPointer {
            guard let baseAddress = $0.baseAddress else { return }
         //   print(outputStream)
            
            if (self.flagconnect == true){
                outputStream.write(baseAddress, maxLength: array.count)

            }

            //outputStream.write(baseAddress, maxLength: array.count)

        }
    }
    
    func sendbytee(message: String) {
        
       // let encodedDataArray = [UInt8](message.utf8)
       // outputStream.write(encodedDataArray, maxLength: encodedDataArray.count)
        
        let array: [UInt8] = Array(message.utf8)

        array.withUnsafeBufferPointer {
            guard let baseAddress = $0.baseAddress else { return }
            outputStream.write(baseAddress, maxLength: array.count)
            
            
         //   print(array)
          //  print(baseAddress)
         //  print(bytes.count)

        }
        
    
    }
    
    
 
    

    
    func sendPacket(packet: [UInt8]) {
          let data: Data = Data(bytes: packet);
          _ = data.withUnsafeBytes {
              outputStream?.write($0, maxLength: data.count)
          }
            print(data)

    }
    
    func stopChatSession() {
        
        print("stopchat")
        
        if (flagconnect == true){
            print("gg")
             inputStream.close()
             outputStream.close()
        }
      //  print(inputStream.hasBytesAvailable)
     // inputStream.close()
     // outputStream.close()
    }
    
    
}
    
    
    //Stream Delegate & Receive Handling.
    
    extension socketlayerv: StreamDelegate {
        
        
        
        //Stream Handling Function.
        
        func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
            if eventCode == .hasBytesAvailable {
                
                //New Message Received.
                readAvailableBytes(stream: aStream as! InputStream)
            }else{
                print("no msg rec")
                msgto = "DRAGON"
                togo  = "DRAGON"
                konan = "DRAGON"
                symba = "DRAGON"

            }

        }

        //Reading Bytes Function.
        
        private func readAvailableBytes(stream: InputStream) {
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
            
            while inputStream.hasBytesAvailable {
                let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
                
                if numberOfBytesRead < 0, let _ = inputStream.streamError {
                    print("Error in reading the stream")
                    break
                }else{
                //    print("ok in reading the stream")
                   // print(buffer)

                    self.flagconnect = true

                }
                
                constructMessage(buffer: buffer, length: numberOfBytesRead)
            }
        }
        
        
        //Constructing Message Function.
        
        private func constructMessage(buffer: UnsafeMutablePointer<UInt8>, length: Int) {
            guard let message = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true) else {
                print("Error in getting the message")
                return
            }
            
            delegate?.receive(message: message)
            
            
            msgto=message
            
            print(message)
            
            let string = msgto
            if let range = string.range(of: "\0") {
                let firstPart = string[string.startIndex..<range.lowerBound]
               // print(firstPart) // print Hello
                msgto=String(firstPart)
                
                if(String(firstPart).contains("EpuPa-") || String(firstPart).contains("Epu-")){
                    dragonpu=String(firstPart)

                }else if(String(firstPart).contains("EpuV-")){
                     dragonvit=String(firstPart)
                    
                }else if(String(firstPart).contains("Eba-")){
                     dragonbalais=String(firstPart)
                    
                }else if (String(firstPart).contains("epH-")){
                    dragonph=String(firstPart)

                 }else if (String(firstPart).contains("erX-")){
                    dragonrx=String(firstPart)

                 }else if (String(firstPart).contains("pl-")){
                    dragonhor=String(firstPart)

                 }else if (String(firstPart).contains("Y-")){
                    dragonhory=String(firstPart)

                 }else if (String(firstPart).contains("PHRX-")){
                    dragonarma=String(firstPart)
                    
                 }else if (String(firstPart).contains("C-")){
                       dragoncourant=String(firstPart)
                 }else if (String(firstPart).contains("Danger")){
                        dragondange=String(firstPart)
              }else{
                    print("nonexyz")
                }
                
            }
            
            
          //  print(msgto)
         //   print(dragon)
         //   print(konan)
          //  print(symba)
            
          //  print(balaiss)



            //msgto=firstPart
        }
        
        
        func narutoht() -> String {
            
//            if(msgto.contains("msg")) {
//
//                var nres = msgto.split(separator: "{")
//                let delimiter = "\"}"
//                 var token = nres[0].components(separatedBy: delimiter)
//              //  print(token[0])
//                msgend=String(token[0])
//               // print("hrtp")
//            }
            return msgend
        }
        
        func dragonht() -> String {
          return dragon
        }
        
        func symbaht() -> String {
          return symba
        }
        
        func konanht() -> String {
          return konan
        }
        
        func dragonredox() -> String {
          return dragonrx
        }
        
        func dragonphbox() -> String {
          return dragonph
        }
        
        func dragonvitalia() -> String {
          return dragonvit
        }
        
        func dragonbal() -> String {
          return dragonbalais
        }
        
        func dragonpump() -> String {
          return dragonpu
        }
        
        func dragonhoraire() -> String {
          return dragonhor
        }
        
        func dragonarpmap() -> String {
          return dragonarma
        }
        
        func dragonhorya() -> String {
          return dragonhory
        }
        
        func dragoncour() -> String {
          return dragoncourant
        }
        func dragondanger() -> String {
          return dragondange
        }
        
}
