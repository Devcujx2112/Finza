import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Finza'**
  String get appName;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get totalBalance;

  /// No description provided for @introduction.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Expense Manager Finza'**
  String get introduction;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @goHomePage.
  ///
  /// In en, this message translates to:
  /// **'Homepage'**
  String get goHomePage;

  /// No description provided for @introductionSecond.
  ///
  /// In en, this message translates to:
  /// **'One place to manage your time and finances'**
  String get introductionSecond;

  /// No description provided for @homePage.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homePage;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @textSignature.
  ///
  /// In en, this message translates to:
  /// **'Balance your time. Balance your life.'**
  String get textSignature;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @tryAccount.
  ///
  /// In en, this message translates to:
  /// **'Try it for 3 days'**
  String get tryAccount;

  /// No description provided for @wellCome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get wellCome;

  /// No description provided for @phoneNumberOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Phone number or email'**
  String get phoneNumberOrEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @eitherLogin.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get eitherLogin;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @exampleEmail.
  ///
  /// In en, this message translates to:
  /// **'example@example.com'**
  String get exampleEmail;

  /// No description provided for @validatorUserName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number or email'**
  String get validatorUserName;

  /// No description provided for @validatorPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get validatorPassword;

  /// No description provided for @validatorSpecialCharacters.
  ///
  /// In en, this message translates to:
  /// **'Cannot contain special characters'**
  String get validatorSpecialCharacters;

  /// No description provided for @validatorEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or phone number'**
  String get validatorEmailOrPhone;

  /// No description provided for @validatorPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get validatorPasswordLength;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember password'**
  String get rememberPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailName.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @exampleFullName.
  ///
  /// In en, this message translates to:
  /// **'Vu Tung Duong'**
  String get exampleFullName;

  /// No description provided for @exampleDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get exampleDateOfBirth;

  /// No description provided for @confirmAccount.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to'**
  String get confirmAccount;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @enterYourEmailOrPhoneToReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to reset your password'**
  String get enterYourEmailOrPhoneToReset;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @securityPin.
  ///
  /// In en, this message translates to:
  /// **'Security Pin'**
  String get securityPin;

  /// No description provided for @enterTheCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Security PIN'**
  String get enterTheCode;

  /// No description provided for @enterTheCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the Security PIN sent to your Email or Phone Number'**
  String get enterTheCodeSentTo;

  /// No description provided for @acceptPin.
  ///
  /// In en, this message translates to:
  /// **'Accept Pin'**
  String get acceptPin;

  /// No description provided for @didNotReceivePin.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive pin?'**
  String get didNotReceivePin;

  /// No description provided for @resendPin.
  ///
  /// In en, this message translates to:
  /// **'Resend Pin'**
  String get resendPin;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @selectCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Select Country Code'**
  String get selectCountryCode;

  /// No description provided for @validatorFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get validatorFullName;

  /// No description provided for @validatorDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get validatorDateOfBirth;

  /// No description provided for @validatorPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validatorPasswordConfirm;

  /// No description provided for @createAccountIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Join Finza today and start managing your finances better.'**
  String get createAccountIntroduction;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign up successfully'**
  String get signupSuccess;

  /// No description provided for @signupError.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed'**
  String get signupError;

  /// No description provided for @errorOccurredPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again'**
  String get errorOccurredPleaseTryAgain;

  /// No description provided for @connectionTimeoutPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout, please try again'**
  String get connectionTimeoutPleaseTryAgain;

  /// No description provided for @noNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please try again.'**
  String get noNetworkConnection;

  /// No description provided for @requestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get requestCancelled;

  /// No description provided for @invalidData.
  ///
  /// In en, this message translates to:
  /// **'Invalid data'**
  String get invalidData;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get sessionExpired;

  /// No description provided for @unauthorizedAction.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action'**
  String get unauthorizedAction;

  /// No description provided for @dataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Data not found'**
  String get dataNotFound;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists, please try another email'**
  String get emailAlreadyExists;

  /// No description provided for @invalidDataFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid data format'**
  String get invalidDataFormat;

  /// No description provided for @serverErrorPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Server error, please try again later'**
  String get serverErrorPleaseTryAgainLater;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @validatorFormSignUp.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all the information'**
  String get validatorFormSignUp;

  /// No description provided for @errorLoginGoogle.
  ///
  /// In en, this message translates to:
  /// **'Error logging in with Google, please try again'**
  String get errorLoginGoogle;

  /// No description provided for @errorLoginFacebook.
  ///
  /// In en, this message translates to:
  /// **'Error logging in with Facebook, please try again'**
  String get errorLoginFacebook;

  /// No description provided for @phoneNotNull.
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot be empty'**
  String get phoneNotNull;

  /// No description provided for @phoneIsNotCorrect.
  ///
  /// In en, this message translates to:
  /// **'Phone number is not correct'**
  String get phoneIsNotCorrect;

  /// No description provided for @emailIsNotCorrect.
  ///
  /// In en, this message translates to:
  /// **'Email is not correct'**
  String get emailIsNotCorrect;

  /// No description provided for @sendOtpFailed.
  ///
  /// In en, this message translates to:
  /// **'Send OTP failed, please try again'**
  String get sendOtpFailed;

  /// No description provided for @inputYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address of the account to be recovered'**
  String get inputYourEmail;

  /// No description provided for @resendOtpSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP successfully resent, please check your email'**
  String get resendOtpSuccess;

  /// No description provided for @resendOtpLimit.
  ///
  /// In en, this message translates to:
  /// **'You have exceeded the allowed number of attempts; please try again later'**
  String get resendOtpLimit;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Incorrect OTP, please try again.'**
  String get invalidOtp;

  /// No description provided for @verifyOtpSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP authentication successful.'**
  String get verifyOtpSuccess;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password; please try again'**
  String get changePasswordFail;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting;

  /// No description provided for @loginFaceId.
  ///
  /// In en, this message translates to:
  /// **'Login with Face ID'**
  String get loginFaceId;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @chatWithAI.
  ///
  /// In en, this message translates to:
  /// **'Chat with AI'**
  String get chatWithAI;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @autoTimezone.
  ///
  /// In en, this message translates to:
  /// **'Automatic timezone'**
  String get autoTimezone;

  /// No description provided for @timezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezone;

  /// No description provided for @format12h24h.
  ///
  /// In en, this message translates to:
  /// **'12h/24h format'**
  String get format12h24h;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @finzaAppTagline.
  ///
  /// In en, this message translates to:
  /// **'Finza App'**
  String get finzaAppTagline;

  /// No description provided for @smartManagementTagline.
  ///
  /// In en, this message translates to:
  /// **'Smart Management'**
  String get smartManagementTagline;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @trialAccountCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Trial account creation failed'**
  String get trialAccountCreationFailed;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// No description provided for @spendingProgress.
  ///
  /// In en, this message translates to:
  /// **'Spending Progress'**
  String get spendingProgress;

  /// No description provided for @spendingProgressNotice.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of your expenses. Looks good.'**
  String spendingProgressNotice(Object percent);

  /// No description provided for @itemsPlannedToday.
  ///
  /// In en, this message translates to:
  /// **'{count} items planned today'**
  String itemsPlannedToday(Object count);

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @agenda.
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get agenda;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @personalFinanceTracking.
  ///
  /// In en, this message translates to:
  /// **'Personal finance tracking'**
  String get personalFinanceTracking;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @spendingHistory.
  ///
  /// In en, this message translates to:
  /// **'Spending History'**
  String get spendingHistory;

  /// No description provided for @transactionsInMonth.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions this month'**
  String transactionsInMonth(Object count);

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteExpenseMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete expense \"{note}\"?'**
  String confirmDeleteExpenseMessage(Object note);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @expenseDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{note}\"'**
  String expenseDeletedMessage(Object note);

  /// No description provided for @changeMonthlyBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Monthly Budget'**
  String get changeMonthlyBudgetTitle;

  /// No description provided for @budgetAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget Amount (₫)'**
  String get budgetAmountLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Lunch, ride, shopping...'**
  String get noteHint;

  /// No description provided for @invalidAmountError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get invalidAmountError;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save Expense'**
  String get saveExpense;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpensesYet;

  /// No description provided for @addExpensePrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap + below to add an expense'**
  String get addExpensePrompt;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar & Schedule'**
  String get scheduleTitle;

  /// No description provided for @scheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage schedule & reminders'**
  String get scheduleSubtitle;

  /// No description provided for @monthFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'Month {monthYear}'**
  String monthFormatLabel(Object monthYear);

  /// No description provided for @reminderCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reminders'**
  String reminderCount(Object count);

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @reminderDeleted.
  ///
  /// In en, this message translates to:
  /// **'Reminder deleted'**
  String get reminderDeleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @noScheduleToday.
  ///
  /// In en, this message translates to:
  /// **'No schedule today'**
  String get noScheduleToday;

  /// No description provided for @noSchedulePrompt.
  ///
  /// In en, this message translates to:
  /// **'Your schedule is clear.\nAdd a reminder to stay on track.'**
  String get noSchedulePrompt;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get addReminder;

  /// No description provided for @editReminder.
  ///
  /// In en, this message translates to:
  /// **'Edit Reminder'**
  String get editReminder;

  /// No description provided for @reminderName.
  ///
  /// In en, this message translates to:
  /// **'Reminder Title'**
  String get reminderName;

  /// No description provided for @reminderNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Team meeting'**
  String get reminderNameHint;

  /// No description provided for @tenMinutesBefore.
  ///
  /// In en, this message translates to:
  /// **'10 minutes before'**
  String get tenMinutesBefore;

  /// No description provided for @noRepeat.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get noRepeat;

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind Me'**
  String get remindMe;

  /// No description provided for @onTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get onTime;

  /// No description provided for @fiveMinutesBefore.
  ///
  /// In en, this message translates to:
  /// **'5 minutes before'**
  String get fiveMinutesBefore;

  /// No description provided for @fifteenMinutesBefore.
  ///
  /// In en, this message translates to:
  /// **'15 minutes before'**
  String get fifteenMinutesBefore;

  /// No description provided for @thirtyMinutesBefore.
  ///
  /// In en, this message translates to:
  /// **'30 minutes before'**
  String get thirtyMinutesBefore;

  /// No description provided for @oneHourBefore.
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get oneHourBefore;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (Optional)'**
  String get noteOptional;

  /// No description provided for @addDetailedNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add detailed notes...'**
  String get addDetailedNoteHint;

  /// No description provided for @saveReminder.
  ///
  /// In en, this message translates to:
  /// **'Save Reminder'**
  String get saveReminder;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @notDone.
  ///
  /// In en, this message translates to:
  /// **'Not done'**
  String get notDone;

  /// No description provided for @sendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get sendNotification;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @setupBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get setupBack;

  /// No description provided for @setupContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get setupContinue;

  /// No description provided for @setupFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get setupFinish;

  /// No description provided for @setupMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'How would you like to manage your spending?'**
  String get setupMethodTitle;

  /// No description provided for @setupMethodDescription.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in settings.'**
  String get setupMethodDescription;

  /// No description provided for @setupMethodAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending analysis'**
  String get setupMethodAnalyticsTitle;

  /// No description provided for @setupMethodAnalyticsDescription.
  ///
  /// In en, this message translates to:
  /// **'Record what you spend each day, then see reports and statistics over time.'**
  String get setupMethodAnalyticsDescription;

  /// No description provided for @setupMethodBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget management'**
  String get setupMethodBudgetTitle;

  /// No description provided for @setupMethodBudgetDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a spending budget and a saving goal, and get a heads up before you reach the limit.'**
  String get setupMethodBudgetDescription;

  /// No description provided for @setupAnalyticsCycleTitle.
  ///
  /// In en, this message translates to:
  /// **'Which day of the month should the reporting cycle start on?'**
  String get setupAnalyticsCycleTitle;

  /// No description provided for @setupAnalyticsCycleDescription.
  ///
  /// In en, this message translates to:
  /// **'This is the day a new reporting cycle begins.'**
  String get setupAnalyticsCycleDescription;

  /// No description provided for @setupIncomeDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Which day of the month do you usually receive most of your income?'**
  String get setupIncomeDayTitle;

  /// No description provided for @setupIncomeDayDescription.
  ///
  /// In en, this message translates to:
  /// **'This day starts each new budget cycle.'**
  String get setupIncomeDayDescription;

  /// No description provided for @setupDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String setupDayLabel(String day);

  /// No description provided for @setupLastDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Last day of the month'**
  String get setupLastDayOfMonth;

  /// No description provided for @setupCustomDay.
  ///
  /// In en, this message translates to:
  /// **'Pick a day'**
  String get setupCustomDay;

  /// No description provided for @setupCustomDayHint.
  ///
  /// In en, this message translates to:
  /// **'Days 29 to 31 move to the last day in shorter months.'**
  String get setupCustomDayHint;

  /// No description provided for @setupIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your total monthly income?'**
  String get setupIncomeTitle;

  /// No description provided for @setupIncomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Include your salary and any other regular income.'**
  String get setupIncomeDescription;

  /// No description provided for @setupIncomeFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly income'**
  String get setupIncomeFieldLabel;

  /// No description provided for @setupSavingTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you want a monthly saving goal?'**
  String get setupSavingTitle;

  /// No description provided for @setupSavingDescription.
  ///
  /// In en, this message translates to:
  /// **'You can add one later if you are not sure yet.'**
  String get setupSavingDescription;

  /// No description provided for @setupSavingSkip.
  ///
  /// In en, this message translates to:
  /// **'Not right now'**
  String get setupSavingSkip;

  /// No description provided for @setupSavingEnable.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get setupSavingEnable;

  /// No description provided for @setupSavingAmountTitle.
  ///
  /// In en, this message translates to:
  /// **'How much do you want to save each month?'**
  String get setupSavingAmountTitle;

  /// No description provided for @setupSavingCustom.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get setupSavingCustom;

  /// No description provided for @setupSavingFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving goal'**
  String get setupSavingFieldLabel;

  /// No description provided for @setupFixedTitle.
  ///
  /// In en, this message translates to:
  /// **'Which fixed costs do you have each month?'**
  String get setupFixedTitle;

  /// No description provided for @setupFixedDescription.
  ///
  /// In en, this message translates to:
  /// **'These are the costs that come back in almost every cycle.'**
  String get setupFixedDescription;

  /// No description provided for @setupFixedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No fixed costs yet'**
  String get setupFixedEmptyTitle;

  /// No description provided for @setupFixedEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Rent, utilities, internet, installments, insurance, family support. You can skip this and add them later.'**
  String get setupFixedEmptyBody;

  /// No description provided for @setupFixedAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a fixed cost'**
  String get setupFixedAdd;

  /// No description provided for @setupFixedEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit fixed cost'**
  String get setupFixedEditTitle;

  /// No description provided for @setupFixedTotal.
  ///
  /// In en, this message translates to:
  /// **'Total fixed costs'**
  String get setupFixedTotal;

  /// No description provided for @setupFixedNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get setupFixedNameLabel;

  /// No description provided for @setupFixedNameHint.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get setupFixedNameHint;

  /// No description provided for @setupFixedRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} removed'**
  String setupFixedRemoved(String name);

  /// No description provided for @setupAllocationTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want to allocate the rest of your budget?'**
  String get setupAllocationTitle;

  /// No description provided for @setupAllocationDescription.
  ///
  /// In en, this message translates to:
  /// **'This is what is left after saving and fixed costs.'**
  String get setupAllocationDescription;

  /// No description provided for @setupLedgerIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get setupLedgerIncome;

  /// No description provided for @setupLedgerSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get setupLedgerSaving;

  /// No description provided for @setupLedgerFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed costs'**
  String get setupLedgerFixed;

  /// No description provided for @setupLedgerRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining budget'**
  String get setupLedgerRemaining;

  /// No description provided for @setupAllocationAutoTitle.
  ///
  /// In en, this message translates to:
  /// **'Let Finza allocate it'**
  String get setupAllocationAutoTitle;

  /// No description provided for @setupAllocationAutoDescription.
  ///
  /// In en, this message translates to:
  /// **'A suggested split across your categories.'**
  String get setupAllocationAutoDescription;

  /// No description provided for @setupAllocationManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Set it myself'**
  String get setupAllocationManualTitle;

  /// No description provided for @setupAllocationManualDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose an amount for each category.'**
  String get setupAllocationManualDescription;

  /// No description provided for @setupAllocatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Allocated'**
  String get setupAllocatedLabel;

  /// No description provided for @setupUnallocatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Left to allocate'**
  String get setupUnallocatedLabel;

  /// No description provided for @setupAllocationEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing left to allocate'**
  String get setupAllocationEmptyTitle;

  /// No description provided for @setupAllocationEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your saving goal and fixed costs use up the whole income for this cycle.'**
  String get setupAllocationEmptyBody;

  /// No description provided for @setupCategoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food and drink'**
  String get setupCategoryFood;

  /// No description provided for @setupCategoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get setupCategoryTransport;

  /// No description provided for @setupCategoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get setupCategoryShopping;

  /// No description provided for @setupCategoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get setupCategoryEntertainment;

  /// No description provided for @setupCustomCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your categories'**
  String get setupCustomCategoriesTitle;

  /// No description provided for @setupCustomCategoriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add spending groups of your own, such as pets, tuition or gifts. Their amounts are set aside before the rest is split.'**
  String get setupCustomCategoriesDescription;

  /// No description provided for @setupCustomCategoryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get setupCustomCategoryAdd;

  /// No description provided for @setupCustomCategoryEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get setupCustomCategoryEditTitle;

  /// No description provided for @setupCustomCategoryIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get setupCustomCategoryIconLabel;

  /// No description provided for @setupCustomCategoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get setupCustomCategoryNameLabel;

  /// No description provided for @setupCustomCategoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get setupCustomCategoryNameHint;

  /// No description provided for @setupCustomCategoryAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly budget'**
  String get setupCustomCategoryAmountLabel;

  /// No description provided for @setupErrorSavingGoal.
  ///
  /// In en, this message translates to:
  /// **'Your saving goal needs to be lower than your monthly income.'**
  String get setupErrorSavingGoal;

  /// No description provided for @setupErrorCommitments.
  ///
  /// In en, this message translates to:
  /// **'Saving and fixed costs add up to more than your income. Lower one of them to continue.'**
  String get setupErrorCommitments;

  /// No description provided for @setupErrorAllocationOver.
  ///
  /// In en, this message translates to:
  /// **'You have allocated {amount} more than the remaining budget.'**
  String setupErrorAllocationOver(String amount);

  /// No description provided for @setupErrorAllocationUnder.
  ///
  /// In en, this message translates to:
  /// **'{amount} of the remaining budget is not allocated yet.'**
  String setupErrorAllocationUnder(String amount);

  /// No description provided for @setupMidCycleTitle.
  ///
  /// In en, this message translates to:
  /// **'You are in the middle of the current cycle'**
  String get setupMidCycleTitle;

  /// No description provided for @setupMidCycleBody.
  ///
  /// In en, this message translates to:
  /// **'Finza records and analyses what you spend in the meantime. Your budget plan switches on from day {day}, when the new cycle begins.'**
  String setupMidCycleBody(String day);

  /// No description provided for @setupMidCycleCta.
  ///
  /// In en, this message translates to:
  /// **'Start tracking spending'**
  String get setupMidCycleCta;

  /// No description provided for @setupDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Your setup is ready'**
  String get setupDoneTitle;

  /// No description provided for @setupDoneBudgetBody.
  ///
  /// In en, this message translates to:
  /// **'Your budget cycle starts today. You can adjust any of this later in settings.'**
  String get setupDoneBudgetBody;

  /// No description provided for @setupDoneAnalyticsBody.
  ///
  /// In en, this message translates to:
  /// **'Your reporting cycle starts on day {day}. You can adjust it later in settings.'**
  String setupDoneAnalyticsBody(String day);

  /// No description provided for @setupDoneCta.
  ///
  /// In en, this message translates to:
  /// **'Start using Finza'**
  String get setupDoneCta;

  /// No description provided for @setupSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your setup'**
  String get setupSummaryTitle;

  /// No description provided for @setupSummaryMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get setupSummaryMode;

  /// No description provided for @setupSummaryCycleStart.
  ///
  /// In en, this message translates to:
  /// **'Cycle starts'**
  String get setupSummaryCycleStart;

  /// No description provided for @scheduleWeekdayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon,Tue,Wed,Thu,Fri,Sat,Sun'**
  String get scheduleWeekdayShort;

  /// No description provided for @scheduleLegendHoliday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get scheduleLegendHoliday;

  /// No description provided for @scheduleLegendUserEvent.
  ///
  /// In en, this message translates to:
  /// **'Your events'**
  String get scheduleLegendUserEvent;

  /// No description provided for @scheduleLegendDaily.
  ///
  /// In en, this message translates to:
  /// **'Has activities'**
  String get scheduleLegendDaily;

  /// No description provided for @scheduleDayEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Day events'**
  String get scheduleDayEventsTitle;

  /// No description provided for @scheduleDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily schedule'**
  String get scheduleDailyTitle;

  /// No description provided for @scheduleAllDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get scheduleAllDay;

  /// No description provided for @scheduleByTime.
  ///
  /// In en, this message translates to:
  /// **'By time'**
  String get scheduleByTime;

  /// No description provided for @scheduleNoDayEvents.
  ///
  /// In en, this message translates to:
  /// **'No events on this day'**
  String get scheduleNoDayEvents;

  /// No description provided for @scheduleNoActivities.
  ///
  /// In en, this message translates to:
  /// **'No timed activities yet'**
  String get scheduleNoActivities;

  /// No description provided for @scheduleEmptyDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned for this day'**
  String get scheduleEmptyDayTitle;

  /// No description provided for @scheduleEmptyDayBody.
  ///
  /// In en, this message translates to:
  /// **'Add a day event like a birthday, or plan an activity at a set time.'**
  String get scheduleEmptyDayBody;

  /// No description provided for @scheduleAddEvent.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get scheduleAddEvent;

  /// No description provided for @scheduleAddActivity.
  ///
  /// In en, this message translates to:
  /// **'Add activity'**
  String get scheduleAddActivity;

  /// No description provided for @scheduleEditActivity.
  ///
  /// In en, this message translates to:
  /// **'Edit activity'**
  String get scheduleEditActivity;

  /// No description provided for @scheduleActivityName.
  ///
  /// In en, this message translates to:
  /// **'Activity name'**
  String get scheduleActivityName;

  /// No description provided for @scheduleActivityDeleted.
  ///
  /// In en, this message translates to:
  /// **'Activity deleted'**
  String get scheduleActivityDeleted;

  /// No description provided for @scheduleAddChooserTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like to add?'**
  String get scheduleAddChooserTitle;

  /// No description provided for @scheduleAddEventHint.
  ///
  /// In en, this message translates to:
  /// **'Birthdays, anniversaries, special days'**
  String get scheduleAddEventHint;

  /// No description provided for @scheduleAddActivityHint.
  ///
  /// In en, this message translates to:
  /// **'Something at a set time of day'**
  String get scheduleAddActivityHint;

  /// No description provided for @scheduleEditEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get scheduleEditEvent;

  /// No description provided for @scheduleEventName.
  ///
  /// In en, this message translates to:
  /// **'Event name'**
  String get scheduleEventName;

  /// No description provided for @scheduleEventNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Mom\'s birthday'**
  String get scheduleEventNameHint;

  /// No description provided for @scheduleEventNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter an event name'**
  String get scheduleEventNameRequired;

  /// No description provided for @scheduleEventType.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get scheduleEventType;

  /// No description provided for @scheduleEventColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get scheduleEventColor;

  /// No description provided for @scheduleEventIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get scheduleEventIcon;

  /// No description provided for @scheduleRepeatYearly.
  ///
  /// In en, this message translates to:
  /// **'Repeat every year'**
  String get scheduleRepeatYearly;

  /// No description provided for @scheduleSaveEvent.
  ///
  /// In en, this message translates to:
  /// **'Save event'**
  String get scheduleSaveEvent;

  /// No description provided for @scheduleEventDeleted.
  ///
  /// In en, this message translates to:
  /// **'Event deleted'**
  String get scheduleEventDeleted;

  /// No description provided for @scheduleSystemEventNote.
  ///
  /// In en, this message translates to:
  /// **'A public holiday provided by Finza, so it can\'t be edited.'**
  String get scheduleSystemEventNote;

  /// No description provided for @scheduleShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show {count} more'**
  String scheduleShowMore(int count);

  /// No description provided for @scheduleShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get scheduleShowLess;

  /// No description provided for @scheduleEventTypeBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get scheduleEventTypeBirthday;

  /// No description provided for @scheduleEventTypeAnniversary.
  ///
  /// In en, this message translates to:
  /// **'Anniversary'**
  String get scheduleEventTypeAnniversary;

  /// No description provided for @scheduleEventTypeSpecial.
  ///
  /// In en, this message translates to:
  /// **'Special day'**
  String get scheduleEventTypeSpecial;

  /// No description provided for @scheduleEventTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get scheduleEventTypeCustom;

  /// No description provided for @scheduleEventTypeHoliday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get scheduleEventTypeHoliday;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
