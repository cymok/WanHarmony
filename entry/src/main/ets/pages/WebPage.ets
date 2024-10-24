import { webview } from '@kit.ArkWeb';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Builder
export function WebPageBuilder(name: string, url: string) {
  WebPage({ name: name, url: url })
}

@Component
struct WebPage {
  name: string = ""
  url: string = ""
  pathStack: NavPathStack = new NavPathStack()
  webviewController: webview.WebviewController = new webview.WebviewController();
  @State title: string = 'WebPage'

  build() {
    NavDestination() {
      // 布局内容
      Column() {
        Web({ src: this.url, controller: this.webviewController })
          .onLoadIntercept(event => {
            hilog.info(0, "WebPage", `onLoadIntercept url: ${event.data.getRequestUrl()}`)
            return false
          })
          .onErrorReceive(event => {
            hilog.error(0, "WebPage", `onErrorReceive url: ${event.request.getRequestUrl()}\n
              (${event.error.getErrorCode()}) ${event.error.getErrorInfo()}`)
          })
          .onPageBegin(event => {
            hilog.info(0, "WebPage", `onPageBegin url: ${event.url}`)
          })
          .onTitleReceive(event => {
            hilog.info(0, "WebPage", `onTitleReceive title: ${event.title}`)
            this.title = event.title
          })
          .onProgressChange(event => {
            hilog.info(0, "WebPage", `onProgressChange progress: ${event.newProgress}`)
          })
          .onPageEnd(event => {
            hilog.info(0, "WebPage", `onPageEnd url: ${event.url}`)
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
    .onReady((context) => {
      this.pathStack = context.pathStack
    })
    .onBackPressed(() => {
      if (this.webviewController.accessBackward()) {
        this.webviewController.backward()
      } else {
        AlertDialog.show(
          {
            title: '提示',
            message: '即将返回上级页面',
            autoCancel: true, // 点击外部取消
            alignment: DialogAlignment.Center,
            gridCount: 3, // 可控制弹窗宽度
            primaryButton: {
              value: '取消',
              fontColor: Color.Gray,
              action: () => {

              }
            },
            secondaryButton: {
              value: '继续',
              action: () => {
                this.pathStack.pop({ result: "我是从 WebPage 返回的数据" })
              }
            }
          }
        )
      }
      return true // true 拦截返回键
    })

  }
}
