import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { log, logError } from './LogUtils';
import { toast } from './ToastUtils';

export function startBrowsableAbility(context: common.UIAbilityContext, url: string) {
  let want: Want = {
    action: 'ohos.want.action.viewData',
    entities: ['entity.system.browsable'],
    uri: url
  };
  context.startAbility(want)
    .then(() => {
      log(`成功打开：${url} `)
    })
    .catch((e: BusinessError) => {
      toast("打开浏览器失败")
      logError(`code = ${e.code}, message = ${e.message}`)
    });
}
