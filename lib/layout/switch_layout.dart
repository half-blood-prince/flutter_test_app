import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:test_web_app/component/push_latch_switch.dart';
import 'package:test_web_app/model/model.dart';

class SwitchLayout extends StatefulWidget {
  static const SWITCH_WIDTH = 55.0;
  static const SWITCH_HEIGHT = 55.0;

  final List<SwitchLayoutDetail> _switchLayoutDetail;

  final Function(SwitchDetail switchDetail,bool value) _switchValueChangecallback;

  SwitchLayout(this._switchLayoutDetail,this._switchValueChangecallback);

  @override
  State<StatefulWidget> createState() {
    return _SwitchLayoutState();
  }
}

class _SwitchLayoutState extends State<SwitchLayout> {
  Map<String, bool> _switchStateMap = Map();

  _SwitchLayoutDelegate _switchLayoutDelegate;

  @override
  void initState() {
    super.initState();
    _switchLayoutDelegate = _SwitchLayoutDelegate(widget._switchLayoutDetail);
  }

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _switchLayoutDelegate,
      children: widget._switchLayoutDetail
          .map((switchInfo) =>
              toSwitch(switchInfo, _switchStateMap.containsKey(switchInfo.id) && _switchStateMap[switchInfo.id],
                  (GlobalKey<PushLatchState> key, bool value) {
                setState(() {
                  _switchStateMap[switchInfo.id] = !value;
                });
                widget._switchValueChangecallback(switchInfo.switchDetail,!value);
              }))
          .toList(),
    );
  }
}

class _SwitchLayoutDelegate extends MultiChildLayoutDelegate {
  List<SwitchLayoutDetail> _swithInfoList;

  _SwitchLayoutDelegate(this._swithInfoList);

  @override
  void performLayout(Size size) {
    _swithInfoList.forEach((switchInfo) {
      layoutChild(switchInfo.id, BoxConstraints.tight(Size(SwitchLayout.SWITCH_WIDTH, SwitchLayout.SWITCH_HEIGHT)));
      positionChild(switchInfo.id,
          Offset(switchInfo.inputPinLocation.x - (SwitchLayout.SWITCH_WIDTH / 2), switchInfo.inputPinLocation.y));
    });
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

Widget toSwitch(SwitchLayoutDetail switchInfo, bool isPressed, Function(GlobalKey<PushLatchState> key, bool value) callback) {
  return LayoutId(
    id: switchInfo.id,
    child: PushLatchSwitch(switchInfo.globalKey, isPressed, callback),
  );
}

class SwitchLayoutDetail  {

  Point inputPinLocation;

  GlobalKey<PushLatchState> globalKey;

  SwitchDetail switchDetail;

  SwitchLayoutDetail(this.inputPinLocation, this.globalKey, this.switchDetail);

  String get id => switchDetail.globalKey;
}
