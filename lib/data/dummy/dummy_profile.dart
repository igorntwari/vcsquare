// Placeholder profile for the signed-in student before real data.
import '../models/profile_model.dart';
import 'dummy_users.dart';

const dummyProfile = ProfileModel(
  user: dummyCurrentUser,
  emailDomain: '@alustudent.com',
  roleTag: 'Student Leader • Year 3',
  campus: 'ALU Kigali Campus',
  program: 'BSc Software Engineering • Class of 2027',
  bio:
      'Passionate about building fintech & digital public infrastructure '
      'across Africa. Lead @ ALU Google Developer Club.',
  bioHighlight: 'ALU Google Developer Club',
  followerCount: 280,
  followingCount: 194,
  recognitionTitle: 'ALU Peer Mentor • 98% Rating',
  recognitionSubtitle: 'Recognized for campus collaboration',
);
