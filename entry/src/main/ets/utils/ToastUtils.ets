import { promptAction } from '@kit.ArkUI'
import { log } from './LogUtils'

export function toast(message: string | Resource, duration: number = 2_000) {
  promptAction.showToast({
    message: message,
    duration: duration
  })
  log(message.toString())
}

export function toastShort(message: string | Resource) {
  toast(message, 1_500)
}

export function toastLong(message: string | Resource) {
  toast(message, 5_000)
}

export function toastLongLong(message: string | Resource) {
  toast(message, 10_000)
}
