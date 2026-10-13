import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campus_career_hub/providers/portal_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('PortalProvider loads initial demo data correctly', () {
    final provider = PortalProvider();
    expect(provider.student.fullName, equals('Alex Sharma'));
    expect(provider.trainingsCount, greaterThanOrEqualTo(5));
    expect(provider.placementsCount, greaterThanOrEqualTo(6));
    expect(provider.internshipsCount, greaterThanOrEqualTo(5));
    expect(provider.applicationsCount, greaterThanOrEqualTo(6));
    expect(provider.interviewQuestions.length, greaterThanOrEqualTo(15));
    expect(provider.careerReadinessScore, inInclusiveRange(0, 100));
  });

  test('PortalProvider prevents duplicate placement applications', () {
    final provider = PortalProvider();
    final firstPlacement = provider.placements.first;
    
    // First placement is already applied in demo data
    final canApplyAgain = provider.applyForPlacement(firstPlacement);
    expect(canApplyAgain, isFalse);
  });

  test('PortalProvider toggles training enrollment correctly', () {
    final provider = PortalProvider();
    final training = provider.trainings.firstWhere((t) => !t.isRegistered);
    final initialCount = training.registeredCount;

    provider.toggleTrainingRegistration(training.id);

    final updated = provider.trainings.firstWhere((t) => t.id == training.id);
    expect(updated.isRegistered, isTrue);
    expect(updated.registeredCount, equals(initialCount + 1));
  });

  test('PortalProvider adds and removes skills dynamically', () {
    final provider = PortalProvider();
    final initialSkillCount = provider.student.skills.length;

    provider.addSkill('Kubernetes');
    expect(provider.student.skills.contains('Kubernetes'), isTrue);
    expect(provider.student.skills.length, equals(initialSkillCount + 1));

    provider.removeSkill('Kubernetes');
    expect(provider.student.skills.contains('Kubernetes'), isFalse);
    expect(provider.student.skills.length, equals(initialSkillCount));
  });
}
