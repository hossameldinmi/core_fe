import 'package:core_fe_dart/src/validations/validator_object.dart';
import 'package:meta/meta.dart';

/// The validation Rule orchestrator that adds validations to the [validatorObject]
abstract class ValidationCommandBase<T> {
  /// Instialize Command
  /// [validatorObject]: Validator object that validations is wanted to be added on'
  /// [excuteCallBack]: callback that defines the validations logic
  /// [autoExcute]: allow adding validations on [command] creation?
  /// ```
  /// class PhoneNumberValidationCommand extends ValidationCommandBase<String> {
  ///   PhoneNumberValidationCommand(ValidatorObject<String> validatorObject)
  ///       : super(
  ///             validatorObject: validatorObject,
  ///             excuteCallBack: () {
  ///               ValidatorObject.clear();
  ///
  ///               ValidatorObject.add(
  ///                 IsNotNullEmptyWhitespaceStringRule.fromMessage(
  ///                     validationMessage: 'Please Enter phone number'),
  ///               );
  ///
  ///               ValidatorObject.add(
  ///                 IsValidPhoneNumberRule.fromMessage(
  ///                     validationMessage: 'Invalid phone number'),
  ///               );
  ///             });
  /// }
  /// ```
  /// [ref close to this in xamarin]: https://docs.microsoft.com/en-us/xamarin/xamarin-forms/enterprise-application-patterns/validation
  ValidationCommandBase(
      {@required this.validatorObject,
      @required void Function() excuteCallBack,
      bool autoExcute = false})
      : _excuteCallBack = excuteCallBack {
    if (autoExcute) {
      excute();
    }
  }
  final ValidatorObject<T> validatorObject;
  final void Function() _excuteCallBack;

  /// Adds Validation Rulles to the [ValidatorObject].
  void excute() => _excuteCallBack();
}
