import 'package:core_fe_dart/src/validations/validatable_object.dart';
import 'package:meta/meta.dart';

/// The validation Rule orchestrator that adds validations to the [_validatableObjectList]
abstract class ValidationCommandBase<T> {
  /// Instialize Command
  /// [validatableObjectList]: Validatable object that validations is wanted to be added on'
  /// [excuteCallBack]: callback that defines the validations logic
  /// [isAutoExcute]: allow adding validations on [command] creation?
  /// ```
  /// class PhoneNumberValidationCommand extends ValidationCommandBase<String> {
  ///   PhoneNumberValidationCommand(
  ///       Iterable<ValidatableObject<String>> validatableObjectList)
  ///       : super(
  ///             validatableObjectList: validatableObjectList,
  ///             excuteCallBack: (v) {
  ///               v.clear();
  ///
  ///               v.add(
  ///                 IsNotNullEmptyWhitespaceRule<String>.fromMessage(
  ///                     validationMessage: 'Please Enter phone number'),
  ///               );
  ///
  ///               v.add(
  ///                 IsValidPhoneNumberRule.fromMessage(
  ///                     validationMessage: 'Invalid phone number'),
  ///               );
  ///             });
  /// }
  /// ```
  /// [ref close to this in xamarin]: https://docs.microsoft.com/en-us/xamarin/xamarin-forms/enterprise-application-patterns/validation
  ValidationCommandBase(
      {@required Iterable<ValidatableObject<T>> validatableObjectList,
      @required void Function(ValidatableObject<T>) excuteCallBack,
      bool isAutoExcute = false})
      : _validatableObjectList = validatableObjectList,
        _excuteCallBack = excuteCallBack {
    if (isAutoExcute) {
      excute();
    }
  }

  final Iterable<ValidatableObject<T>> _validatableObjectList;
  final void Function(ValidatableObject<T>) _excuteCallBack;

  /// Adds Validation Rulles to the [_validatableObjectList].
  void excute() {
    _validatableObjectList.forEach(_excuteCallBack);
  }
}
