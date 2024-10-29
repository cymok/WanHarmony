import hilog from '@ohos.hilog'

let domain = 0

let showLog = true
let TAG: string = "WanHarmony"

export function log(message: string, tag: string = TAG) {
  if (!showLog) {
    return
  }
  logInfo(message, tag)
}

export function logDebug(message: string, tag: string = TAG) {
  if (!showLog) {
    return
  }
  hilog.debug(domain, tag, message)
}

export function logInfo(message: string, tag: string = TAG) {
  if (!showLog) {
    return
  }
  hilog.info(domain, tag, message)
}

export function logWarn(message: string, tag: string = TAG) {
  if (!showLog) {
    return
  }
  hilog.warn(domain, tag, message)
}

export function logError(message: string, tag: string = TAG) {
  if (!showLog) {
    return
  }
  hilog.error(domain, tag, message)
}

export function logFatal(message: string, tag: string = TAG) {
  if (!showLog) {
    return
  }
  hilog.fatal(domain, tag, message)
}
