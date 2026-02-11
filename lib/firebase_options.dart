import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    String flavor = const String.fromEnvironment(
      'FLAVOR',
      defaultValue: 'prod',
    );

    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web. Please configure it via the FlutterFire CLI.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _androidOptions(flavor);
      case TargetPlatform.iOS:
        return _iosOptions(flavor);
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions _androidOptions(String flavor) {
    switch (flavor) {
      case 'prod':
        return const FirebaseOptions(
          apiKey: 'AIzaSyBia0K-DAUo59CPpfO6n-qLnjN_VBVYsDg',
          appId: '1:266760600532:android:f279d7fb6e529bbef77441',
          messagingSenderId: '266760600532',
          projectId: 'quilt-flow',
          storageBucket: 'quilt-flow.firebasestorage.app',
        );
      case 'staging':
        return const FirebaseOptions(
          apiKey: 'AIzaSyD0cRgvj82V7hCzIZhtQ5hLZl2-hH3R-_U',
          appId: '1:845450877981:ios:38a0091c1156148efabaf4',
          messagingSenderId: '845450877981',
          projectId: 'quilt-staging',
          storageBucket: 'quilt-staging.firebasestorage.app',
          androidClientId:
              '845450877981-8drqbi0pcp52funcd16pfj5u9pddh2ru.apps.googleusercontent.com',
        );
      case 'demo':
        return const FirebaseOptions(
          apiKey: 'AIzaSyBe42WZfTrOAdi85qKvr-bZilM20RDZ30k',
          appId: '1:930588986366:android:ff6a18a1ff2d99783e4eaf',
          messagingSenderId: '930588986366',
          projectId: 'quilt-8c01a',
          storageBucket: 'quilt-8c01a.appspot.com',
          androidClientId:
              '930588986366-9k34smf7mm8745amumv166kcoa9u2g83.apps.googleusercontent.com',
        );
      default:
        throw UnsupportedError(
          'FirebaseOptions for Android are not configured for flavor: $flavor',
        );
    }
  }

  static FirebaseOptions _iosOptions(String flavor) {
    switch (flavor) {
      case 'prod':
        return const FirebaseOptions(
          apiKey: 'AIzaSyCfOFGSRihwuewWe6lpyfJYG7H3oJmaVi8',
          appId: '1:266760600532:ios:c8aa790e59b6c77af77441',
          messagingSenderId: '266760600532',
          projectId: 'quilt-flow',
          storageBucket: 'quilt-flow.firebasestorage.app',
          iosBundleId: 'com.quiltflow.app',
        );
      case 'staging':
        return const FirebaseOptions(
          apiKey: 'AIzaSyD0cRgvj82V7hCzIZhtQ5hLZl2-hH3R-_U',
          appId: '1:845450877981:ios:38a0091c1156148efabaf4',
          messagingSenderId: '845450877981',
          projectId: 'quilt-staging',
          storageBucket: 'quilt-staging.firebasestorage.app',
          iosClientId:
              '845450877981-5ro2v3udou0k91i5evunbq9a7ovdgvbd.apps.googleusercontent.com',
          iosBundleId: 'staging.q-u-i-l-t.app',
        );
      case 'demo':
        return const FirebaseOptions(
          apiKey: 'AIzaSyA-UyIi05DD0p7YbZywO70KyhJBa9tJ0No',
          appId: '1:930588986366:ios:bede092cdf4d96c83e4eaf',
          messagingSenderId: '930588986366',
          projectId: 'quilt-8c01a',
          storageBucket: 'quilt-8c01a.appspot.com',
          iosClientId:
              '930588986366-ptjlsp79smi53rq1o7h03o46rqbcbnlb.apps.googleusercontent.com',
          iosBundleId: 'demo.q-u-i-l-t.app',
        );
      default:
        throw UnsupportedError(
          'FirebaseOptions for flavor $flavor are not configured.',
        );
    }
  }
}
