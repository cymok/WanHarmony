import { MyCustomDialog } from './components/MyCustomDialog';
import { MMKV } from '@tencent/mmkv';
import { toast } from '../../utils/ToastUtils';
import { log } from '../../utils/LogUtils';

@Entry
@Component
struct FirstPage {
  @State message: string = 'Hello World';
  @State result2: string = "";
  @State result3: string = "";
  pathStack: NavPathStack = new NavPathStack();
  @State isShowPopup: boolean = false
  dialogController = new CustomDialogController({
    builder: MyCustomDialog({
      cancel: () => {
        toast("cancel")
      },
      confirm: () => {
        toast("confirm")
      },
    }),
    // gridCount 等其它属性 更默认弹窗差不多
    gridCount: 3,
    backgroundColor: Color.Gray,
    cancel: () => {
      toast("cancel")
    },
  })

  build() {
    Navigation(this.pathStack) {
      // ...
      RelativeContainer() {
        Column({
          space: 10 // item 之间的间隔
        }) {
          Text(this.message)
            .id('HelloWorld')
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
            })
          Divider() // 分割线，设置 height 不会增加线的宽度 只会增加组件本身的高度
          Button("showToast")
            .onClick(() => {
              toast("按钮被点击了")
              log("按钮被点击了")
            })
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
            });
          Divider()
          Button("跳转 SecondPage")
            .onClick(() => {
              // this.pathStack.pushPath({ name: "SecondPage", param: "我是来自 Index 页面的数据" })
              this.pathStack.pushPathByName("SecondPage", "我是来自 Index 页面的数据", (popInfo) => {
                if (popInfo.info.name != "SecondPage") {
                  return
                }
                const result = popInfo.result as Record<string, string>
                if (!result) {
                  return
                }
                this.result2 = result.result
                log(`pathStack 获取返回参数：${popInfo.info.name}：${result.result}`)
              })
              log("跳转 SecondPage")
            })
          Text("SecondPage result：" + this.result2)
          Button("跳转 SecondPage")
            .onClick(() => {
              // this.pathStack.pushPath({ name: "ThirdPage", param: "我是来自 Index 页面的数据" })
              this.pathStack.pushPathByName("ThirdPage", ">>>>>> 我是来自 Index 页面的数据", (popInfo) => {
                if (popInfo.info.name != "ThirdPage") {
                  return
                }
                const result = popInfo.result as Record<string, string>
                if (!result) {
                  return
                }
                this.result3 = result.result
                log(`pathStack 获取返回参数：${popInfo.info.name}：${result.result}`)
              })
              log("跳转 ThirdPage")
            })
          Text("ThirdPage result：" + this.result3)

          Button('PopupOptions')
            .onClick(() => {
              this.isShowPopup = !this.isShowPopup
            })
          Text("这是一个 Popup 绑定的组件")
            .bindPopup(this.isShowPopup, {
              message: 'This is a popup with PopupOptions',
              onWillDismiss: () => { // 当消失时执行
                this.isShowPopup = false // 重置控制变量
              }
            })

          Button("弹窗 AlertDialog")
            .onClick(() => {
              AlertDialog.show(
                {
                  title: '这是title',
                  // subtitle: 'subtitle',
                  message: '这是text 这是text 这是text',
                  autoCancel: true, // 点击外部取消
                  alignment: DialogAlignment.Center,
                  gridCount: 3, // 可控制弹窗宽度
                  // offset: { dx: 0, dy: -20 },
                  cancel: () => { // 点击外部取消 和 返回键取消 的回调
                    toast("弹窗取消")
                  },
                  primaryButton: {
                    value: '取消',
                    // style: DialogButtonStyle.DEFAULT,
                    fontColor: Color.Gray,
                    action: () => {
                      toast("取消 is clicked")
                    }
                  },
                  secondaryButton: {
                    // enabled: true,
                    // defaultFocus: true,
                    // style: DialogButtonStyle.HIGHLIGHT,
                    value: '确定',
                    action: () => {
                      toast("确定 is clicked")
                    }
                  }
                }
              )
            })

          Button("自定义弹窗 CustomDialog")
            .onClick(() => {
              this.dialogController.open()
            })

          Button("WebPage")
            .onClick(() => {
              this.pathStack.pushPath({ name: "WebPage", param: "http://192.168.1.202:9090/platform-call.html" })
            })

          Button("test mmkv set")
            .onClick(() => {
              let mmkv = MMKV.defaultMMKV();
              let str: string = 'Hello OpenHarmony from MMKV';
              mmkv.encodeString('string', str);
            })

        }
        // .height('100%')
        .width('100%')
        .backgroundColor(Color.Gray)
        .padding(16)

        Button("1")
          .align(Alignment.BottomEnd)

        Button("2")
          .align(Alignment.BottomStart)
          .alignRules({
            // alignRules 用在 RelativeContainer 的子组件
            // `end: { anchor: '__container__', align: HorizontalAlign.End }`
            // 就相当于
            // Android 中 ConstraintLayout 的 layout_constraintEnd_toEndOf
            end: { anchor: '__container__', align: HorizontalAlign.End },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          })
      }
      .height('100%')
      .width('100%')
      .priorityGesture(
        PinchGesture()
          .onActionEnd((event: GestureEvent) => {
            log('end scale:' + event.scale)
            // 手指分开，减少列数以放大item，触发阈值可以自定义，示例为2
            if (event.scale > 2) {
              // 放大
              toast("放大")
              log("放大")
            } else if (event.scale < 0.6) {
              // 缩小
              toast("缩小")
              log("缩小")
            }

          })
      )
    }
    .title("Index")
    .hideTitleBar(true)
    .hideNavBar(false) // 这个是内容？true就不显示内容了
    .mode(NavigationMode.Auto) // 显示模式：Auto、Split、Stack，即：自适应、分栏、单栏
  }
}