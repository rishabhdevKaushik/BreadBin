import 'package:flutter/material.dart';
import '../theme.dart';

typedef NumpadButtonCallback = void Function(String value);
typedef AddCallback = void Function();
typedef BackspaceCallback = void Function();

class NumpadArea extends StatelessWidget {
  final NumpadButtonCallback onNumberPressed;
  final VoidCallback onDotPressed;
  final AddCallback onAddPressed;
  final BackspaceCallback onBackspacePressed;

  const NumpadArea({
    super.key,
    required this.onNumberPressed,
    required this.onDotPressed,
    required this.onAddPressed,
    required this.onBackspacePressed,
  });

  static const double gap = 12.0;

  Widget _circleButton(
    String label,
    VoidCallback onTap, {
    Color? color,
    IconData? icon,
  }) {
    return Material(
      color: color ?? AppTheme.button,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Center(
          child: icon == null
              ? Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.buttonText,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Icon(icon, color: AppTheme.danger, size: 28),
        ),
      ),
    );
  }

  Widget _pillButton(
    String label,
    VoidCallback onTap, {
    double? width,
    double? height,
  }) {
    return Material(
      color: AppTheme.button,
      borderRadius: BorderRadius.circular(48),
      child: InkWell(
        borderRadius: BorderRadius.circular(48),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.buttonText,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _verticalPillButton(
    VoidCallback onTap, {
    required double height,
    required double width,
  }) {
    return Material(
      color: AppTheme.pill,
      borderRadius: BorderRadius.circular(48),
      child: InkWell(
        borderRadius: BorderRadius.circular(48),
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Icon(Icons.check, color: AppTheme.income, size: 32),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double gap = NumpadArea.gap;
        final double buttonSize =
            (constraints.maxWidth - gap * 3 - gap - 16 * 2) / 4;
        final double verticalPillHeight = buttonSize * 3 + gap * 2;
        final double zeroWidth = buttonSize * 2 + gap;

        return Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 16,
          ),
          // padding: const EdgeInsets.only(top: 16),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Numpad buttons
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: _circleButton(
                                  '7',
                                  () => onNumberPressed('7'),
                                ),
                              ),
                              SizedBox(width: gap),
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: _circleButton(
                                  '8',
                                  () => onNumberPressed('8'),
                                ),
                              ),
                              SizedBox(width: gap),
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: _circleButton(
                                  '9',
                                  () => onNumberPressed('9'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: gap),
                          Row(
                            children: [
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: _circleButton(
                                  '4',
                                  () => onNumberPressed('4'),
                                ),
                              ),
                              SizedBox(width: gap),
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: _circleButton(
                                  '5',
                                  () => onNumberPressed('5'),
                                ),
                              ),
                              SizedBox(width: gap),
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: _circleButton(
                                  '6',
                                  () => onNumberPressed('6'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: gap),
                          Row(
                            children: [
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: _circleButton(
                                  '1',
                                  () => onNumberPressed('1'),
                                ),
                              ),
                              SizedBox(width: gap),
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: _circleButton(
                                  '2',
                                  () => onNumberPressed('2'),
                                ),
                              ),
                              SizedBox(width: gap),
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: _circleButton(
                                  '3',
                                  () => onNumberPressed('3'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: gap),
                          Row(
                            children: [
                              SizedBox(
                                width: zeroWidth,
                                height: buttonSize,
                                child: _pillButton(
                                  '0',
                                  () => onNumberPressed('0'),
                                  width: zeroWidth,
                                  height: buttonSize,
                                ),
                              ),
                              SizedBox(width: gap),
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: _circleButton('.', onDotPressed),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: gap),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: buttonSize,
                            height: buttonSize,
                            child: _circleButton(
                              '',
                              onBackspacePressed,
                              color: AppTheme.pill,
                              icon: Icons.backspace,
                            ),
                          ),
                          SizedBox(height: gap),
                          // Add button (check)
                          SizedBox(
                            width: buttonSize,
                            height: verticalPillHeight,
                            child: _verticalPillButton(
                              onAddPressed,
                              height: verticalPillHeight,
                              width: buttonSize,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
