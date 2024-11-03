import { SupperUserInfo } from '../data/UserInfo';
import { UserService } from '../api/service/UserService';
import { AppUtils } from '../utils/AppUtils';
import { toast } from '../utils/ToastUtils';
import { log } from '../utils/LogUtils';

let service: UserService

@Builder
export function SettingsPageBuilder(name: string, param: string) {
  SettingsPage()
}

PersistentStorage.persistProp<SupperUserInfo>("supperUserInfo", null)

@Component
export struct SettingsPage {
  @StorageLink('supperUserInfo') supperUserInfo: SupperUserInfo | null = null;
  pathStack: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    service = new UserService();
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Row() {
            Text("缓存清理")
            Blank()
            Image($r("app.media.icon_arrow_right"))
              .width(20)
              .height(20)
              .margin({ left: 5 })
          }
          .width("100%")
          .height("10%")
          .backgroundColor(Color.White)
          .padding(16)
          .onClick(() => {
            toast("开发中")
          })

          Row() {
            Text("深色模式")
            Blank()
            Image($r("app.media.icon_arrow_right"))
              .width(20)
              .height(20)
              .margin({ left: 5 })
          }
          .width("100%")
          .height("10%")
          .backgroundColor(Color.White)
          .margin({ top: 1 })
          .padding(16)
          .onClick(() => {
            toast("开发中")
          })

          Row() {
            Text("网站")
            Blank()
            Text("WanAndroid")
              .fontSize(14)
              .fontColor($r("app.color.secondaryText"))
            Image($r("app.media.icon_arrow_right"))
              .width(20)
              .height(20)
              .margin({ left: 5 })
          }
          .width("100%")
          .height("10%")
          .backgroundColor(Color.White)
          .margin({ top: 10 })
          .padding(16)
          .onClick(() => {
            this.pathStack?.pushPathByName("WebPage", "wanandroid.com", (popInfo) => {
              const result = popInfo.result as Record<string, string>
              if (result) {
                log(`<<<<<<${result.result}`)
              }
            })
            log("跳转 WebPage")
          })

          Row() {
            Text("反馈/建议")
            Blank()
            Image($r("app.media.icon_arrow_right"))
              .width(20)
              .height(20)
              .margin({ left: 5 })
          }
          .width("100%")
          .height("10%")
          .backgroundColor(Color.White)
          .margin({ top: 1 })
          .padding(16)
          .onClick(() => {
            toast("开发中")
          })

          Row() {
            Text("崩溃日志上报")
            Blank()
            Image($r("app.media.icon_arrow_right"))
              .width(20)
              .height(20)
              .margin({ left: 5 })
          }
          .width("100%")
          .height("10%")
          .backgroundColor(Color.White)
          .margin({ top: 1 })
          .padding(16)
          .onClick(() => {
            toast("开发中")
          })

          Row() {
            Text("APP 源码")
            Blank()
            Image($r("app.media.icon_arrow_right"))
              .width(20)
              .height(20)
              .margin({ left: 5 })
          }
          .width("100%")
          .height("10%")
          .backgroundColor(Color.White)
          .margin({ top: 1 })
          .padding(16)
          .onClick(() => {
            toast("开发中")
          })

          Row() {
            Text("关于 APP")
            Blank()
            Text(`Version ${AppUtils.getBundleInfo().versionName}`)
              .fontSize(14)
              .fontColor($r("app.color.secondaryText"))
            Image($r("app.media.icon_arrow_right"))
              .width(20)
              .height(20)
              .margin({ left: 5 })
          }
          .width("100%")
          .height("10%")
          .backgroundColor(Color.White)
          .margin({ top: 1 })
          .padding(16)
          .onClick(() => {
            toast(`versionCode: ${AppUtils.getBundleInfo().versionCode}`)
          })

          // 已登录才显示
          if (this.supperUserInfo) {
            Row() {
              Text("退出")
            }
            .width("100%")
            .height("10%")
            .backgroundColor(Color.White)
            .justifyContent(FlexAlign.Center)
            .margin({ top: 10, bottom: 100 })
            .padding(16)
            .onClick(() => {
              AlertDialog.show(
                {
                  title: '提示',
                  message: "要注销登录吗？",
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
                    value: '确定',
                    action: () => {
                      this.logout()
                    }
                  }
                }
              )
            })
          }

        }
        .width("100%")
        .height("100%")
      }
      // .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
      .scrollBar(BarState.Off) // 滚动条常驻显示
      // .scrollBarColor(Color.Gray) // 滚动条颜色
      // .scrollBarWidth(10) // 滚动条宽度
      .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
    }
    .backgroundColor(0xE5E5E5)
    .title("设置")
    .hideTitleBar(false)
    .onReady((context) => {
      this.pathStack = context.pathStack
    })
  }

  logout() {
    service.logout().then(result => {
      this.supperUserInfo = null
      console.log("已退出登录");
    }).catch((err: Error) => {
      console.error(`退出登录请求失败：\n${err?.message}`);
    })
  }
}