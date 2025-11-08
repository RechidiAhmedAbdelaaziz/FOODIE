import 'package:app/core/themes/colors.dart';
import 'package:app/features/banners/modules/banners/logic/banners_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBanners extends StatefulWidget {
  const HomeBanners({super.key});

  @override
  State<HomeBanners> createState() => _HomeBannersState();
}

class _HomeBannersState extends State<HomeBanners> {
  late final PageController _pageController;
  int _currentIndex = 0;
  late final BannersCubit _bannersCubit;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _bannersCubit = BannersCubit()..fetchBanners();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _autoSwitch(),
    );
  }

  void _autoSwitch() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      final banners = _bannersCubit.state.banners;
      if (banners.isNotEmpty) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % banners.length;
        });
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bannersCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bannersCubit,
      child: Builder(
        builder: (context) {
          final banners = context.watch<BannersCubit>().state.banners;

          if (banners.isEmpty) return SizedBox.shrink();

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: 200.h,
                child: PageView.builder(
                  itemCount: banners.length,
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  padEnds: false,
                  onPageChanged: (index) => setState(() {
                    _currentIndex = index;
                  }),
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: banner.file.build(
                        width: double.infinity,
                        height: 200.h,
                      ),
                    );
                  },
                ),
              ),
              if (banners.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Indicator(
                    currentIndex: _currentIndex,
                    itemCount: banners.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class Indicator extends StatefulWidget {
  final int currentIndex;
  final int itemCount;
  const Indicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: index == widget.currentIndex ? 16.w : 8.w,
          height: 8.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: index == widget.currentIndex
                ? AppColors.greenLight
                : Colors.grey,
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
      ),
    );
  }
}
