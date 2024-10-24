import { WanService } from '../api/service/WanService';
import { DataX } from '../data/ArticlesTree';
import { ArticleComponent } from './components/ArticleComponent';
import { BannerItem } from '../data/BannerItem';

let service: WanService

PersistentStorage.persistProp<BannerItem[]>("bannerList", [])
PersistentStorage.persistProp<DataX[]>("homeTopList", [])
PersistentStorage.persistProp<DataX[]>("homeList", [])

@Component
export struct HomePage {
  pathStack: NavPathStack | null = null
  private scroller: Scroller = new Scroller(); // 滚动控制，可使用 listScroller 实现代码滚动
  @StorageLink('bannerList') bannerList: BannerItem[] = []
  @StorageLink('homeTopList') homeTopList: DataX[] = []
  @StorageLink('homeList') homeList: DataX[] = []
  @State isRefreshing: boolean = false
  @State isLoadingMore: boolean = false
  @State currentPage: number = 0

  aboutToAppear(): void {
    service = new WanService()
    this.loadData()
  }

  @Builder
  stickyHead(text: string) {
    Stack() {
      Text(`${text}`)
        .align(Alignment.Center)
        .fontColor(Color.White)
    }
    .width("100%")
    .backgroundColor($r("app.color.color_fore"))
  }

  build() {
    RelativeContainer(){
      Image($r("app.media.icon_scroll_to_top"))
        .width(30)
        .height(30)
        .margin({ bottom: 50, right: 10 })
        .zIndex(1) // Z序控制
        .onClick(() => {
          this.scroller.scrollToIndex(0)
        })
        .alignRules({
          end: { anchor: '__container__', align: HorizontalAlign.End },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        })

      Refresh({ refreshing: $$this.isRefreshing }) {
        List({
          // space: 10, // item 间隔（仅一层，每层都由直接父组件设置）
          scroller: this.scroller // 滚动控制
        }) {
          ListItemGroup() {
            ListItem() {
              Swiper() {
                ForEach(this.bannerList, (item: BannerItem) => {
                  Image(item.imagePath)
                    .width('100%')
                    .height('30%')
                    .onClick(() => {
                      this.pathStack?.pushPathByName("WebPage", item.url, (popInfo) => {
                        const result = popInfo.result as Record<string, string>
                        if (result) {
                          console.info(`<<<<<<${result.result}`)
                        }
                      })
                      console.info("跳转 WebPage")
                    })
                })
              }
              .loop(true)
              .autoPlay(true)
              .interval(3000)
            }
            .width("100%")
            .align(Alignment.Center)
          }
          .width("100%")

          if (this.homeTopList.length > 0) {
            ListItemGroup({ space: 10, header: this.stickyHead("置顶文章") }) {
              ForEach(this.homeTopList, (item: DataX, index: number) => {
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
            .width("100%")
          }

          if (this.homeList.length > 0) {
            ListItemGroup({ space: 10, header: this.stickyHead("推荐文章") }) {
              ForEach(this.homeList, (item: DataX, index: number) => {
                ArticleComponent(item, index + this.homeTopList.length, () => {
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
            .width("100%")
          }
        }
        .width("100%")
        .height("100%")
        .backgroundColor(0xE5E5E5)
        .listDirection(Axis.Vertical)
        .sticky(StickyStyle.Header) // ListItemGroup 的 header + List 的 sticky 实现粘性头
        .onReachEnd(() => {
          console.log("onReachEnd")
          if (!this.isLoadingMore) {
            this.isLoadingMore = true
            this.currentPage++
            this.loadList()
            console.log(`loadMore: this.currentPage = ${this.currentPage}`)
          }
        })
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        console.info('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onOffsetChange((value: number) => {
        console.info('Refresh onOffsetChange offset:' + value)
      })
      .onRefreshing(() => {
        setTimeout(() => { // 延迟后 恢复可刷新状态
          this.isRefreshing = false
        }, 2000)
        this.currentPage = 0
        this.loadData()
      })
      .backgroundColor(0xE5E5E5)
      .refreshOffset(64)
      .pullToRefresh(true)
    }
  }

  loadData() {
    service.getBanner().then(result => {
      this.bannerList = result
    })
    service.getHomeTopList().then(result => {
      this.homeTopList = result
    })
    this.loadList()
  }

  loadList() {
    service.getHomeList(this.currentPage).then(result => {
      if (this.currentPage == 0) {
        // 加载首页
        this.homeList = result.datas // 不要清空数组再 concat，否则页面会有一瞬间变空
      } else {
        // 加载更多
        this.homeList = this.homeList.concat(result.datas)
        setTimeout(() => { // 延迟后 恢复可加载更多状态
          this.isLoadingMore = false
        }, 2000)
      }
    })
  }
}