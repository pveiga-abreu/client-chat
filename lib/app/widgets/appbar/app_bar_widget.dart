import 'package:flutter/material.dart';
import 'package:virtual_feeling/app/helpers/app_gradients.dart';
import 'package:virtual_feeling/app/helpers/app_text_styles.dart';

class AppBarWidget extends PreferredSize {
  AppBarWidget()
      : super(
            preferredSize: Size.fromHeight(100),
            child: Container(
              height: 200,
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: AppGradients.linear,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Marcus Castilho', style: AppTextStyles.heading),
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(color: Color(0xFF439E7D), width: 2)),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://avatars.githubusercontent.com/u/49495564?v=4"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
}
