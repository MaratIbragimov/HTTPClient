//
//  URLErrorExtensions.swift
//  SpotifyApiExampleTests
//
//  Created by Marat Ibragimov on 24/12/2022.
//

import Foundation


extension URLError {
    
    static func errorCodes() -> [URLError]{
        let errorCodes: [URLError.Code] = [.unknown,
        .cancelled,
        .badURL,
        .timedOut,
        .unsupportedURL,
        .cannotFindHost,
        .cannotConnectToHost,
        .networkConnectionLost,
        .dnsLookupFailed,
        .httpTooManyRedirects,
        .resourceUnavailable,
        .notConnectedToInternet,
        .redirectToNonExistentLocation,
        .badServerResponse,
        .userCancelledAuthentication,
        .userAuthenticationRequired,
        .zeroByteResource,
        .cannotDecodeRawData,
        .cannotDecodeContentData,
        .cannotParseResponse,
        .appTransportSecurityRequiresSecureConnection,
        .fileDoesNotExist,
        .fileIsDirectory,
        .noPermissionsToReadFile,
        .dataLengthExceedsMaximum,
        .secureConnectionFailed,
        .serverCertificateHasBadDate,
        .serverCertificateUntrusted,
        .serverCertificateHasUnknownRoot,
        .serverCertificateNotYetValid,
        .clientCertificateRejected,
        .clientCertificateRequired,
        .cannotLoadFromNetwork,
        .cannotCreateFile,
        .cannotOpenFile,
        .cannotCloseFile,
        .cannotWriteToFile,
        .cannotRemoveFile,
        .cannotMoveFile,
        .downloadDecodingFailedMidStream,
        .downloadDecodingFailedToComplete,
        .internationalRoamingOff,
        .callIsActive,
        .dataNotAllowed,
        .requestBodyStreamExhausted,
        .backgroundSessionRequiresSharedContainer,
        .backgroundSessionInUseByAnotherProcess,
        .backgroundSessionWasDisconnected]
        
        return errorCodes.map{URLError($0)}
    }
}
