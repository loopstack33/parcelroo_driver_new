import 'package:parcelroo_driver_app/controller/language_controller.dart';
import 'package:parcelroo_driver_app/views/activeJobs/controller/active_jobs_provider.dart';
import 'package:parcelroo_driver_app/views/availableJobs/controller/available_job_provider.dart';
import 'package:parcelroo_driver_app/views/dashboard/controller/dash_provider.dart';
import 'package:parcelroo_driver_app/views/forget_password/controller/forget_pass_provider.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/controller/jobs_todo_controller.dart';
import 'package:parcelroo_driver_app/views/joinCompany/controller/join_company_provider.dart';
import 'package:parcelroo_driver_app/views/login/controller/login_provider.dart';
import 'package:parcelroo_driver_app/views/signUp/controller/signUp_provider.dart';
import 'package:parcelroo_driver_app/views/updateBank/controller/update_bank_controller.dart';
import 'package:parcelroo_driver_app/views/uploadDocuments/controller/upload_doc_controller.dart';
import 'package:provider/provider.dart';

import '../views/cancelledJobs/controller/cancelled_job_controller.dart';
import '../views/completedJobs/controller/completed_job_controller.dart';
import '../views/updateVehicles/controller/update_vehicle_controller.dart';

/* ---------- THIS FILE ALL THE PROVIDERS (CONTROLLER'S ACCESS)---------- */
/* -------- 17-Jan-2023 -------- */

var multiProvider = [

  /// LoginProvider ///
  ChangeNotifierProvider<LoginProvider>(
    create: (_) => LoginProvider(),
    lazy: true,
  ),

  /// ForgetPassProvider ///
  ChangeNotifierProvider<ForgetPassProvider>(
    create: (_) => ForgetPassProvider(),
    lazy: true,
  ),

  /// SignUpProvider ///
  ChangeNotifierProvider<SignUpProvider>(
    create: (_) => SignUpProvider(),
    lazy: true,
  ),

  /// DashProvider ///
  ChangeNotifierProvider<DashProvider>(
    create: (_) => DashProvider(),
    lazy: true,
  ),

  /// LanguageProvider ///
  ChangeNotifierProvider<LanguageProvider>(
    create: (_) => LanguageProvider(),
    lazy: true,
  ),


  /// UpdateBankProvider ///
  ChangeNotifierProvider<UpdateBankProvider>(
    create: (_) => UpdateBankProvider(),
    lazy: true,
  ),

  /// UploadDocumentProvider ///
  ChangeNotifierProvider<UploadDocumentProvider>(
    create: (_) => UploadDocumentProvider(),
    lazy: true,
  ),

  /// JoinProvider ///
  ChangeNotifierProvider<JoinProvider>(
    create: (_) => JoinProvider(),
    lazy: true,
  ),

  /// JobsTodoProvider ///
  ChangeNotifierProvider<JobsTodoProvider>(
    create: (_) => JobsTodoProvider(),
    lazy: true,
  ),

  /// UpdateVehicleProvider ///
  ChangeNotifierProvider<UpdateVehicleProvider>(
    create: (_) => UpdateVehicleProvider(),
    lazy: true,
  ),



  /// ActiveJobsProvider ///
  ChangeNotifierProvider<ActiveJobsProvider>(
    create: (_) => ActiveJobsProvider(),
    lazy: true,
  ),



  /// AvailableJobProvider ///
  ChangeNotifierProvider<AvailableJobProvider>(
    create: (_) => AvailableJobProvider(),
    lazy: true,
  ),

  ChangeNotifierProvider<CompletedJobController>(
    create: (_) => CompletedJobController(),
    lazy: true,
  ),

  ChangeNotifierProvider<CancelledJobController>(
    create: (_) => CancelledJobController(),
    lazy: true,
  ),






];
