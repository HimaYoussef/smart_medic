// List<String> SuperVisor_type = [
//   "Choose",
//   "Doctor",
//   "Family",
//   "Neighbor",
// ];

// Super_Visor_type.dart
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

List<String> getSuperVisorTypes(BuildContext context) => [
  S.of(context).Super_Visor_type_choose,
  S.of(context).Super_Visor_type_Doctor,
  S.of(context).Super_Visor_type_Family,
  S.of(context).Super_Visor_type_Neighbor,
];
