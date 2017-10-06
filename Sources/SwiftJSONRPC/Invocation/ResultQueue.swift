// ----------------------------------------------------------------------------
//
//  ResultQueue.swift
//
//  @author Denis Kolyasev <kolyasev@gmail.com>
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public enum ResultQueue
{
    case main
    case background
    case custom(queue: DispatchQueue)
}

// ----------------------------------------------------------------------------