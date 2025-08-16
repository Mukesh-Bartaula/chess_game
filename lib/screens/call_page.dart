// import 'package:flutter/material.dart';
// import 'package:chess_game/constants/call_app_info.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class CallPage extends StatelessWidget {
//   final String callID;
//   const CallPage({super.key, required this.callID});

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID: CallAppInfo
//           .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//       appSign: CallAppInfo
//           .appSignin, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//       userID: 'user_id',
//       userName: 'user_name',
//       callID: callID,
//       // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
//     );
//   }
// }
