import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:word_guess_game/app/controllers/premium_controller.dart';
import 'package:word_guess_game/app/services/purchase_service.dart';

class PremiumPage extends GetView<PremiumController> {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;
    final purchaseService = PurchaseService.to;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cs.surface,
                cs.surfaceContainerLowest.withValues(alpha: 0.94),
                cs.surfaceContainerLow.withValues(alpha: 0.9),
              ],
            ),
          ),
          child: Obx(
            () => purchaseService.isPremium.value
                ? _buildOwnedView(context, cs)
                : _buildUpgradeView(context, cs, purchaseService),
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeView(
    BuildContext context,
    ColorScheme cs,
    PurchaseService purchaseService,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'premium_title'.tr,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'premium_subtitle'.tr,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              height: 1.35,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: cs.outline.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: LinearGradient(
                      colors: [
                        cs.primary,
                        cs.primary.withValues(alpha: 0.64),
                      ],
                    ),
                  ),
                  child: Icon(
                    LucideIcons.sparkles,
                    size: 26.r,
                    color: cs.onPrimary,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'premium_title'.tr,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'premium_subtitle'.tr,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: cs.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          _BenefitsCard(cs: cs),
          SizedBox(height: 14.h),
          _PriceCard(controller: controller, cs: cs),
          SizedBox(height: 16.h),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    purchaseService.isLoading.value ? null : controller.purchase,
                icon: Icon(LucideIcons.sparkles, size: 16.r),
                label: Text(
                  purchaseService.isLoading.value
                      ? 'loading'.tr
                      : 'premium_purchase'.tr,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: purchaseService.isLoading.value ? null : controller.restore,
              child: Text('premium_restore'.tr),
            ),
          ),
          SizedBox(height: 10.h),
          if (!kReleaseMode) _DevToggleButton(controller: controller, cs: cs),
          SizedBox(height: 10.h),
          Text(
            'premium_purchase_note'.tr,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 11.sp,
              height: 1.35,
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildOwnedView(BuildContext context, ColorScheme cs) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.crown,
                size: 60.r,
                color: cs.primary,
              ),
              SizedBox(height: 14.h),
              Text(
                'premium_owned'.tr,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'premium_ready'.tr,
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  final ColorScheme cs;
  const _BenefitsCard({required this.cs});

  @override
  Widget build(BuildContext context) {
    final benefits = [
      'premium_benefit_remove_ads'.tr,
      'premium_benefit_unlimited'.tr,
      'premium_benefit_statistics'.tr,
    ];

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'premium_benefits'.tr,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 12.h),
          for (final benefit in benefits)
            Padding(
              padding: EdgeInsets.only(bottom: 9.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16.r,
                    color: cs.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      benefit,
                      style: TextStyle(fontSize: 12.sp, color: cs.onSurface),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  final PremiumController controller;
  final ColorScheme cs;

  const _PriceCard({required this.controller, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final price = controller.premiumPriceWithFallback;
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: cs.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'premium_plan_name'.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'premium_plan_desc'.tr,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'premium_one_time'.tr,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _DevToggleButton extends StatelessWidget {
  final PremiumController controller;
  final ColorScheme cs;

  const _DevToggleButton({required this.controller, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPremium = controller.purchaseService.isPremium.value;
      return GestureDetector(
        onTap: () => controller.toggleDevPremium(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: isPremium
                  ? cs.secondary.withValues(alpha: 0.6)
                  : cs.outline.withValues(alpha: 0.4),
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.code,
                size: 14.r,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
              SizedBox(width: 6.w),
              Text(
                isPremium ? 'dev_premium_on'.tr : 'dev_premium_off'.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

