import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing extends StatelessWidget {
  const AppSpacing({
    ///vertical space
    this.v = 0,

    ///horizontal space
    this.h = 0,
    super.key,
  });

  factory AppSpacing.h4() => const AppSpacing(h: 4);
  factory AppSpacing.v4() => const AppSpacing(v: 4);
  factory AppSpacing.h8() => const AppSpacing(h: 8);
  factory AppSpacing.v8() => const AppSpacing(v: 8);
  factory AppSpacing.h10() => const AppSpacing(h: 10);
  factory AppSpacing.v10() => const AppSpacing(v: 10);
  factory AppSpacing.h12() => const AppSpacing(h: 12);
  factory AppSpacing.v12() => const AppSpacing(v: 12);
  factory AppSpacing.v16() => const AppSpacing(v: 16);
  factory AppSpacing.h16() => const AppSpacing(h: 16);
  factory AppSpacing.v24() => const AppSpacing(v: 24);
  factory AppSpacing.h24() => const AppSpacing(h: 24);
  factory AppSpacing.h30() => const AppSpacing(h: 30);
  factory AppSpacing.v30() => const AppSpacing(v: 30);
  factory AppSpacing.h32() => const AppSpacing(h: 32);
  factory AppSpacing.v32() => const AppSpacing(v: 32);

  final int v;
  final int h;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: ValueKey<String>('$v$h'),
      height: v > 0 ? v.h : 0,
      width: h > 0 ? h.w : 0,
    );
  }
} 