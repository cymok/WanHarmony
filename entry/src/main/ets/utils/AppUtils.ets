import { bundleManager } from '@kit.AbilityKit';

export class AppUtils {
  static getBundleInfo(): bundleManager.BundleInfo {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
    return bundleManager.getBundleInfoForSelfSync(bundleFlags)
  }
}