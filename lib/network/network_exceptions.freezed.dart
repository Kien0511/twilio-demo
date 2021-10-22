// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'network_exceptions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$NetworkExceptionsTearOff {
  const _$NetworkExceptionsTearOff();

  UnauthorisedRequest unauthorisedRequest() {
    return const UnauthorisedRequest();
  }

  NoInternetConnection noInternetConnection() {
    return const NoInternetConnection();
  }

  InvalidateError invalidateError(dynamic error) {
    return InvalidateError(
      error,
    );
  }

  ServerExceptionError serverExceptionError(int code, String message) {
    return ServerExceptionError(
      code,
      message,
    );
  }

  DefaultError defaultError() {
    return const DefaultError();
  }
}

/// @nodoc
const $NetworkExceptions = _$NetworkExceptionsTearOff();

/// @nodoc
mixin _$NetworkExceptions {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorisedRequest,
    required TResult Function() noInternetConnection,
    required TResult Function(dynamic error) invalidateError,
    required TResult Function(int code, String message) serverExceptionError,
    required TResult Function() defaultError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorisedRequest,
    TResult Function()? noInternetConnection,
    TResult Function(dynamic error)? invalidateError,
    TResult Function(int code, String message)? serverExceptionError,
    TResult Function()? defaultError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnauthorisedRequest value) unauthorisedRequest,
    required TResult Function(NoInternetConnection value) noInternetConnection,
    required TResult Function(InvalidateError value) invalidateError,
    required TResult Function(ServerExceptionError value) serverExceptionError,
    required TResult Function(DefaultError value) defaultError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnauthorisedRequest value)? unauthorisedRequest,
    TResult Function(NoInternetConnection value)? noInternetConnection,
    TResult Function(InvalidateError value)? invalidateError,
    TResult Function(ServerExceptionError value)? serverExceptionError,
    TResult Function(DefaultError value)? defaultError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkExceptionsCopyWith<$Res> {
  factory $NetworkExceptionsCopyWith(
          NetworkExceptions value, $Res Function(NetworkExceptions) then) =
      _$NetworkExceptionsCopyWithImpl<$Res>;
}

/// @nodoc
class _$NetworkExceptionsCopyWithImpl<$Res>
    implements $NetworkExceptionsCopyWith<$Res> {
  _$NetworkExceptionsCopyWithImpl(this._value, this._then);

  final NetworkExceptions _value;
  // ignore: unused_field
  final $Res Function(NetworkExceptions) _then;
}

/// @nodoc
abstract class $UnauthorisedRequestCopyWith<$Res> {
  factory $UnauthorisedRequestCopyWith(
          UnauthorisedRequest value, $Res Function(UnauthorisedRequest) then) =
      _$UnauthorisedRequestCopyWithImpl<$Res>;
}

/// @nodoc
class _$UnauthorisedRequestCopyWithImpl<$Res>
    extends _$NetworkExceptionsCopyWithImpl<$Res>
    implements $UnauthorisedRequestCopyWith<$Res> {
  _$UnauthorisedRequestCopyWithImpl(
      UnauthorisedRequest _value, $Res Function(UnauthorisedRequest) _then)
      : super(_value, (v) => _then(v as UnauthorisedRequest));

  @override
  UnauthorisedRequest get _value => super._value as UnauthorisedRequest;
}

/// @nodoc

