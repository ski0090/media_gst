// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_instance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent()';
}


}

/// @nodoc
class $PlayerEventCopyWith<$Res>  {
$PlayerEventCopyWith(PlayerEvent _, $Res Function(PlayerEvent) __);
}


/// Adds pattern-matching-related methods to [PlayerEvent].
extension PlayerEventPatterns on PlayerEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PlayerEvent_StateChanged value)?  stateChanged,TResult Function( PlayerEvent_Error value)?  error,TResult Function( PlayerEvent_EndOfStream value)?  endOfStream,TResult Function( PlayerEvent_Buffering value)?  buffering,TResult Function( PlayerEvent_ClockLost value)?  clockLost,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PlayerEvent_StateChanged() when stateChanged != null:
return stateChanged(_that);case PlayerEvent_Error() when error != null:
return error(_that);case PlayerEvent_EndOfStream() when endOfStream != null:
return endOfStream(_that);case PlayerEvent_Buffering() when buffering != null:
return buffering(_that);case PlayerEvent_ClockLost() when clockLost != null:
return clockLost(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PlayerEvent_StateChanged value)  stateChanged,required TResult Function( PlayerEvent_Error value)  error,required TResult Function( PlayerEvent_EndOfStream value)  endOfStream,required TResult Function( PlayerEvent_Buffering value)  buffering,required TResult Function( PlayerEvent_ClockLost value)  clockLost,}){
final _that = this;
switch (_that) {
case PlayerEvent_StateChanged():
return stateChanged(_that);case PlayerEvent_Error():
return error(_that);case PlayerEvent_EndOfStream():
return endOfStream(_that);case PlayerEvent_Buffering():
return buffering(_that);case PlayerEvent_ClockLost():
return clockLost(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PlayerEvent_StateChanged value)?  stateChanged,TResult? Function( PlayerEvent_Error value)?  error,TResult? Function( PlayerEvent_EndOfStream value)?  endOfStream,TResult? Function( PlayerEvent_Buffering value)?  buffering,TResult? Function( PlayerEvent_ClockLost value)?  clockLost,}){
final _that = this;
switch (_that) {
case PlayerEvent_StateChanged() when stateChanged != null:
return stateChanged(_that);case PlayerEvent_Error() when error != null:
return error(_that);case PlayerEvent_EndOfStream() when endOfStream != null:
return endOfStream(_that);case PlayerEvent_Buffering() when buffering != null:
return buffering(_that);case PlayerEvent_ClockLost() when clockLost != null:
return clockLost(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PlayerState field0)?  stateChanged,TResult Function( String field0)?  error,TResult Function()?  endOfStream,TResult Function( int field0)?  buffering,TResult Function()?  clockLost,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PlayerEvent_StateChanged() when stateChanged != null:
return stateChanged(_that.field0);case PlayerEvent_Error() when error != null:
return error(_that.field0);case PlayerEvent_EndOfStream() when endOfStream != null:
return endOfStream();case PlayerEvent_Buffering() when buffering != null:
return buffering(_that.field0);case PlayerEvent_ClockLost() when clockLost != null:
return clockLost();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PlayerState field0)  stateChanged,required TResult Function( String field0)  error,required TResult Function()  endOfStream,required TResult Function( int field0)  buffering,required TResult Function()  clockLost,}) {final _that = this;
switch (_that) {
case PlayerEvent_StateChanged():
return stateChanged(_that.field0);case PlayerEvent_Error():
return error(_that.field0);case PlayerEvent_EndOfStream():
return endOfStream();case PlayerEvent_Buffering():
return buffering(_that.field0);case PlayerEvent_ClockLost():
return clockLost();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PlayerState field0)?  stateChanged,TResult? Function( String field0)?  error,TResult? Function()?  endOfStream,TResult? Function( int field0)?  buffering,TResult? Function()?  clockLost,}) {final _that = this;
switch (_that) {
case PlayerEvent_StateChanged() when stateChanged != null:
return stateChanged(_that.field0);case PlayerEvent_Error() when error != null:
return error(_that.field0);case PlayerEvent_EndOfStream() when endOfStream != null:
return endOfStream();case PlayerEvent_Buffering() when buffering != null:
return buffering(_that.field0);case PlayerEvent_ClockLost() when clockLost != null:
return clockLost();case _:
  return null;

}
}

}

