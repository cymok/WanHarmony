import { webview } from '@kit.ArkWeb';
import { WebData } from '../data/WebData';
import dayjs from 'dayjs';
import { log, logError } from '../utils/LogUtils';
import { toast } from '../utils/ToastUtils';
import { common } from '@kit.AbilityKit';
import { startBrowsableAbility } from '../utils/AbilityUtils';

@Builder
export function WebPageBuilder(name: string, url: string) {
  WebPage({ name: name, url: url })
}

PersistentStorage.persistProp<Array<WebData>>("historyList", [])

@Component
struct WebPage {
  name: string = ""
  url: string = ""
  pathStack: NavPathStack = new NavPathStack()
  webviewController: webview.WebviewController = new webview.WebviewController();
  @State title: string = 'WebPage'
  @StorageLink('historyList') historyList: Array<WebData> = [];

  build() {
    NavDestination() {
      // 布局内容
      Column() {
        Web({ src: this.url, controller: this.webviewController })
          .onLoadIntercept(event => {
            log(`onLoadIntercept url: ${event.data.getRequestUrl()}`, "WebPage")
            return false
          })
          .onErrorReceive(event => {
            logError(`onErrorReceive url: ${event.request.getRequestUrl()}\n
              (${event.error.getErrorCode()}) ${event.error.getErrorInfo()}`, "WebPage")
          })
          .onPageBegin(event => {
            log(`onPageBegin url: ${event.url}`, "WebPage")
          })
          .onTitleReceive(event => {
            log(`onTitleReceive title: ${event.title}`, "WebPage")
            this.title = event.title

            log(`更新前 historyList = ${JSON.stringify(
              this.historyList.map<string>((it) => {
                return`${it.time} [${it.title}](${it.url})`
              })
            )}`, "historyList")

            // let time = DateUtil.getFormatTime(new Date())
            let time = dayjs(new Date()).format("YYYY/MM/DD HH:mm:ss")
            let webData = new WebData(this.url, event.title, time)
            this.historyList = this.historyList
              // 过滤掉当前 url 的项
              .filter((value) => {
                return value.url != this.url
              })
            // 在前面插入新的当前 url 的项
            this.historyList.splice(0, 0, webData)

            log(`更新后 historyList = ${JSON.stringify(
              this.historyList.map<string>((it) => {
                return`${it.time} [${it.title}](${it.url})`
              })
            )}`, "historyList")

          })
          .onProgressChange(event => {
            log(`onProgressChange progress: ${event.newProgress}`, "WebPage")
          })
          .onPageEnd(event => {
            log(`onPageEnd url: ${event.url}`, "WebPage")
          })
          .javaScriptAccess(true)//
          .metaViewport(true)//
          .layoutMode(WebLayoutMode.NONE)// 设置了 FIT_CONTENT 后 页面不能缩放
          .zoomAccess(true)//
          .cacheMode(CacheMode.Default)// LOAD_CACHE_ELSE_NETWORK
          .domStorageAccess(true)// 开启 DOM 存储 例如 微信文章 需要
          .databaseAccess(true)
          .defaultTextEncodingFormat("UTF-8")
      }
      .width('100%')
      .height('100%')
    }
    .title(this.title)
    .hideTitleBar(false)
    // 竖屏最多支持显示3个图标，横屏最多支持显示5个图标，多余的图标会被放入自动生成的更多图标
    .menus([
      {
        value: "刷新",
        icon: "resources/base/media/icon_loading.png", // 引用 resources 中的资源，传 string 时填这个
        action: () => {
          this.webviewController.refresh()
        },
      },
      {
        value: "复制链接",
        icon: "resources/base/media/icon_copy.png",
        action: () => {
          toast("开发中")
        },
      },
      {
        value: "分享发送",
        icon: "resources/base/media/icon_send.png",
        action: () => {
          toast("开发中")
        },
      },
      {
        value: "从浏览器打开",
        icon: "resources/base/media/icon_chrome.png",
        action: () => {
          startBrowsableAbility(getContext(this) as common.UIAbilityContext, this.url)
        },
      },
    ])
    .onReady((context) => {
      this.pathStack = context.pathStack
    })
    .onBackPressed(() => {
      if (this.webviewController.accessBackward()) {
        this.webviewController.backward()
      } else {
        // AlertDialog.show(
        //   {
        //     title: '提示',
        //     message: '即将返回上级页面',
        //     autoCancel: true, // 点击外部取消
        //     alignment: DialogAlignment.Center,
        //     gridCount: 3, // 可控制弹窗宽度
        //     primaryButton: {
        //       value: '取消',
        //       fontColor: Color.Gray,
        //       action: () => {
        //
        //       }
        //     },
        //     secondaryButton: {
        //       value: '继续',
        //       action: () => {
        //         this.pathStack.pop({ result: "我是从 WebPage 返回的数据" })
        //       }
        //     }
        //   }
        // )
        this.pathStack.pop({ result: "我是从 WebPage 返回的数据" })
      }
      return true // true 拦截返回键
    })

  }
}