class _$UnauthorisedRequest
    with DiagnosticableTreeMixin
    implements UnauthorisedRequest {
  const _$UnauthorisedRequest();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NetworkExceptions.unauthorisedRequest()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
          DiagnosticsProperty('type', 'NetworkExceptions.unauthorisedRequest'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is UnauthorisedRequest);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorisedRequest,
    required TResult Function() noInternetConnection,
    required TResult Function(dynamic error) invalidateError,
    required TResult Function(int code, String message) serverExceptionError,
    required TResult Function() defaultError,
  }) {
    return unauthorisedRequest();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorisedRequest,
    TResult Function()? noInternetConnection,
    TResult Function(dynamic error)? invalidateError,
    TResult Function(int code, String message)? serverExceptionError,
    TResult Function()? defaultError,
    required TResult orElse(),
  }) {
    if (unauthorisedRequest != null) {
      return unauthorisedRequest();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnauthorisedRequest value) unauthorisedRequest,
    required TResult Function(NoInternetConnection value) noInternetConnection,
    required TResult Function(InvalidateError value) invalidateError,
    required TResult Function(ServerExceptionError value) serverExceptionError,
    required TResult Function(DefaultError value) defaultError,
  }) {
    return unauthorisedRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnauthorisedRequest value)? unauthorisedRequest,
    TResult Function(NoInternetConnection value)? noInternetConnection,
    TResult Function(InvalidateError value)? invalidateError,
    TResult Function(ServerExceptionError value)? serverExceptionError,
    TResult Function(DefaultError value)? defaultError,
    required TResult orElse(),
  }) {
    if (unauthorisedRequest != null) {
      return unauthorisedRequest(this);
    }
    return orElse();
  }
}

abstract class UnauthorisedRequest implements NetworkExceptions {
  const factory UnauthorisedRequest() = _$UnauthorisedRequest;
}

/// @nodoc
abstract class $NoInternetConnectionCopyWith<$Res> {
  factory $NoInternetConnectionCopyWith(NoInternetConnection value,
          $Res Function(NoInternetConnection) then) =
      _$NoInternetConnectionCopyWithImpl<$Res>;
}

/// @nodoc
class _$NoInternetConnectionCopyWithImpl<$Res>
    extends _$NetworkExceptionsCopyWithImpl<$Res>
    implements $NoInternetConnectionCopyWith<$Res> {
  _$NoInternetConnectionCopyWithImpl(
      NoInternetConnection _value, $Res Function(NoInternetConnection) _then)
      : super(_value, (v) => _then(v as NoInternetConnection));

  @override
  NoInternetConnection get _value => super._value as NoInternetConnection;
}

/// @nodoc

class _$NoInternetConnection
    with DiagnosticableTreeMixin
    implements NoInternetConnection {
  const _$NoInternetConnection();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NetworkExceptions.noInternetConnection()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'NetworkExceptions.noInternetConnection'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is NoInternetConnection);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorisedRequest,
    required TResult Function() noInternetConnection,
    required TResult Function(dynamic error) invalidateError,
    required TResult Function(int code, String message) serverExceptionError,
    required TResult Function() defaultError,
  }) {
    return noInternetConnection();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorisedRequest,
    TResult Function()? noInternetConnection,
    TResult Function(dynamic error)? invalidateError,
    TResult Function(int code, String message)? serverExceptionError,
    TResult Function()? defaultError,
    required TResult orElse(),
  }) {
    if (noInternetConnection != null) {
      return noInternetConnection();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnauthorisedRequest value) unauthorisedRequest,
    required TResult Function(NoInternetConnection value) noInternetConnection,
    required TResult Function(InvalidateError value) invalidateError,
    required TResult Function(ServerExceptionError value) serverExceptionError,
    required TResult Function(DefaultError value) defaultError,
  }) {
    return noInternetConnection(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnauthorisedRequest value)? unauthorisedRequest,
    TResult Function(NoInternetConnection value)? noInternetConnection,
    TResult Function(InvalidateError value)? invalidateError,
    TResult Function(ServerExceptionError value)? serverExceptionError,
    TResult Function(DefaultError value)? defaultError,
    required TResult orElse(),
  }) {
    if (noInternetConnection != null) {
      return noInternetConnection(this);
    }
    return orElse();
  }
}

abstract class NoInternetConnection implements NetworkExceptions {
  const factory NoInternetConnection() = _$NoInternetConnection;
}

/// @nodoc
abstract class $InvalidateErrorCopyWith<$Res> {
  factory $InvalidateErrorCopyWith(
          InvalidateError value, $Res Function(InvalidateError) then) =
      _$InvalidateErrorCopyWithImpl<$Res>;
  $Res call({dynamic error});
}

