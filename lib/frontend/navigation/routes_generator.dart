import 'package:flutter/material.dart';
import 'package:first_task_app/frontend/navigation/index.dart';
// Import all your screen files here...

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // --- Auth Flow ---
      case Routes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case Routes.signup:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );
      case Routes.setPassword:
        return MaterialPageRoute(
          builder: (_) => const SetPasswordScreen(),
          settings: settings,
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case Routes.resetPassword:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
          settings: settings,
        );

      // --- Verification Flow ---
      case Routes.companyVerification:
        return MaterialPageRoute(builder: (_) => const CompanyVerification());
      case Routes.universityVerification:
        return MaterialPageRoute(
          builder: (_) => const UniversityVerification(),
        );
      case Routes.uniSignUp:
        return MaterialPageRoute(
          builder: (_) => const UniCreateAccountScreen(),
          settings: settings,
        );
      case Routes.companySignUp:
        return MaterialPageRoute(
          builder: (_) => const CompanyCreateAccountScreen(),
          settings: settings,
        );

      case Routes.primary:
        return MaterialPageRoute(builder: (_) => const PrimaryGoalsScreen());
      case Routes.loading:
        return MaterialPageRoute(builder: (_) => const LoadingSequenceScreen());
      // --- Wellbeing Assessment Flow ---
      case Routes.assessment:
        return MaterialPageRoute(builder: (_) => WellbeingAssessmentScreen());

      case Routes.m2mood:
        return MaterialPageRoute(
          builder: (_) => MoodSelectionScreen(questionid_2: 2),
        );

      case Routes.m3primary:
        return MaterialPageRoute(
          builder: (_) => ReduceAnxietyFeelingsScreen(questionid_3: 3),
        );

      case Routes.m4copping:
        return MaterialPageRoute(
          builder: (_) => OverwhelmedActionsScreen(questionid_4: 4),
        );

      case Routes.m5support:
        return MaterialPageRoute(
          builder: (_) => SupportLevelScreen(questionid_5: 5),
        );

      // FIXED: Passing the correct single required argument 'questionid_6'
      case Routes.m2sleep:
        return MaterialPageRoute(
          builder: (_) => SleepQualityScreen(questionid_6: 6),
        );

      case Routes.physicalActivity:
        return MaterialPageRoute(
          builder: (_) => PhysicalActivityScreen(questionid_7: 7),
        );

      case Routes.m2mindfulness:
        return MaterialPageRoute(
          builder: (_) => MindfulnessRoutineScreen(questionid_8: 8),
        );

      case Routes.stress:
        return MaterialPageRoute(
          builder: (_) => StressSourceScreen(questionid_9: 9),
        );

      case Routes.stresslocation:
        return MaterialPageRoute(
          builder: (_) => MindfulnessLocationScreen(questionid_10: 10),
        );

      case Routes.stresschallenge:
        return MaterialPageRoute(
          builder: (_) => BarriersToEntryScreen(questionid_11: 11),
        );

      case Routes.learningPreference:
        return MaterialPageRoute(
          builder: (_) => LearningPreferenceScreen(questionid_12: 12),
        );

      case Routes.m4weekly:
        return MaterialPageRoute(
          builder: (_) => WeeklyCommitment(questionid_13: 13),
        );

      case Routes.m4opensharing:
        return MaterialPageRoute(
          builder: (_) => OpenSharingScreen(questionid_14: 14),
        );

      case Routes.insights:
        return MaterialPageRoute(
          builder: (_) => M4InsightsScreen(questionid_15: 15),
        );

      // --- Final Sequence & Processing ---
      case Routes.m4processing:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              const ProcessingScreen(), // Your first code snippet
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 800),
        );
      case Routes.home:
        return PageRouteBuilder(
          // Point this to the Navigation Screen we just built
          pageBuilder: (_, __, ___) => const MainNavigationScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        );
      // --- POSH / Complaint Flow ---
      case Routes.posh1:
        return MaterialPageRoute(builder: (_) => const PoshAwarenessScreen());

      case Routes.poshpolicy:
        return MaterialPageRoute(builder: (_) => const PoshPolicyScreen());

      case Routes.poshpolicy8:
        return MaterialPageRoute(
          builder: (_) => const VerbalHarassmentScreen(),
        );

      case Routes.poshpolicy9:
        return MaterialPageRoute(
          builder: (_) => const PhysicalHarassmentScreen(),
        );

      case Routes.poshpolicy10:
        return MaterialPageRoute(
          builder: (_) => const DigitalHarassmentScreen(),
        );

      case Routes.poshpolicy11:
        return MaterialPageRoute(
          builder: (_) => const WorkplaceDefinitionScreen(),
        );

      case Routes.poshpolicy12:
        return MaterialPageRoute(builder: (_) => const UploadEvidenceScreen());

      case Routes.reportcompliant:
        return MaterialPageRoute(builder: (_) => const ComplaintFormScreen());

      // ENHANCED: Added Fade Transition for the Loading State
      case Routes.compliantloading:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ComplaintRegisteredLoadingScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        );

      case Routes.compliantsucess:
        return MaterialPageRoute(builder: (_) => const SuccessScreen());
      case Routes.complianttracking:
        return MaterialPageRoute(
          builder: (_) => const ComplaintTrackingScreen(),
        );

      case Routes.help1:
        return MaterialPageRoute(builder: (_) => const HelpHomeScreen());
      case Routes.help2:
        return MaterialPageRoute(builder: (_) => const ContactOfficerPage());
      case Routes.help3:
        return MaterialPageRoute(builder: (_) => const EmergencyPage());
      case Routes.help4:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen4());
      case Routes.help5:
        return MaterialPageRoute(builder: (_) => const HelpAndSupport5());
      // case Routes.help6:
      //   return MaterialPageRoute(builder: (_) => const HelpAndSupport6());
      case Routes.uniassessment:
        return MaterialPageRoute(builder: (_) => const AssessmentIntroScreen());
      case Routes.uniassessment1:
        return MaterialPageRoute(builder: (_) => const AcademicJourneyScreen());
      case Routes.uniassessment2:
        return MaterialPageRoute(builder: (_) => const AcademicLoadScreen());
      case Routes.uniassessment4:
        return MaterialPageRoute(builder: (_) => const StudySentimentScreen());
      case Routes.uniassessment3:
        return MaterialPageRoute(builder: (_) => const ScheduleControlScreen());
      case Routes.uniassessment5:
        return MaterialPageRoute(builder: (_) => const HelpSelectionScreen());
      case Routes.uniassessment6:
        return MaterialPageRoute(builder: (_) => const StressTriggersScreen());
      case Routes.uniassessment7:
        return MaterialPageRoute(builder: (_) => const AcademicMindsetScreen());
      case Routes.uniassessment8:
        return MaterialPageRoute(
          builder: (_) => const AcademicPressureResponseScreen(),
        );
      case Routes.uniassessment9:
        return MaterialPageRoute(builder: (_) => const StressSourcesScreen());
      case Routes.uniassessment10:
        return MaterialPageRoute(builder: (_) => const StressLocationScreen ());
      case Routes.uniassessment11:
        return MaterialPageRoute(builder: (_) => const FinalUniversityAssessmentScreen ());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Route not found'))),
    );
  }
}
