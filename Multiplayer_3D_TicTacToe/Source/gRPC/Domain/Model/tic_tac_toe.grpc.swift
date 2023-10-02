//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: tic_tac_toe.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


/// Usage: instantiate `Tictactoe_TicTacToeClient`, then call methods of this protocol to make API calls.
public protocol Tictactoe_TicTacToeClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Tictactoe_TicTacToeClientInterceptorFactoryProtocol? { get }

  func connectedMessage(
    _ request: Tictactoe_ConnectMessageRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Tictactoe_ConnectMessageRequest, Tictactoe_ConnectMessageResponse>

  func startGame(
    _ request: Tictactoe_StartGameRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Tictactoe_StartGameRequest, Tictactoe_StartGameResponse>
}

extension Tictactoe_TicTacToeClientProtocol {
  public var serviceName: String {
    return "tictactoe.TicTacToe"
  }

  /// Unary call to ConnectedMessage
  ///
  /// - Parameters:
  ///   - request: Request to send to ConnectedMessage.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func connectedMessage(
    _ request: Tictactoe_ConnectMessageRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Tictactoe_ConnectMessageRequest, Tictactoe_ConnectMessageResponse> {
    return self.makeUnaryCall(
      path: Tictactoe_TicTacToeClientMetadata.Methods.connectedMessage.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeConnectedMessageInterceptors() ?? []
    )
  }

  /// Unary call to StartGame
  ///
  /// - Parameters:
  ///   - request: Request to send to StartGame.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func startGame(
    _ request: Tictactoe_StartGameRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Tictactoe_StartGameRequest, Tictactoe_StartGameResponse> {
    return self.makeUnaryCall(
      path: Tictactoe_TicTacToeClientMetadata.Methods.startGame.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStartGameInterceptors() ?? []
    )
  }
}

@available(*, deprecated)
extension Tictactoe_TicTacToeClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "Tictactoe_TicTacToeNIOClient")
public final class Tictactoe_TicTacToeClient: Tictactoe_TicTacToeClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: Tictactoe_TicTacToeClientInterceptorFactoryProtocol?
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  public var interceptors: Tictactoe_TicTacToeClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the tictactoe.TicTacToe service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Tictactoe_TicTacToeClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

