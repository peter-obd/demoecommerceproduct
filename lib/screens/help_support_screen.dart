import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Column(
        children: [
          // Enhanced Header
          _buildEnhancedHeader(responsive),

          // Enhanced Support Content
          Expanded(
            child: _buildSupportContent(responsive),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(Responsive responsive) {
    return Container(
      height: responsive.hp(130),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(20)),
          child: Row(
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(responsive.wp(12)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: responsive.sp(40),
                  ),
                ),
              ),
              SizedBox(width: responsive.wp(15)),

              // Help Icon
              // Container(
              //   padding: EdgeInsets.all(responsive.wp(12)),
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.2),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: Icon(
              //     Icons.help_rounded,
              //     color: Colors.white,
              //     size: responsive.sp(45),
              //   ),
              // ),
              SizedBox(width: responsive.wp(15)),

              // Title Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Help & Support',
                      style: AppTextStyle.textStyle(
                        responsive.sp(50),
                        Colors.white,
                        FontWeight.w800,
                      ),
                    ),
                    Text(
                      'We\'re here to help you',
                      style: AppTextStyle.textStyle(
                        responsive.sp(32),
                        Colors.white.withOpacity(0.9),
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportContent(Responsive responsive) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(20)),
        child: Column(
          children: [
            SizedBox(height: responsive.hp(30)),

            // Welcome Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(responsive.wp(25)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(responsive.wp(20)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.lightBlue.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.support_agent_rounded,
                      size: responsive.sp(80),
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: responsive.hp(20)),
                  Text(
                    'Need Help?',
                    style: AppTextStyle.textStyle(
                      responsive.sp(50),
                      AppColors.blackText,
                      FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: responsive.hp(10)),
                  Text(
                    'Our customer support team is available 24/7 to assist you with any questions or concerns.',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle(
                      responsive.sp(35),
                      AppColors.greyText,
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: responsive.hp(30)),

            // Contact Options
            Text(
              'Contact Us',
              style: AppTextStyle.textStyle(
                responsive.sp(45),
                AppColors.blackText,
                FontWeight.w800,
              ),
            ),

            SizedBox(height: responsive.hp(20)),

            // Call Us Option
            _buildContactOption(
              'Call Us',
              'Speak directly with our support team',
              Icons.phone_rounded,
              AppColors.primary,
              responsive,
              onTap: () => _makePhoneCall(),
            ),

            SizedBox(height: responsive.hp(15)),

            // WhatsApp Option
            _buildContactOption(
              'WhatsApp Us',
              'Chat with us on WhatsApp for quick support',
              Icons.chat_rounded,
              Colors.green,
              responsive,
              onTap: () => _openWhatsApp(),
            ),

            // SizedBox(height: responsive.hp(30)),

            // // FAQ Section
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(responsive.wp(20)),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(20),
            //     boxShadow: [
            //       BoxShadow(
            //         color: AppColors.primary.withOpacity(0.05),
            //         blurRadius: 15,
            //         offset: const Offset(0, 5),
            //         spreadRadius: 1,
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Container(
            //             padding: EdgeInsets.all(responsive.wp(8)),
            //             decoration: BoxDecoration(
            //               color: AppColors.primary.withOpacity(0.1),
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             child: Icon(
            //               Icons.quiz_rounded,
            //               color: AppColors.primary,
            //               size: responsive.sp(35),
            //             ),
            //           ),
            //           SizedBox(width: responsive.wp(15)),
            //           Text(
            //             'Frequently Asked Questions',
            //             style: AppTextStyle.textStyle(
            //               responsive.sp(40),
            //               AppColors.blackText,
            //               FontWeight.w700,
            //             ),
            //           ),
            //         ],
            //       ),
            //       SizedBox(height: responsive.hp(15)),
            //       Text(
            //         'Find quick answers to common questions about orders, shipping, returns, and account management.',
            //         style: AppTextStyle.textStyle(
            //           responsive.sp(32),
            //           AppColors.greyText,
            //           FontWeight.w400,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            SizedBox(height: responsive.hp(50)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    Responsive responsive, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(responsive.wp(20)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: iconColor.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.wp(15)),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: responsive.sp(50),
                  ),
                ),
                SizedBox(width: responsive.wp(20)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.textStyle(
                          responsive.sp(42),
                          AppColors.blackText,
                          FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: responsive.hp(5)),
                      Text(
                        subtitle,
                        style: AppTextStyle.textStyle(
                          responsive.sp(32),
                          AppColors.greyText,
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(responsive.wp(8)),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: iconColor,
                    size: responsive.sp(30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _makePhoneCall() async {
    const phoneNumber =
        'tel:+96170052437'; // Replace with your actual phone number
    try {
      final Uri phoneUri = Uri.parse(phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        Get.snackbar(
          'Calling Support',
          'Opening phone dialer...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.phone, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Error',
          'Could not launch phone dialer. Please check your device settings.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to make phone call. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  void _openWhatsApp() async {
    const phoneNumber =
        '+96170052437'; // Replace with your actual WhatsApp number
    const message = 'Hello! I need help with my order from your ecommerce app.';
    final whatsappUrl =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    try {
      final Uri whatsappUri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        Get.snackbar(
          'Opening WhatsApp',
          'Launching WhatsApp chat...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.chat, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Error',
          'WhatsApp is not installed on this device or cannot be opened.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open WhatsApp. Please check if the app is installed.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }
}
