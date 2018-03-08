/*
 * QRCodeReader.swift

 //  App
 //
 //  Created by admin on 28/12/17.
 //  Copyright © 2017 admin. All rights reserved.
 //
 *
 */

import Foundation

/**
 The result of the scan with its content value and the corresponding metadata type.
 */
public struct QRCodeReaderResult {
  /**
   The error corrected data decoded into a human-readable string.
   */
  public let value: String

  /**
   The type of the metadata.
   */
  public let metadataType: String
}