/// @nodoc
class _$InvalidateErrorCopyWithImpl<$Res>
    extends _$NetworkExceptionsCopyWithImpl<$Res>
    implements $InvalidateErrorCopyWith<$Res> {
  _$InvalidateErrorCopyWithImpl(
      InvalidateError _value, $Res Function(InvalidateError) _then)
      : super(_value, (v) => _then(v as InvalidateError));

  @override
  InvalidateError get _value => super._value as InvalidateError;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(InvalidateError(
      error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$InvalidateError
    with DiagnosticableTreeMixin
    implements InvalidateError {
  const _$InvalidateError(this.error);

  @override
  final dynamic error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NetworkExceptions.invalidateError(error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NetworkExceptions.invalidateError'))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is InvalidateError &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $InvalidateErrorCopyWith<InvalidateError> get copyWith =>
      _$InvalidateErrorCopyWithImpl<InvalidateError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorisedRequest,
    required TResult Function() noInternetConnection,
    required TResult Function(dynamic error) invalidateError,
    required TResult Function(int code, String message) serverExceptionError,
    required TResult Function() defaultError,
  }) {
    return invalidateError(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorisedRequest,
    TResult Function()? noInternetConnection,
    TResult Function(dynamic error)? invalidateError,
    TResult Function(int code, String message)? serverExceptionError,
    TResult Function()? defaultError,
    required TResult orElse(),
  }) {
    if (invalidateError != null) {
      return invalidateError(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnauthorisedRequest value) unauthorisedRequest,
    required TResult Function(NoInternetConnection value) noInternetConnection,
    required TResult Function(InvalidateError value) invalidateError,
    required TResult Function(ServerExceptionError value) serverExceptionError,
    required TResult Function(DefaultError value) defaultError,
  }) {
    return invalidateError(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnauthorisedRequest value)? unauthorisedRequest,
    TResult Function(NoInternetConnection value)? noInternetConnection,
    TResult Function(InvalidateError value)? invalidateError,
    TResult Function(ServerExceptionError value)? serverExceptionError,
    TResult Function(DefaultError value)? defaultError,
    required TResult orElse(),
  }) {
    if (invalidateError != null) {
      return invalidateError(this);
    }
    return orElse();
  }
}

abstract class InvalidateError implements NetworkExceptions {
  const factory InvalidateError(dynamic error) = _$InvalidateError;

  dynamic get error => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvalidateErrorCopyWith<InvalidateError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerExceptionErrorCopyWith<$Res> {
  factory $ServerExceptionErrorCopyWith(ServerExceptionError value,
          $Res Function(ServerExceptionError) then) =
      _$ServerExceptionErrorCopyWithImpl<$Res>;
  $Res call({int code, String message});
}

/// @nodoc
class _$ServerExceptionErrorCopyWithImpl<$Res>
    extends _$NetworkExceptionsCopyWithImpl<$Res>
    implements $ServerExceptionErrorCopyWith<$Res> {
  _$ServerExceptionErrorCopyWithImpl(
      ServerExceptionError _value, $Res Function(ServerExceptionError) _then)
      : super(_value, (v) => _then(v as ServerExceptionError));

  @override
  ServerExceptionError get _value => super._value as ServerExceptionError;

  @override
  $Res call({
    Object? code = freezed,
    Object? message = freezed,
  }) {
    return _then(ServerExceptionError(
      code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ServerExceptionError
    with DiagnosticableTreeMixin
    implements ServerExceptionError {
  const _$ServerExceptionError(this.code, this.message);

  @override
  final int code;
  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NetworkExceptions.serverExceptionError(code: $code, message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
          DiagnosticsProperty('type', 'NetworkExceptions.serverExceptionError'))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ServerExceptionError &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(code) ^
      const DeepCollectionEquality().hash(message);

  @JsonKey(ignore: true)
  @override
  $ServerExceptionErrorCopyWith<ServerExceptionError> get copyWith =>
      _$ServerExceptionErrorCopyWithImpl<ServerExceptionError>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorisedRequest,
    required TResult Function() noInternetConnection,
    required TResult Function(dynamic error) invalidateError,
    required TResult Function(int code, String message) serverExceptionError,
    required TResult Function() defaultError,
  }) {
    return serverExceptionError(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorisedRequest,
    TResult Function()? noInternetConnection,
    TResult Function(dynamic error)? invalidateError,
    TResult Function(int code, String message)? serverExceptionError,
    TResult Function()? defaultError,
    required TResult orElse(),
  }) {
    if (serverExceptionError != null) {
      return serverExceptionError(code, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnauthorisedRequest value) unauthorisedRequest,
    required TResult Function(NoInternetConnection value) noInternetConnection,
    required TResult Function(InvalidateError value) invalidateError,
    required TResult Function(ServerExceptionError value) serverExceptionError,
    required TResult Function(DefaultError value) defaultError,
  }) {
    return serverExceptionError(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnauthorisedRequest value)? unauthorisedRequest,
    TResult Function(NoInternetConnection value)? noInternetConnection,
    TResult Function(InvalidateError value)? invalidateError,
    TResult Function(ServerExceptionError value)? serverExceptionError,
    TResult Function(DefaultError value)? defaultError,
    required TResult orElse(),
  }) {
    if (serverExceptionError != null) {
      return serverExceptionError(this);
    }
    return orElse();
  }
}

abstract class ServerExceptionError implements NetworkExceptions {
  const factory ServerExceptionError(int code, String message) =
      _$ServerExceptionError;

  int get code => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServerExceptionErrorCopyWith<ServerExceptionError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefaultErrorCopyWith<$Res> {
  factory $DefaultErrorCopyWith(
          DefaultError value, $Res Function(DefaultError) then) =
      _$DefaultErrorCopyWithImpl<$Res>;
}

/// @nodoc
class _$DefaultErrorCopyWithImpl<$Res>
    extends _$NetworkExceptionsCopyWithImpl<$Res>
    implements $DefaultErrorCopyWith<$Res> {
  _$DefaultErrorCopyWithImpl(
      DefaultError _value, $Res Function(DefaultError) _then)
      : super(_value, (v) => _then(v as DefaultError));

  @override
  DefaultError get _value => super._value as DefaultError;
}

/// @nodoc

class _$DefaultError with DiagnosticableTreeMixin implements DefaultError {
  const _$DefaultError();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NetworkExceptions.defaultError()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NetworkExceptions.defaultError'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is DefaultError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorisedRequest,
    required TResult Function() noInternetConnection,
    required TResult Function(dynamic error) invalidateError,
    required TResult Function(int code, String message) serverExceptionError,
    required TResult Function() defaultError,
  }) {
    return defaultError();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorisedRequest,
    TResult Function()? noInternetConnection,
    TResult Function(dynamic error)? invalidateError,
    TResult Function(int code, String message)? serverExceptionError,
    TResult Function()? defaultError,
    required TResult orElse(),
  }) {
    if (defaultError != null) {
      return defaultError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnauthorisedRequest value) unauthorisedRequest,
    required TResult Function(NoInternetConnection value) noInternetConnection,
    required TResult Function(InvalidateError value) invalidateError,
    required TResult Function(ServerExceptionError value) serverExceptionError,
    required TResult Function(DefaultError value) defaultError,
  }) {
    return defaultError(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnauthorisedRequest value)? unauthorisedRequest,
    TResult Function(NoInternetConnection value)? noInternetConnection,
    TResult Function(InvalidateError value)? invalidateError,
    TResult Function(ServerExceptionError value)? serverExceptionError,
    TResult Function(DefaultError value)? defaultError,
    required TResult orElse(),
  }) {
    if (defaultError != null) {
      return defaultError(this);
    }
    return orElse();
  }
}

abstract class DefaultError implements NetworkExceptions {
  const factory DefaultError() = _$DefaultError;
}
