/**
 * Life Quest - Firebase Cloud Functions
 * IAP (인앱 결제) 서버사이드 영수증 검증
 *
 * 배포 전 필수 설정:
 *   1. Google Play Console → 설정 → API 액세스 → 서비스 계정 생성
 *   2. 서비스 계정에 "주문 관리" 권한 부여
 *   3. JSON 키 다운로드 후 아래 명령어 실행:
 *      firebase functions:secrets:set GOOGLE_PLAY_SERVICE_ACCOUNT
 *      (JSON 파일 내용을 한 줄로 붙여넣기)
 *   4. firebase deploy --only functions
 */

const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const { google } = require('googleapis');
const admin = require('firebase-admin');

admin.initializeApp();

// Google Play 서비스 계정 JSON을 Firebase Secret으로 관리
const googlePlayServiceAccount = defineSecret('GOOGLE_PLAY_SERVICE_ACCOUNT');

/**
 * Google Play 인앱 결제 영수증 서버사이드 검증
 *
 * Flutter에서 호출 예시:
 *   final result = await FirebaseFunctions.instance
 *     .httpsCallable('verifyPurchase')
 *     .call({
 *       'purchaseToken': purchaseDetails.verificationData.serverVerificationData,
 *       'productId': purchaseDetails.productID,
 *       'packageName': 'com.lifequest.app',
 *     });
 */
exports.verifyPurchase = onCall(
  { secrets: [googlePlayServiceAccount] },
  async (request) => {
    // 인증 확인
    if (!request.auth) {
      throw new HttpsError('unauthenticated', '로그인이 필요합니다.');
    }

    const { purchaseToken, productId, packageName } = request.data;

    if (!purchaseToken || !productId || !packageName) {
      throw new HttpsError(
        'invalid-argument',
        'purchaseToken, productId, packageName은 필수값입니다.'
      );
    }

    try {
      // 서비스 계정 인증
      const serviceAccountJson = googlePlayServiceAccount.value();
      const credentials = JSON.parse(serviceAccountJson);

      const auth = new google.auth.GoogleAuth({
        credentials,
        scopes: ['https://www.googleapis.com/auth/androidpublisher'],
      });
      const authClient = await auth.getClient();

      const androidPublisher = google.androidpublisher({
        version: 'v3',
        auth: authClient,
      });

      // Google Play Developer API로 구매 검증
      const response = await androidPublisher.purchases.products.get({
        packageName,
        productId,
        token: purchaseToken,
      });

      const { purchaseState, orderId, purchaseTimeMillis, acknowledgementState } =
        response.data;

      // purchaseState: 0 = 구매됨, 1 = 취소됨, 2 = 보류 중
      const isValid = purchaseState === 0;

      console.log(
        `[verifyPurchase] uid=${request.auth.uid} productId=${productId} ` +
        `orderId=${orderId} isValid=${isValid}`
      );

      return {
        isValid,
        purchaseState,
        orderId,
        purchaseTimeMillis,
        acknowledgementState,
      };
    } catch (error) {
      console.error('[verifyPurchase] Error:', error.message);

      if (error.code === 410) {
        // 이미 소비된 구매 토큰
        throw new HttpsError('already-exists', '이미 처리된 구매입니다.');
      }
      if (error.code === 400) {
        throw new HttpsError('invalid-argument', '유효하지 않은 구매 토큰입니다.');
      }

      throw new HttpsError('internal', '구매 검증 중 오류가 발생했습니다.');
    }
  }
);
