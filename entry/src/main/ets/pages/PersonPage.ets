import { UserService } from '../api/service/UserService';
import { SupperUserInfo } from '../data/UserInfo';
import { toast } from '../utils/ToastUtils';
import { log } from '../utils/LogUtils';

let service: UserService

PersistentStorage.persistProp<SupperUserInfo>("supperUserInfo", null)

@Component
export struct PersonComponent {
  pathStack: NavPathStack | null = null
  @StorageLink('supperUserInfo') supperUserInfo: SupperUserInfo | null = null;

  aboutToAppear(): void {
    service = new UserService();
    this.getUserInfo()
  }

  build() {
    Scroll() {
      Column() {
        Flex({ alignItems: ItemAlign.Center }) {
          Image(this.supperUserInfo?.userInfo.icon ? this.supperUserInfo?.userInfo.icon : $r("app.media.app_icon"))
            .borderRadius(10)
            .width(80)
            .aspectRatio(1)// 1:1
            .flexShrink(3)

          Column() {
            Text(this.supperUserInfo?.userInfo.nickname ? this.supperUserInfo?.userInfo.nickname : "未登录")

            Flex({ wrap: FlexWrap.Wrap }) {
              Text(`用户名：${this.supperUserInfo?.userInfo.username ? this.supperUserInfo?.userInfo.username :
                "null"}`)
                .fontSize(14)
                .fontColor($r("app.color.secondaryText"))
                .margin({ right: 20, top: 10 })
              Text(`ID：${this.supperUserInfo?.userInfo.id ? this.supperUserInfo?.userInfo.id : "-1"}`)
                .fontSize(14)
                .fontColor($r("app.color.secondaryText"))
                .margin({ top: 10 })
            }
            .margin({ top: 10 })

            Text(`邮箱：${this.supperUserInfo?.userInfo.email ? this.supperUserInfo?.userInfo.email : "null"}`)
              .fontSize(14)
              .fontColor($r("app.color.secondaryText"))
              .margin({ top: 20 })
          }
          .padding({ left: 10, right: 10 })
          .flexBasis('auto')
          .width("60%")
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1) // 撑满剩余宽度

          Image($r("app.media.icon_arrow_right"))
            .width(20)
            .aspectRatio(1)
        }
        .width("100%")
        .backgroundColor(Color.White)
        .padding({
          left: 16,
          right: 16,
          top: 40,
          bottom: 30,
        })
        .onClick(() => {
          if (!this.supperUserInfo) {
            AlertDialog.show(
              {
                title: '提示',
                message: "请先登录！",
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
                    this.pathStack?.pushPathByName("LoginPage", "", (popInfo) => {
                      const result = popInfo.result as Record<string, string>
                      if (result) {
                        log(`<<<<<<${result.result}`)
                        // 登录接口返回的数据不全 后续获取完整数据
                        this.getUserInfo()
                      }
                    })
                    log("跳转 LoginPage")
                  }
                }
              }
            )

          } else {

          }
        })

        Row() {
          Text("积分排行")
            .fontSize(16)
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.End }) {
            Text(`积分：${this.supperUserInfo?.coinInfo?.coinCount ? this.supperUserInfo?.coinInfo?.coinCount : "-1"}`)
              .fontSize(14)
              .fontColor($r("app.color.secondaryText"))
              .margin({ left: 10 })
            Text(`排行：${this.supperUserInfo?.coinInfo?.rank ? this.supperUserInfo?.coinInfo?.rank : "-1"}`)
              .fontSize(14)
              .fontColor($r("app.color.secondaryText"))
              .margin({ left: 10 })
          }
          .layoutWeight(1)

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
          toast("开发中")
        })

        Row() {
          Text("收藏文章")
          Blank()
          Text(`收藏量：${this.supperUserInfo?.collectArticleInfo?.count ?
            this.supperUserInfo?.collectArticleInfo?.count : "-1"} 篇`)
            .fontSize(14)
            .fontColor($r("app.color.secondaryText"))
            .margin({ left: 10 })
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
          toast("开发中")
        })

        Row() {
          Text("分享文章")
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
          Text("收藏网站")
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
          Text("浏览历史")
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
          this.pathStack?.pushPathByName("HistoryPage", "", (popInfo) => {
            const result = popInfo.result as Record<string, string>
            if (result) {
              log(`<<<<<<${result.result}`)
            }
          })
          log("跳转 HistoryPage")
        })

        Row() {
          Text("设置")
          Blank()
          Image($r("app.media.icon_arrow_right"))
            .width(20)
            .height(20)
            .margin({ left: 5 })
        }
        .width("100%")
        .height("10%")
        .backgroundColor(Color.White)
        .margin({ top: 10, bottom: 100 })
        .padding(16)
        .onClick(() => {
          this.pathStack?.pushPathByName("SettingsPage", "", (popInfo) => {
            const result = popInfo.result as Record<string, string>
            if (result) {
              log(`<<<<<<${result.result}`)
            }
          })
          log("跳转 SettingsPage")
        })

      }
      .width("100%")
    }
    .backgroundColor(0xE5E5E5)
    // .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
    .scrollBar(BarState.Off) // 滚动条常驻显示
    // .scrollBarColor(Color.Gray) // 滚动条颜色
    // .scrollBarWidth(10) // 滚动条宽度
    .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
  }

  getUserInfo() {
    service.getUserInfo().then(result => {
      this.supperUserInfo = result
      console.log(`PersonComponent：result = ${result}`);
    }).catch((err: Error) => {
      console.error(`PersonComponent：err = ${err}`);
    })
  }
}