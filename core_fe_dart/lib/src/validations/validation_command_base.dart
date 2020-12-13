import 'package:core_fe_dart/src/validations/validatable_object.dart';
import 'package:meta/meta.dart';

/// The validation Rule orchestrator that adds validations to the [validatableObject]
abstract class ValidationCommandBase<T> {
  /// Instialize Command
  /// [validatableObject]: Validatable object that validations is wanted to be added on'
  /// [excuteCallBack]: callback that defines the validations logic
  /// [autoExcute]: allow adding validations on [command] creation?
  /// ```
  /// class PhoneNumberValidationCommand extends ValidationCommandBase<String> {
  ///   PhoneNumberValidationCommand(ValidatableObject<String> validatableObject)
  ///       : super(
  ///             validatableObject: validatableObject,
  ///             excuteCallBack: () {
  ///               validatableObject.clear();
  ///
  ///               validatableObject.add(
  ///                 IsNotNullEmptyWhitespaceStringRule.fromMessage(
  ///                     validationMessage: 'Please Enter phone number'),
  ///               );
  ///
  ///               validatableObject.add(
  ///                 IsValidPhoneNumberRule.fromMessage(
  ///                     validationMessage: 'Invalid phone number'),
  ///               );
  ///             });
  /// }
  /// ```
  /// [ref close to this in xamarin]: https://docs.microsoft.com/en-us/xamarin/xamarin-forms/enterprise-application-patterns/validation
  ValidationCommandBase(
      {@required this.validatableObject,
      @required void Function() excuteCallBack,
      bool autoExcute = false})
      : _excuteCallBack = excuteCallBack {
    if (autoExcute) {
      excute();
    }
  }
  final ValidatableObject<T> validatableObject;
  final void Function() _excuteCallBack;

  /// Adds Validation Rulles to the [validatableObject].
  void excute() => _excuteCallBack();
}
