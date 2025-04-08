import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_state.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/chat_room_modal.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'dart:ui';

class GameBottomNav extends StatefulWidget {
  final Map<String, Map<String, dynamic>> winningPatterns;
  final VoidCallback showWinningPatternDetails;

  const GameBottomNav({
    Key? key,
    required this.winningPatterns,
    required this.showWinningPatternDetails,
  }) : super(key: key);

  @override
  State<GameBottomNav> createState() => _GameBottomNavState();
}

class _GameBottomNavState extends State<GameBottomNav> {
  final _tooltipController = SuperTooltipController();
  final _soundService = GameSoundService();

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 14.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chat Icon
            AppImages(
              imagePath: AppImageData.chat,
              width: 38.w,
              height: 38.w,
              onPressed: () {
                // Play board tap sound with haptic feedback
                _soundService.playBoardTap();

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  barrierColor: Colors.black54,
                  builder: (BuildContext context) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: ChatRoomModal(
                        onClose: () => Navigator.of(context).pop(),
                        userInitials: 'JD',
                        activeUsers: 2500,
                        isConnected: true,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 16.w),

            // Winning Pattern Icon
            BlocBuilder<BingoGameBloc, BingoGameState>(
              buildWhen: (previous, current) =>
                  previous.winningPattern != current.winningPattern,
              builder: (context, state) {
                return AppImages(
                  imagePath:
                      widget.winningPatterns[state.winningPattern]!['image']
                          as String,
                  width: 38.w,
                  height: 38.w,
                  onPressed: widget.showWinningPatternDetails,
                );
              },
            ),
            SizedBox(width: 16.w),

            // Info Icon with SuperTooltip
            GestureDetector(
              onTap: () async {
                // Play board tap sound with haptic feedback
                _soundService.playBoardTap();

                await _tooltipController.showTooltip();
              },
              child: SuperTooltip(
                controller: _tooltipController,
                popupDirection: TooltipDirection.up,
                showBarrier: true,
                barrierColor: Colors.black.withOpacity(0.5),
                showDropBoxFilter: true,
                sigmaX: 10,
                sigmaY: 10,
                arrowLength: 10.h,
                arrowBaseWidth: 15.w,
                borderColor: Colors.transparent,
                backgroundColor: Colors.white,
                shadowColor: Colors.black54,
                borderWidth: 0,
                borderRadius: 16.r,
                touchThroughAreaShape: ClipAreaShape.rectangle,
                content: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        "Hit Bingo button only if you have Bingo. If you call incorrectly more than twice, you will be eliminated from the round.",
                        style: AppTextStyle.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
                // The child of the SuperTooltip is the info icon
                child: AppImages(
                  imagePath: AppImageData.info1,
                  width: 40.w,
                  height: 40.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
