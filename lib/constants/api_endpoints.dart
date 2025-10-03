class ApiEndpoints {
  static const String zohoAuthUrl = "https://accounts.zoho.com/oauth/v2/auth";
  static const String zohoTokenUrl = "https://accounts.zoho.com/oauth/v2/token";
  static const String clientId = "1000.KS771BCQ37QUP5QSVDXAZARP1DF3PO";
  static const String clientSecret = "d9333d359d48a15fd29910b9e536fc89e2f805cb5a";
  static const String redirectUri = "https://savemore-lms.web.app/"; // Must match Zoho
  static const String scope = "AaaServer.profile.Read"; // Replace with your required scopes


  // Base URL for Zoho Creator API
  static const String zohoCreatorBaseUrl = 'https://creator.zoho.com/api/v2';
  static const String coursesReport = '/killionchase909/savemore-lms/report/All_Courses';
  static const String studentsForm = '/killionchase909/savemore-lms/form/Students';

  // Base URL for Zoho CRM API
  static const String zohoCrmBaseUrl = 'https://www.zohoapis.com/crm/v2';

  // Authentication endpoints
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateUserProfile = '/user/update';

  // Course endpoints
  static const String courses = '/courses';
  static const String courseDetails = '/courses/';
  static const String enrollCourse = '/courses/enroll';
  static const String myCourses = '/user/courses';

  // Assessment endpoints
  static const String assessments = '/assessments';
  static const String submitAssessment = '/assessments/submit';

  // Future payment endpoints
  static const String paymentMethods = '/payment/methods';
  static const String processPayment = '/payment/process';
  static const String subscriptionPlans = '/subscription/plans';
}