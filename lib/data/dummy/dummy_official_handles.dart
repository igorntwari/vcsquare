// Placeholder official handles for building screens before real data.
import '../models/official_handle_model.dart';

const List<OfficialHandleModel> dummyOfficialHandles = [
  OfficialHandleModel(
    id: 'h_registry',
    name: 'ALU Registry',
    handle: '@ALU_Registry',
    category: 'REGISTRY',
    description:
        'Course registration, transcripts, exam timetables and academic '
        'calendar updates.',
    iconName: 'school',
    order: 0,
  ),
  OfficialHandleModel(
    id: 'h_student_life',
    name: 'Student Life',
    handle: '@StudentLife',
    category: 'STUDENT LIFE',
    description:
        'Campus residence, wellbeing, student council updates and events.',
    iconName: 'diversity_3',
    order: 1,
  ),
  OfficialHandleModel(
    id: 'h_careers',
    name: 'ALU Career Hub',
    handle: '@ALU_Careers',
    category: 'CAREERS',
    description:
        'Pan-African internships, global fellowships, and alumni mentoring.',
    iconName: 'work_outline',
    order: 2,
  ),
  OfficialHandleModel(
    id: 'h_sports',
    name: 'ALU Rhinos Sports',
    handle: '@ALU_Sports',
    category: 'ATHLETICS',
    description:
        'Intramural soccer, basketball tournaments, gym hours, and fixtures.',
    iconName: 'sports_soccer',
    order: 3,
  ),
];
