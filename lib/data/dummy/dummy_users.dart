// Placeholder users for building screens before real data.
import '../models/user_model.dart';

// Students
const amaraKamau = UserModel(
  id: 'u_amara',
  name: 'Amara Kamau',
  handle: '@amara.builds',
  cohort: "ALU '26",
  avatarPath: 'assets/images/avatars/amara_kamau.jpg',
  isOnline: true,
);
const kofiMensah = UserModel(
  id: 'u_kofi',
  name: 'Kofi Mensah',
  handle: '@kofi.codes',
  cohort: "ALU '25",
  avatarPath: 'assets/images/avatars/kofi_mensah.jpg',
);
const kwameOsei = UserModel(
  id: 'u_kwame',
  name: 'Kwame Osei',
  handle: '@kwame.o',
  cohort: "ALU '27",
  avatarPath: 'assets/images/avatars/kwame_osei.jpg',
);
const aminaToure = UserModel(
  id: 'u_amina',
  name: 'Amina Touré',
  handle: '@amina.t',
  cohort: "ALU '26",
  avatarPath: 'assets/images/avatars/amina_toure.jpg',
);
const jeanLucNiyonzima = UserModel(
  id: 'u_jeanluc',
  name: 'Jean-Luc Niyonzima',
  handle: '@jl.niyo',
  cohort: "ALU '25",
  avatarPath: 'assets/images/avatars/jean_luc_niyonzima.jpg',
);
const zainabKamara = UserModel(
  id: 'u_zainab',
  name: 'Zainab Kamara',
  handle: '@zainab.k',
  cohort: "ALU '27",
  avatarPath: 'assets/images/avatars/zainab_kamara.jpg',
);
const chidiOkafor = UserModel(
  id: 'u_chidi',
  name: 'Chidi Okafor',
  handle: '@chidi.ships',
  cohort: "ALU '26",
  avatarPath: 'assets/images/avatars/chidi_okafor.jpg',
);
const fatimaDiallo = UserModel(
  id: 'u_fatima',
  name: 'Fatima Diallo',
  handle: '@fatima.designs',
  cohort: "ALU '25",
  avatarPath: 'assets/images/avatars/fatima_diallo.jpg',
);

const aminaWanjiku = UserModel(
  id: 'u_amina_w',
  name: 'Amina Wanjiku',
  handle: '@amina.w',
  cohort: "ALU '26",
  avatarPath: 'assets/images/avatars/amina_wanjiku.jpg',
  isOnline: true,
);
const tendaiMoyo = UserModel(
  id: 'u_tendai',
  name: 'Tendai Moyo',
  handle: '@tendai.m',
  cohort: "ALU '27",
  avatarPath: 'assets/images/avatars/tendai_moyo.jpg',
);

// Campus offices
const aluRegistry = UserModel(
  id: 'o_registry',
  name: 'ALU Registry & Academics',
  handle: '@ALU_Registry',
  type: AuthorType.official,
  isVerified: true,
);
const aluStudentLife = UserModel(
  id: 'o_student_life',
  name: 'ALU Student Life',
  handle: '@ALU_StudentLife',
  type: AuthorType.official,
  isVerified: true,
);
const aluCareers = UserModel(
  id: 'o_careers',
  name: 'ALU Career Development',
  handle: '@ALU_Careers',
  type: AuthorType.official,
  isVerified: true,
);

// Clubs
const roboticsClub = UserModel(
  id: 'c_robotics',
  name: 'Robotics & AI Club',
  handle: '@ALU_Robotics',
  type: AuthorType.club,
);
const googleDevClub = UserModel(
  id: 'c_gdg',
  name: 'Google Developer Club',
  handle: '@ALU_GDG',
  type: AuthorType.club,
  isJoined: true,
);
const afroDanceSociety = UserModel(
  id: 'c_dance',
  name: 'Afro Dance Society',
  handle: '@ALU_AfroDance',
  type: AuthorType.club,
);
const entrepreneurshipHub = UserModel(
  id: 'c_ventures',
  name: 'Entrepreneurship Hub',
  handle: '@ALU_Ventures',
  type: AuthorType.club,
);
const debateUnion = UserModel(
  id: 'c_debate',
  name: 'Debate Union',
  handle: '@ALU_Debate',
  type: AuthorType.club,
);

// The signed-in student.
const dummyCurrentUser = amaraKamau;

const List<UserModel> dummyUsers = [
  amaraKamau,
  kofiMensah,
  kwameOsei,
  aminaToure,
  jeanLucNiyonzima,
  zainabKamara,
  chidiOkafor,
  fatimaDiallo,
  aminaWanjiku,
  tendaiMoyo,
  aluRegistry,
  aluStudentLife,
  aluCareers,
  roboticsClub,
  googleDevClub,
  afroDanceSociety,
  entrepreneurshipHub,
  debateUnion,
];
