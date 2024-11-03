import { log } from '../../utils/LogUtils'

@Builder
export function ThirdPageBuilder(name: string, param: string) {
  ThirdPage({ name: name, param: param })
}

@Component
struct ThirdPage {
  name: string = ""
  param: string = ""
  pathStack: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    log(`构造传递参数 param：${this.param}`)
  }

  build() {
    NavDestination() {
      // 布局内容
      Column() {
        Text('这里是 ThirdPage')
          .align(Alignment.Center)
        Text("构造传递参数 param：" + this.param)
          .align(Alignment.Center)
        Text("pathStack 获取参数：" + this.pathStack.getParamByName("ThirdPage"))
          .align(Alignment.Center)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .title("ThirdPage")
    .hideTitleBar(true)
    .onReady((context) => {
      this.pathStack = context.pathStack
      log(`pathStack 获取参数：${this.param}`)
    })
    .onBackPressed(() => {

      this.pathStack.pop({ result: "<<<<<< 我是从 ThirdPage 返回的数据" })

      return true // true 拦截返回键
    })
  }
}
