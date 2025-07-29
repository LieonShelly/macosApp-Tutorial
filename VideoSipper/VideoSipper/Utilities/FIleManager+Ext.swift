//
//  FIleManager+Ext.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/25.
//

import Cocoa

extension FileManager {
    
    func isFolder(url: URL) -> Bool {
        var isDir: ObjCBool = false
        if fileExists(atPath: url.path(percentEncoded: false), isDirectory: &isDir) {
            return isDir.boolValue
        }
        return false
    }
    
    func isImageFile(url: URL) -> Bool {
        guard let contentTypeKey = try? url.resourceValues(forKeys: [.contentTypeKey]) else {
            return false
        }
        
        guard let supertypes = contentTypeKey.contentType?.supertypes else {
            return false
        }
        return supertypes.contains(.image)
    }
    
    func isVideoFile(url: URL) -> Bool {
        guard let contentTypeKey = try? url.resourceValues(forKeys: [.contentTypeKey]) else {
            return false
        }
        
        guard let supertypes = contentTypeKey.contentType?.supertypes else {
            return false
        }
        return supertypes.contains(.movie)
    }
    
    func imageFiles(in url: URL) -> [URL] {
        do {
            let files = try self.contentsOfDirectory(atPath: url.path(percentEncoded: false))
            let imageFils = files.map {
                url.appending(path: $0)
            }
                .filter { url in
                    isImageFile(url: url)
                }
            return imageFils
        } catch {
            print(error)
            return []
        }
    }
    
    func changeFileExtension(of url: URL, to newExt: String) -> URL {
        let newURL = url.deletingPathExtension().appendingPathExtension(newExt)
        return newURL
    }
    
    func addSuffix(of suffix: String, to url: URL) -> URL {
        let ext = url.pathExtension
        let filename = url.deletingPathExtension()
            .lastPathComponent
            .components(separatedBy: " -> ")[0]
        let newURL = url.deletingLastPathComponent()
        let newPath = "\(filename) \(suffix).\(ext)"
        return newURL.appendingPathComponent(newPath)
    }
}
