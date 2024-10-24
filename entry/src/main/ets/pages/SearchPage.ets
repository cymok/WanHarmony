import { WanService } from '../api/service/WanService'
import { DataX } from '../data/ArticlesTree'
import { ArticleComponent } from './components/ArticleComponent'
import { inputMethod } from '@kit.IMEKit'
import { promptAction } from '@kit.ArkUI'

let service: WanService

@Builder
export function SearchPageBuilder(name: string, param: string) {
  SearchPage()
}

@Component
export struct SearchPage {
  pathStack: NavPathStack | null = null
  private scroller = new Scroller()
  @State title: string = ""
  @State isRefreshing: boolean = false
  @State isLoadingMore: boolean = false
  @State currentPage: number = 0
  @State searchKey: string = ""
  @State searchList: DataX[] = []

  aboutToAppear(): void {
    service = new WanService()
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Stack({ alignContent: Alignment.End }) {
            TextInput({
              text: this.searchKey,
              placeholder: "输入搜索关键词",
            }).onChange((value) => {
              this.searchKey = value
            }).padding({ right: 30 })

            Text("X")
              .margin({ right: 12 })
              .onClick(() => {
                this.searchKey = ""
              })
          }
          .layoutWeight(1)

          Button("搜索")
            .onClick(() => {
              this.currentPage = 0
              this.search()
              inputMethod.getController().stopInputSession() // 关闭软键盘
            })
            .margin({ left: 10 })
        }
        .padding(16)

        // list
        List({ scroller: this.scroller }) {
          // 搜索热词
          // ListItemGroup({ space: 10, header: this.stickyHead("搜索热词") }) {
          //   ListItem() {
          //     // 流式布局
          //     WaterFlow() { // 瀑布流布局
          //       ForEach(["11111111111", "222222", "33333333333333333333333", "44", "55555555", "666666"],
          //         (item: string, index) => {
          //           FlowItem() {
          //             Text(item + index)
          //           }
          //           .onAppear(() => {
          //             // 即将触底时提前增加数据
          //           })
          //         })
          //     }
          //     .columnsTemplate('repeat(auto-fill,80)')
          //     .columnsGap(10)
          //     .rowsGap(5)
          //     .backgroundColor(0xFAEEE0)
          //     .width('100%')
          //   }
          // }

          // 搜索结果
          if (this.searchList.length > 0) {
            ListItemGroup({ space: 10 }) {
              ForEach(this.searchList, (item: DataX, index) => {
                ArticleComponent(item, index, () => {
                  this.pathStack?.pushPathByName("WebPage", item.link, (popInfo) => {
                    const result = popInfo.result as Record<string, string>
                    if (result) {
                      console.info(`<<<<<<${result.result}`)
                    }
                  })
                  console.info("跳转 WebPage")
                })
              })
            }
          } else {
            // 空页面
            ListItem() {
              Stack() {
                Text("这是一个空页面")
                  .fontSize(50)
                  .fontColor(Color.Red)
              }
              .width("100%")
              .height("80%")
            }

          }

        }
        .width("100%")
        .height("100%")
        .backgroundColor(this.searchList.length > 0 ? 0xE5E5E5 : Color.White)
        .sticky(StickyStyle.Header)
        .onReachEnd(() => {
          console.log("onReachEnd")
          if (!this.searchKey) {
            return
          }
          if (!this.isLoadingMore) {
            this.isLoadingMore = true
            setTimeout(() => { // 延迟后 恢复可加载更多状态
              this.isLoadingMore = false
            }, 2000)
            this.currentPage++
            this.search()
            console.log(`loadMore: this.currentPage = ${this.currentPage}`)
          }
        })
      }
    }
    .title(this.title)
    .onReady((context) => {
      this.pathStack = context.pathStack
    })
  }

  search() {
    if (!this.searchKey) {
      return
    }
    service.search(this.searchKey, this.currentPage).then(result => {
      if (this.currentPage == 0) {
        if (result.datas.length == 0) {
          promptAction.showToast({
            message: "没有搜索到相关文章，请更换关键词再尝试"
          })
        }
        // 加载首页
        this.searchList = result.datas // 不要清空数组再 concat，否则页面会有一瞬间变空
        this.scroller.scrollToIndex(0)
        this.title = `key: ${this.searchKey}`
      } else {
        // 加载更多
        this.searchList = this.searchList.concat(result.datas)
      }
    })
  }
}