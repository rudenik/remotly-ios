//
//  TorrentExtensions.swift
//  Remotly
//
//  Created by Marcin Czachurski on 25.08.2015.
//  Copyright (c) 2015 SunLine Technologies. All rights reserved.
//

import Foundation

extension Torrent
{
    func synchronizeData(_ torrentFromServer:TorrentInformation)
    {
        self.hashString = torrentFromServer.hashString
        self.id = torrentFromServer.id
        self.isFinished = torrentFromServer.isFinished
        self.leftUntilDone = torrentFromServer.leftUntilDone
        self.name = torrentFromServer.name
        self.peersConnected = torrentFromServer.peersConnected
        self.peersGettingFromUs = torrentFromServer.peersGettingFromUs
        self.peersSendingToUs = torrentFromServer.peersSendingToUs
        self.percentDone = torrentFromServer.percentDone
        self.rateDownload = torrentFromServer.rateDownload
        self.rateUpload = torrentFromServer.rateUpload
        self.sizeWhenDone = torrentFromServer.sizeWhenDone
        self.status = torrentFromServer.status
        self.totalSize = torrentFromServer.totalSize
        self.addedDate = torrentFromServer.addedDate
        //self.files = torrentFromServer.files  
      //print("Self Files: \(self.files) torrentFromServerFiles: \(torrentFromServer.files)")
      //for filesFromServer in torrentFromServer.files {
//        let file = File(name: filesFromServer[0], length: filesFromServer[1], completed: filesFromServer[2], percentage: filesFromServer[3])
        
        //print(filesFromServer)
        //self.files.adding(filesFromServer)
//        print("name: \(filesFromServer.name)")
//        print("Length: \(filesFromServer.length)")
//        print("Completed: \(filesFromServer.completed)")
//        print("Percentage: \(filesFromServer.percentage)")
        //let lengthNumber: NSNumber = NSNumber(value: filesFromServer.length)
//        let fileToAdd: File = File(name: filesFromServer.name, length: lengthNumber, bytesCompleted: Double(filesFromServer.completed), percentage: filesFromServer.percentage, entity: entity, insertIntoManagedObjectContext: managedObjectContext!)
        //self.files.adding(File(name: filesFromServer.name, length: Int64(filesFromServer.length), bytesCompleted: Double(filesFromServer.completed), percentage: filesFromServer.percentage, entity: entity, insertIntoManagedObjectContext: managedObjectContext!))
        //CoreDataHandler.createFileEntity(_, managedContext: managedObjectContext!)
        /*
        //I think this needs to go somewhere else, compare files.count from info to CDTorrent
       
       if fetchedfilesresult.count != torrentFromServer.files.count{
       FILL THIS IN WITH THE CREATION OF THE ENTITY FOR ALL THE FILES IN THE TORRENTINFORMATION.FILES
       }
       ELSE
       {
       UPDATE THE FILE PROPERTIES FOR COMPLETED AND PERCENTAGE
       }
        let fileToAdd = CoreDataHandler.createFileEntity(torrentFromServer, managedContext: managedObjectContext!)
        fileToAdd.name = filesFromServer.name
        fileToAdd.length = filesFromServer.length
        fileToAdd.bytesCompleted = filesFromServer.completed
        fileToAdd.percentage = filesFromServer.percentage
        self.files.adding(fileToAdd)
        print("Self Files: \(self.files)")*/
      //}
    }
  
    
    var downloadedPercentDone: Double {
        get {
            if(totalSize > 0)
            {
                let percent = Double(downloadedSize) / Double(totalSize)
                return percent
            }
            
            return 0.0
        }
    }
    
    var downloadedSize: Int64 {
        get {
            let downloaded = sizeWhenDone - leftUntilDone
            return downloaded
        }
    }
    
    var secondsToFinish: Int64 {
        get {
            var seconds:Int64 = 0
            if(rateDownload > 0)
            {
                seconds = leftUntilDone / rateDownload
            }
            return seconds
        }
    }
    
    var isDownloading: Bool {
        get {
            var statusEnum = TorrentStatusEnum(rawValue: status)
            return statusEnum == TorrentStatusEnum.downloading
        }
    }
    
    var isPaused: Bool {
        get {
            var statusEnum = TorrentStatusEnum(rawValue: status)
            return statusEnum == TorrentStatusEnum.paused
        }
    }
    
    var sizeInformationValue: String {
        get {
            let sizeString = FormatHandler.formatSizeUnits(totalSize)
            let downloadedSizeString = FormatHandler.formatSizeUnits(downloadedSize)
            let downloadedPercentDoneString = FormatHandler.roundTwoPlaces(downloadedPercentDone * 100)
            
            var sizeInformation = "\(downloadedSizeString) of \(sizeString) (\(downloadedPercentDoneString)%)"
            
            if(isDownloading)
            {
                let secondsToFinishString = FormatHandler.formatTime(secondsToFinish)
                sizeInformation = "\(sizeInformation) - \(secondsToFinishString)"
            }
            
            return sizeInformation
        }
    }
    
    var peersInformationValue: String {
        get {
            let peersInformationValue:String
            
            var statusEnum = TorrentStatusEnum(rawValue: status)
            
            if(statusEnum == nil)
            {
                return "unknown status"
            }
            
            switch(statusEnum!)
            {
                case TorrentStatusEnum.paused:
                    peersInformationValue = "Paused"
                case TorrentStatusEnum.verifying:
                    peersInformationValue = "Verifying..."
                case TorrentStatusEnum.deleting:
                    peersInformationValue = "Deleting..."
                case TorrentStatusEnum.downloading:
                    peersInformationValue = "Downloading from \(peersSendingToUs) of \(peersConnected) peers"
                case TorrentStatusEnum.finished:
                    peersInformationValue = "Seeding to \(peersGettingFromUs) of \(peersConnected) peers"
            }
            
            return peersInformationValue
        }
    }
    
    var downloadInformationValue: String {
        get {
            if(status == TorrentStatusEnum.finished.rawValue)
            {
                return "DL: downloaded"
            }
            else
            {
                let rateDownloadString = FormatHandler.formatSizeUnits(rateDownload)
                return "DL: \(rateDownloadString)/s"
            }
        }
    }
    
    var uploadInformationValue: String {
        get {
            let rateUpladString = FormatHandler.formatSizeUnits(rateUpload)
            return "UL: \(rateUpladString)/s"
        }
    }
}
