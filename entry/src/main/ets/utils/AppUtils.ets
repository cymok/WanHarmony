import { bundleManager } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@ohos.base';

export class AppUtils {
  // AppUtils.getBundleInfo(bundleInfo => {})
  // static getBundleInfo(result: (bundleInfo: bundleManager.BundleInfo) => void) {
  //   let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
  //   bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
  //   try {
  //     bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
  //       result(data)
  //     }).catch((err: BusinessError) => {
  //       hilog.error(0x0000, 'testTag', 'getBundleInfoForSelf failed. Cause: %{public}s', err.message);
  //     });
  //   } catch (err) {
  //     let message = (err as BusinessError).message;
  //     hilog.error(0x0000, 'testTag', 'getBundleInfoForSelf failed: %{public}s', message);
  //   }
  // }

  // AppUtils.getBundleInfo().then(bundleInfo => {})
  static getBundleInfo(): Promise<bundleManager.BundleInfo> { // Promise 代替回调
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
    return new Promise((resolve, reject) => {
      try {
        bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
          resolve(data);
        }).catch((err: BusinessError) => {
          hilog.error(0x0000, 'testTag', 'getBundleInfoForSelf failed. Cause: %{public}s', err.message);
          reject(err);
        });
      } catch (err) {
        let message = (err as BusinessError).message;
        hilog.error(0x0000, 'testTag', 'getBundleInfoForSelf failed: %{public}s', message);
        reject(err);
      }
    });
  }
}