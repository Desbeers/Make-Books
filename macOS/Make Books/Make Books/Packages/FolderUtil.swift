//
//  FolderUtil.swift
//  SwiftlyFolderUtilities
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Persistent folder utilities
public enum FolderUtil {
    // Just a placeholder
}

public extension FolderUtil {

    /// Check if an URL exist on the file system
    /// - Parameter url: The URL; can be file or folder
    /// - Returns: The URL if exist, else `nil`
    static func doesUrlExist(url: URL) -> URL? {
        if FileManager.default.fileExists(atPath: url.path(percentEncoded: false)) {
            return url
        }
        return nil
    }
}

public extension URL {
    func exist() -> Bool {
        return FileManager.default.fileExists(atPath: self.path(percentEncoded: false))
    }
}

#if os(macOS)

extension FolderUtil {

    /// Open an URL in the Finder
    /// - Parameter url: The URL to open
    public static func openInFinder(url: URL?) {
        guard let url = url else {
            return
        }
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

public extension URL {

    func openInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([self])
    }
}

#endif
