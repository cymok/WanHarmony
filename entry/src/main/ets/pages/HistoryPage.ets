import { WebData } from '../data/WebData';
import { ListView, RefreshController, RefreshDataSource } from '@abner/refresh';
import { alsoKt } from '../utils/MyUtils';
import { log } from '../utils/LogUtils';

@Builder
export function HistoryPageBuilder(name: string, param: string) {
  HistoryPage()
}

PersistentStorage.persistProp<Array<WebData>>("historyList", [])


@Component
export struct HistoryPage {
  @StorageLink('historyList') historyList: Array<WebData> = [];
  pathStack: NavPathStack = new NavPathStack()
  controller: RefreshController = new RefreshController()
  dataSource = new RefreshDataSource()

  aboutToAppear(): void {
    log(`historyList = ${JSON.stringify(
      this.historyList.map(it => {
        return`${it.time} [${it.title}](${it.url})`
      })
    )}`, "historyList")
  }

  build() {
    NavDestination() {
      ListView({
        space: 10,
        lazyDataSource: alsoKt(this.dataSource, (it) => {
          it.initData(this.historyList)
        }),
        itemLayout: (item, index) => this.itemLayout(item as WebData, index),
        slideRightMenuLayout: (index) => this.rightMenuLayout(index),
        emptyLayout: () => {
          Stack({ alignContent: Alignment.Center }) {
            Text("空页面")
              .fontSize(25)
          }
        },
        errorLayout: () => {
          Stack({ alignContent: Alignment.Center }) {
            Text("错误页面")
              .fontSize(25)
          }
        },
        slideMenuAttr: (attr) => {
          //设置侧滑属性
          attr.rightMenuWidth = 80
        },
        controller: this.controller,
        onRefresh: () => {
          setTimeout(() => {
            this.controller.finishRefresh()
          }, 1000)
          this.dataSource.initData(this.historyList)
        },
        // onLoadMore: () => {
        //   setTimeout(() => {
        //     this.controller.finishLoadMore()
        //   }, 1000)
        //
        // },
      })
    }
    .backgroundColor(0xE5E5E5)
    .title("浏览历史")
    .hideTitleBar(false)
    .onReady((context) => {
      this.pathStack = context.pathStack
    })
  }

  @Builder
  rightMenuLayout(index: number): void {

    Stack({ alignContent: Alignment.Center }) {
      Text("删除")
        .onClick(() => {
          this.dataSource.deleteData(index)
          log(`删除 ${index}`)
        })
    }
    .width(80) // 侧滑宽度必须配合 slideMenuAttr 设置
    .height(120)
    // .padding(30)
    .backgroundColor(Color.Red)

  }

  @Builder
  itemLayout(item: WebData, index: number): void {
    Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceBetween }) {
      Text(item.title)
        .width("100%")
        .maxLines(2)
        .alignSelf(ItemAlign.Start)

      Row() {
        Blank()
        Text(item.time)
          .maxLines(1)
          .fontColor($r("app.color.secondaryText"))
          .fontSize(14)
      }
      .width("100%")

      Row() {
        Text(`${index + 1} / ${this.historyList.length}`)
          .maxLines(1)
          .fontSize(12)
          .fontColor(0x30000000)
      }
      .justifyContent(FlexAlign.Center)
      .width("100%")

    }
    .width("100%")
    .height(120)
    .padding(16)
    .backgroundColor(Color.White)
    .onClick(() => {
      this.pathStack?.pushPathByName("WebPage", item.url, (popInfo) => {
        const result = popInfo.result as Record<string, string>
        if (result) {
          log(`<<<<<<${result.result}`)
        }
        // 数据变化后 组件不会自动刷新
        // 手动执行刷新
        this.dataSource.initData(this.historyList)
        this.controller.scrollToIndex(0)
      })
      log("跳转 WebPage")
    })
  }
}