import { promptAction } from "@kit.ArkUI"

@Builder
export function SecondPageBuilder(name: string, param: string) {
  SecondPage({ name: name, param: param })
}

@Component
struct SecondPage {
  name: string = ""
  param: string = ""
  pathStack: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    console.info(`构造传递参数 param：${this.param}`)
  }

  build() {
    NavDestination() {
      // 布局内容
      Column() {
        Text('这里是 SecondPage')
          .align(Alignment.Center)
        Text("构造传递参数 param：" + this.param)
          .align(Alignment.Center)
        Text("pathStack 获取参数：" + this.pathStack.getParamByName("SecondPage"))
          .align(Alignment.Center)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .title("SecondPage")
    .hideTitleBar(true)
    .onReady((context) => {
      this.pathStack = context.pathStack
      console.info(`pathStack 获取参数：${this.param}`)
    })
    .onBackPressed(() => {

      this.pathStack.pop({ result: "<<<<<< 我是从 SecondPage 返回的数据" })

      return true // true 拦截返回键
    })
  }
}