public struct Tictactoe_TicTacToeNIOClient: Tictactoe_TicTacToeClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Tictactoe_TicTacToeClientInterceptorFactoryProtocol?

  /// Creates a client for the tictactoe.TicTacToe service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Tictactoe_TicTacToeClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Tictactoe_TicTacToeAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Tictactoe_TicTacToeClientInterceptorFactoryProtocol? { get }

  func makeConnectedMessageCall(
    _ request: Tictactoe_ConnectMessageRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Tictactoe_ConnectMessageRequest, Tictactoe_ConnectMessageResponse>

  func makeStartGameCall(
    _ request: Tictactoe_StartGameRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Tictactoe_StartGameRequest, Tictactoe_StartGameResponse>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Tictactoe_TicTacToeAsyncClientProtocol {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Tictactoe_TicTacToeClientMetadata.serviceDescriptor
  }

  public var interceptors: Tictactoe_TicTacToeClientInterceptorFactoryProtocol? {
    return nil
  }

  public func makeConnectedMessageCall(
    _ request: Tictactoe_ConnectMessageRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Tictactoe_ConnectMessageRequest, Tictactoe_ConnectMessageResponse> {
    return self.makeAsyncUnaryCall(
      path: Tictactoe_TicTacToeClientMetadata.Methods.connectedMessage.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeConnectedMessageInterceptors() ?? []
    )
  }

  public func makeStartGameCall(
    _ request: Tictactoe_StartGameRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Tictactoe_StartGameRequest, Tictactoe_StartGameResponse> {
    return self.makeAsyncUnaryCall(
      path: Tictactoe_TicTacToeClientMetadata.Methods.startGame.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStartGameInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Tictactoe_TicTacToeAsyncClientProtocol {
  public func connectedMessage(
    _ request: Tictactoe_ConnectMessageRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Tictactoe_ConnectMessageResponse {
    return try await self.performAsyncUnaryCall(
      path: Tictactoe_TicTacToeClientMetadata.Methods.connectedMessage.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeConnectedMessageInterceptors() ?? []
    )
  }

  public func startGame(
    _ request: Tictactoe_StartGameRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Tictactoe_StartGameResponse {
    return try await self.performAsyncUnaryCall(
      path: Tictactoe_TicTacToeClientMetadata.Methods.startGame.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStartGameInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct Tictactoe_TicTacToeAsyncClient: Tictactoe_TicTacToeAsyncClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Tictactoe_TicTacToeClientInterceptorFactoryProtocol?

  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Tictactoe_TicTacToeClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

public protocol Tictactoe_TicTacToeClientInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when invoking 'connectedMessage'.
  func makeConnectedMessageInterceptors() -> [ClientInterceptor<Tictactoe_ConnectMessageRequest, Tictactoe_ConnectMessageResponse>]

  /// - Returns: Interceptors to use when invoking 'startGame'.
  func makeStartGameInterceptors() -> [ClientInterceptor<Tictactoe_StartGameRequest, Tictactoe_StartGameResponse>]
}

public enum Tictactoe_TicTacToeClientMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "TicTacToe",
    fullName: "tictactoe.TicTacToe",
    methods: [
      Tictactoe_TicTacToeClientMetadata.Methods.connectedMessage,
      Tictactoe_TicTacToeClientMetadata.Methods.startGame,
    ]
  )

  public enum Methods {
    public static let connectedMessage = GRPCMethodDescriptor(
      name: "ConnectedMessage",
      path: "/tictactoe.TicTacToe/ConnectedMessage",
      type: GRPCCallType.unary
    )

    public static let startGame = GRPCMethodDescriptor(
      name: "StartGame",
      path: "/tictactoe.TicTacToe/StartGame",
      type: GRPCCallType.unary
    )
  }
}

/// To build a server, implement a class that conforms to this protocol.
public protocol Tictactoe_TicTacToeProvider: CallHandlerProvider {
  var interceptors: Tictactoe_TicTacToeServerInterceptorFactoryProtocol? { get }

  func connectedMessage(request: Tictactoe_ConnectMessageRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Tictactoe_ConnectMessageResponse>

  func startGame(request: Tictactoe_StartGameRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Tictactoe_StartGameResponse>
}

extension Tictactoe_TicTacToeProvider {
  public var serviceName: Substring {
    return Tictactoe_TicTacToeServerMetadata.serviceDescriptor.fullName[...]
  }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "ConnectedMessage":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Tictactoe_ConnectMessageRequest>(),
        responseSerializer: ProtobufSerializer<Tictactoe_ConnectMessageResponse>(),
        interceptors: self.interceptors?.makeConnectedMessageInterceptors() ?? [],
        userFunction: self.connectedMessage(request:context:)
      )

    case "StartGame":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Tictactoe_StartGameRequest>(),
        responseSerializer: ProtobufSerializer<Tictactoe_StartGameResponse>(),
        interceptors: self.interceptors?.makeStartGameInterceptors() ?? [],
        userFunction: self.startGame(request:context:)
      )

    default:
      return nil
    }
  }
}

/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Tictactoe_TicTacToeAsyncProvider: CallHandlerProvider, Sendable {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Tictactoe_TicTacToeServerInterceptorFactoryProtocol? { get }

  func connectedMessage(
    request: Tictactoe_ConnectMessageRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Tictactoe_ConnectMessageResponse

  func startGame(
    request: Tictactoe_StartGameRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Tictactoe_StartGameResponse
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Tictactoe_TicTacToeAsyncProvider {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Tictactoe_TicTacToeServerMetadata.serviceDescriptor
  }

  public var serviceName: Substring {
    return Tictactoe_TicTacToeServerMetadata.serviceDescriptor.fullName[...]
  }

  public var interceptors: Tictactoe_TicTacToeServerInterceptorFactoryProtocol? {
    return nil
  }

  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "ConnectedMessage":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Tictactoe_ConnectMessageRequest>(),
        responseSerializer: ProtobufSerializer<Tictactoe_ConnectMessageResponse>(),
        interceptors: self.interceptors?.makeConnectedMessageInterceptors() ?? [],
        wrapping: { try await self.connectedMessage(request: $0, context: $1) }
      )

    case "StartGame":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Tictactoe_StartGameRequest>(),
        responseSerializer: ProtobufSerializer<Tictactoe_StartGameResponse>(),
        interceptors: self.interceptors?.makeStartGameInterceptors() ?? [],
        wrapping: { try await self.startGame(request: $0, context: $1) }
      )

    default:
      return nil
    }
  }
}

public protocol Tictactoe_TicTacToeServerInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when handling 'connectedMessage'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeConnectedMessageInterceptors() -> [ServerInterceptor<Tictactoe_ConnectMessageRequest, Tictactoe_ConnectMessageResponse>]

  /// - Returns: Interceptors to use when handling 'startGame'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeStartGameInterceptors() -> [ServerInterceptor<Tictactoe_StartGameRequest, Tictactoe_StartGameResponse>]
}

public enum Tictactoe_TicTacToeServerMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "TicTacToe",
    fullName: "tictactoe.TicTacToe",
    methods: [
      Tictactoe_TicTacToeServerMetadata.Methods.connectedMessage,
      Tictactoe_TicTacToeServerMetadata.Methods.startGame,
    ]
  )

  public enum Methods {
    public static let connectedMessage = GRPCMethodDescriptor(
      name: "ConnectedMessage",
      path: "/tictactoe.TicTacToe/ConnectedMessage",
      type: GRPCCallType.unary
    )

    public static let startGame = GRPCMethodDescriptor(
      name: "StartGame",
      path: "/tictactoe.TicTacToe/StartGame",
      type: GRPCCallType.unary
    )
  }
}