/// @nodoc


class PlayerEvent_StateChanged extends PlayerEvent {
  const PlayerEvent_StateChanged(this.field0): super._();
  

 final  PlayerState field0;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerEvent_StateChangedCopyWith<PlayerEvent_StateChanged> get copyWith => _$PlayerEvent_StateChangedCopyWithImpl<PlayerEvent_StateChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerEvent_StateChanged&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'PlayerEvent.stateChanged(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $PlayerEvent_StateChangedCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerEvent_StateChangedCopyWith(PlayerEvent_StateChanged value, $Res Function(PlayerEvent_StateChanged) _then) = _$PlayerEvent_StateChangedCopyWithImpl;
@useResult
$Res call({
 PlayerState field0
});




}
/// @nodoc
class _$PlayerEvent_StateChangedCopyWithImpl<$Res>
    implements $PlayerEvent_StateChangedCopyWith<$Res> {
  _$PlayerEvent_StateChangedCopyWithImpl(this._self, this._then);

  final PlayerEvent_StateChanged _self;
  final $Res Function(PlayerEvent_StateChanged) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(PlayerEvent_StateChanged(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as PlayerState,
  ));
}


}

/// @nodoc


class PlayerEvent_Error extends PlayerEvent {
  const PlayerEvent_Error(this.field0): super._();
  

 final  String field0;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerEvent_ErrorCopyWith<PlayerEvent_Error> get copyWith => _$PlayerEvent_ErrorCopyWithImpl<PlayerEvent_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerEvent_Error&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'PlayerEvent.error(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $PlayerEvent_ErrorCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerEvent_ErrorCopyWith(PlayerEvent_Error value, $Res Function(PlayerEvent_Error) _then) = _$PlayerEvent_ErrorCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$PlayerEvent_ErrorCopyWithImpl<$Res>
    implements $PlayerEvent_ErrorCopyWith<$Res> {
  _$PlayerEvent_ErrorCopyWithImpl(this._self, this._then);

  final PlayerEvent_Error _self;
  final $Res Function(PlayerEvent_Error) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(PlayerEvent_Error(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PlayerEvent_EndOfStream extends PlayerEvent {
  const PlayerEvent_EndOfStream(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerEvent_EndOfStream);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.endOfStream()';
}


}




/// @nodoc


class PlayerEvent_Buffering extends PlayerEvent {
  const PlayerEvent_Buffering(this.field0): super._();
  

 final  int field0;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerEvent_BufferingCopyWith<PlayerEvent_Buffering> get copyWith => _$PlayerEvent_BufferingCopyWithImpl<PlayerEvent_Buffering>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerEvent_Buffering&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'PlayerEvent.buffering(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $PlayerEvent_BufferingCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerEvent_BufferingCopyWith(PlayerEvent_Buffering value, $Res Function(PlayerEvent_Buffering) _then) = _$PlayerEvent_BufferingCopyWithImpl;
@useResult
$Res call({
 int field0
});




}
/// @nodoc
class _$PlayerEvent_BufferingCopyWithImpl<$Res>
    implements $PlayerEvent_BufferingCopyWith<$Res> {
  _$PlayerEvent_BufferingCopyWithImpl(this._self, this._then);

  final PlayerEvent_Buffering _self;
  final $Res Function(PlayerEvent_Buffering) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(PlayerEvent_Buffering(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PlayerEvent_ClockLost extends PlayerEvent {
  const PlayerEvent_ClockLost(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerEvent_ClockLost);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.clockLost()';
}


}




// dart format on
