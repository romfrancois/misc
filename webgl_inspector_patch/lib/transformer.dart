library webgl_inspector_patch;

import 'dart:async';
import 'package:barback/barback.dart';

/**
 * This transformer applies a workaround for the issue related to Dart and WebGL-Inspector mentioned there:
 * http://code.google.com/p/dart/issues/detail?id=3351
 *
 * In order to properly work, you have to apply the following workaround in WebGL-Inspector as well:
 * - go to:
 * %userprofile%\Local Settings\Application Data\Google\Chrome\User Data\Default\Extensions\ogkcjmbhnfmlnielkjhedpcjomeaghda\1.13_0
 * - edit gli.all.js and replace 
 * var CaptureContext = function (canvas, rawgl, options) {
 *   by
 * function CaptureContext(canvas, rawgl, options) {
 */

const String WEBGL_INSPECTOR_NOT_COMPLIANT_WITH_DART = '"WebGLRenderingContext"';
const String WEBGL_INSPECTOR_COMPLIANT_WITH_DART = '"WebGLRenderingContext|CaptureContext"';

class WebGLInspectorWorkaround extends Transformer {
  WebGLInspectorWorkaround.asPlugin();
  String get allowedExtensions => ".dart.js";
  Future apply(Transform transform) {
    return transform.primaryInput.readAsString().then((String content) {
      if (content.contains(WEBGL_INSPECTOR_NOT_COMPLIANT_WITH_DART)) {
        final String newContent = content.replaceAll(WEBGL_INSPECTOR_NOT_COMPLIANT_WITH_DART, WEBGL_INSPECTOR_COMPLIANT_WITH_DART);
        var id = transform.primaryInput.id;
        print('"$id" was processed to use the WebGL-Inspector workaround for Dart');
        transform.addOutput(new Asset.fromString(id, newContent));
      }
    });
  }
}