import 'package:flutter/material.dart';

import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/verify_code_page.dart';
import '../../features/auth/presentation/pages/new_password_page.dart';
import '../../features/auth/presentation/pages/complete_profile_page.dart';
import '../../features/auth/presentation/pages/location_permission_page.dart';
import '../../features/auth/presentation/pages/notification_permission_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/records/presentation/pages/records_page.dart';
import '../../features/records/presentation/pages/prescription_detail_page.dart';
import '../../features/appointment/presentation/pages/appointment_page.dart';
import '../../features/appointment/presentation/pages/appointment_detail_page.dart';
import '../../features/upload/presentation/pages/upload_documents_page.dart';
import '../../features/upload/presentation/pages/scan_document_page.dart';
import '../../features/upload/presentation/pages/upload_detail_page.dart';
import '../../features/notification/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/personal_information_page.dart';
import '../../features/profile/presentation/pages/about_us_page.dart';
import '../../features/profile/presentation/pages/live_chat_page.dart';
import '../../features/profile/presentation/pages/help_center_page.dart';
import '../../features/profile/presentation/pages/faq_page.dart';
import '../../features/profile/presentation/pages/languages_page.dart';
import '../../features/profile/presentation/pages/security_settings_page.dart';
import '../../features/profile/presentation/pages/notification_settings_page.dart';
import '../../features/profile/presentation/pages/privacy_policy_page.dart';
import '../../features/profile/presentation/pages/feedback_page.dart';
import '../../core/widgets/prescription_card.dart';
import '../../core/widgets/appointment_card.dart';
import 'route_guard.dart';

class AppRouter {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const welcome = '/welcome';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const verifyCode = '/verify-code';
  static const newPassword = '/new-password';
  static const completeProfile = '/complete-profile';
  static const locationPermission = '/location-permission';
  static const notificationPermission = '/notification-permission';
  static const home = '/home';
  static const records = '/records';
  static const prescriptionDetail = '/prescription-detail';
  static const appointment = '/appointment';
  static const appointmentDetail = '/appointment-detail';
  static const upload = '/upload';
  static const scanDocument = '/scanDocument';
  static const uploadDetail = '/uploadDetail';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const profilePersonalInfo = '/profile/personal-info';
  static const profileAboutUs = '/profile/about-us';
  static const profileLiveChat = '/profile/live-chat';
  static const profileHelpCenter = '/profile/help-center';
  static const profileFaq = '/profile/faq';
  static const profileLanguages = '/profile/languages';
  static const profileSecuritySettings = '/profile/security-settings';
  static const profileNotificationSettings = '/profile/notification-settings';
  static const profilePrivacyPolicy = '/profile/privacy-policy';
  static const profileFeedback = '/profile/feedback';

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case verifyCode:
        return MaterialPageRoute(builder: (_) => const VerifyCodePage());
      case newPassword:
        return MaterialPageRoute(builder: (_) => const NewPasswordPage());
      case completeProfile:
        return MaterialPageRoute(builder: (_) => const CompleteProfilePage());
      case locationPermission:
        return MaterialPageRoute(
            builder: (_) => const LocationPermissionPage());
      case notificationPermission:
        return MaterialPageRoute(
            builder: (_) => const NotificationPermissionPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case records:
        return MaterialPageRoute(builder: (_) => const RecordsPage());
      case prescriptionDetail:
        final prescription = settings.arguments as PrescriptionData;
        return MaterialPageRoute(
            builder: (_) => PrescriptionDetailPage(prescription: prescription));
      case appointment:
        return MaterialPageRoute(builder: (_) => const AppointmentPage());
      case appointmentDetail:
        final appointmentData = settings.arguments as AppointmentData;
        return MaterialPageRoute(
          builder: (_) => AppointmentDetailPage(appointment: appointmentData),
        );
      case upload:
        return MaterialPageRoute(builder: (_) => const UploadDocumentsPage());
      case scanDocument:
        return MaterialPageRoute(builder: (_) => const ScanDocumentPage());
      case uploadDetail:
        return MaterialPageRoute(builder: (_) => const UploadDetailPage());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case profilePersonalInfo:
        return MaterialPageRoute(
            builder: (_) => const PersonalInformationPage());
      case profileAboutUs:
        return MaterialPageRoute(builder: (_) => const AboutUsPage());
      case profileLiveChat:
        return MaterialPageRoute(builder: (_) => const LiveChatPage());
      case profileHelpCenter:
        return MaterialPageRoute(builder: (_) => const HelpCenterPage());
      case profileFaq:
        return MaterialPageRoute(builder: (_) => const FaqPage());
      case profileLanguages:
        return MaterialPageRoute(builder: (_) => const LanguagesPage());
      case profileSecuritySettings:
        return MaterialPageRoute(builder: (_) => const SecuritySettingsPage());
      case profileNotificationSettings:
        return MaterialPageRoute(
            builder: (_) => const NotificationSettingsPage());
      case profilePrivacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
      case profileFeedback:
        return MaterialPageRoute(builder: (_) => const FeedbackPage());
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }

  Route<dynamic> guarded({
    required RouteSettings settings,
    required RouteGuard guard,
    required WidgetBuilder builder,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        if (!guard.canActivate(settings)) {
          return guard.fallback(context: context);
        }
        return builder(context);
      },
    );
  }
}
