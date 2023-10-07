import 'package:get/get.dart';

class LocalString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'helpDesk': 'Help Desk',
          'contactUs': 'Contact Us',
          'chatWithUs': 'Chat with us',
          'socialMedia': 'Social Media',
          'selectLanguage': 'Select Language',
          'productContents': 'Product Contents',
          'retailInformation': 'Retail information',
          'verifiedByGS1': 'Verified by GS1',
          'gtinReporter': 'GTIN Reporter',
          'productTracking': 'Product Tracking',
          'regulatoryAffairs': 'Government / Regulatory Affairs',

          // home screen scaffold
          'oneBarcodeInfinitePosibility': 'One Barcode Infinite Posibility',
          'getABarcode': 'Get A Barcode',
          'memberLogin': 'Member Login',
          'homeDescription':
              'Explore how new 2D barcodes combined with the power of GS1 Digital Link, unlock new possibilities for consumers, brands, retailers, government, regulators and more.',
          'support': 'Support',
          // Help desk screen
          'retry': 'Try again',
          'noDataFound': 'No data found',
          'noContentsFound': 'No contents found',

          // GS1 member login screen
          'gs1MemberLogin': 'GS1 Member Login',
          'emailAddress': 'Email Address',
          'loginNow': 'Login Now',
          'clickHereToReset': 'Click Here To Reset',
          'forgotPassword': 'Forgot Password?',

          // OTP screen
          'enterAVerificationCode': 'Please Enter Verification Code',
          'verifyCode': 'Verify Code',
          'otpMustBeSix': 'OTP must be six digits',
          'provideOtp': 'Please provide 6 digits OTP',
          'cancel': 'Cancel',
          'confirm': 'Confirm',

          // Select Activity and Password Screen
          'selectActivityAndPassword': 'Select Activity & Password',
          'activity': 'Activity',
          'password': 'Password',
          'providePassword': 'Please provide password',
          'The requested URL was rejected.Please consult with your administrator':
              'The requested URL was rejected.\nPlease consult with your administrator.',
          'Please Wait For Admin Approval': 'Please Wait For Admin Approval',
          'Error happended while logging in':
              'Error happended while logging in',
          'Email does not exists': 'Email does not exists',

          // Dashboard Screen
          'dashboard': 'Dashboard',
          'yourSubscriptionWillExpireOn': 'Your Subscription Will Expire On',
          'GCP': 'GCP',
          'memberId': 'Member ID',
          'Range Of Barcodes': 'Range Of Barcodes',
          'Barcodes Issued': 'Barcodes Issued',
          'Barcodes Remaining': 'Barcodes Remaining',
          "GLN Issued": "GLN Issued",
          "GLN Total Barcodes": "GLN Total Barcodes",
          "Issued SSC": "Issued SSC",
          "SSC Total Barcodes": "SSC Total Barcodes",

          // Get a barcode screen
          'Is your company located in Kingdom':
              'Is your company located in Kingdom ',
          'Did you have CR number': 'Did you have CR number ?',
          'CR Number': 'CR Number',
          'Document': 'Document',
          'Enter CR Number': 'Enter CR Number',
          'Please enter CR Number': 'Please enter CR Number',
          'Please enter valid CR Number': 'Please enter valid CR Number',
          'Loading': 'Loading',
          'Something went wrong, refresh the page':
              'Something went wrong, refresh the page',
          'Validate': 'Validate',
        },

        /// Arabic ///
        'ar_SA': {
          'helpDesk': 'مكتب المساعدة',
          'contactUs': 'اتصل بنا',
          'chatWithUs': 'الدردشة معنا',
          'socialMedia': 'وسائل التواصل الاجتماعي',
          'selectLanguage': 'اختر اللغة',
          'productContents': 'محتويات المنتج',
          'retailInformation': 'معلومات التجزئة',
          'verifiedByGS1': 'موثقة من قبل GS1',
          'gtinReporter': 'تقرير GTIN',
          'productTracking': 'تتبع المنتج',
          'regulatoryAffairs': 'الشؤون الحكومية / التنظيمية',

          // home screen scaffold
          'oneBarcodeInfinitePosibility': 'رمز شريطي واحد إمكانية لا حصر لها',
          'getABarcode': 'احصل على رمز شريطي',
          'memberLogin': 'تسجيل الدخول للأعضاء',
          'homeDescription':
              'استكشف كيف تفتح رموز الاستجابة السريعة الجديدة ثنائية الأبعاد بالاشتراك مع قوة رابط GS1 الرقمي إمكانات جديدة للمستهلكين والعلامات التجارية والتجار والحكومة والجهات التنظيمية وغيرها.',
          'support': 'الدعم',

          // Help desk screen
          'retry': 'حاول مرة أخرى',
          'noDataFound': 'لم يتم العثور على بيانات',
          'noContentsFound': 'لم يتم العثور على محتويات',

          // GS1 member login screen
          'gs1MemberLogin': 'تسجيل الدخول للأعضاء',
          'emailAddress': 'عنوان البريد الإلكتروني',
          'loginNow': 'سجل الان',
          'clickHereToReset': 'انقر هنا لإعادة تعيين',
          'forgotPassword': 'هل نسيت كلمة المرور؟',

          // OTP screen
          'enterAVerificationCode': 'الرجاء إدخال رمز التحقق',
          'verifyCode': 'تحقق من الرمز',
          'otpMustBeSix': 'يجب أن يكون OTP من ستة أرقام',
          'provideOtp': 'يرجى تقديم 6 أرقام OTP',
          'cancel': 'إلغاء',
          'confirm': 'تؤكد',

          // Select Activity and Password Screen
          'selectActivityAndPassword': 'حدد النشاط وكلمة المرور',
          'activity': 'نشاط',
          'password': 'كلمه السر',
          'providePassword': 'يرجى تقديم كلمة المرور',
          'The requested URL was rejected.Please consult with your administrator':
              'تم رفض عنوان URL المطلوب.\nيرجى التشاور مع المسؤول الخاص بك.',
          'Please Wait For Admin Approval': 'يرجى الانتظار لموافقة المشرف',
          'Error happended while logging in': 'حدث خطأ أثناء تسجيل الدخول',
          'Email does not exists': 'البريد الإلكتروني غير موجود',

          // Dashboard Screen
          'dashboard': 'لوحة القيادة',
          'yourSubscriptionWillExpireOn': 'ستنتهي اشتراكاتك في',
          'GCP': 'GCP',
          'memberId': 'معرف العضو',
          'Range Of Barcodes': 'نطاق الرموز الشريطية',
          'Barcodes Issued': 'الرموز الشريطية الصادرة',
          'Barcodes Remaining': 'الرموز الشريطية المتبقية',
          "GLN Issued": "GLN صدر",
          "GLN Total Barcodes": "GLN إجمالي الرموز الشريطية",
          "Issued SSC": "SSC صدر",
          "SSC Total Barcodes": "SSC إجمالي الرموز الشريطية",

          // Get a barcode screen
          'Is your company located in Kingdom': 'هل تقع شركتك في المملكة',
          'Did you have CR number': 'هل لديك رقم CR؟',
          'CR Number': 'رقم CR',
          'Document': 'وثيقة',
          'Enter CR Number': 'أدخل رقم CR',
          'Please enter CR Number': 'الرجاء إدخال رقم CR',
          'Please enter valid CR Number': 'الرجاء إدخال رقم CR صالح',
          'Loading': 'جار التحميل',
          'Something went wrong, refresh the page':
              'حدث خطأ ما ، قم بتحديث الصفحة',
          'Validate': 'تحقق',
        },
      };
}
