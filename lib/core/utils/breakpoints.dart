import 'package:brew_coffee/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

bool isDesktop(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= AppConstants.desktopBreakpoint;
