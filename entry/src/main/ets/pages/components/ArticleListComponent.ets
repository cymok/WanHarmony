import { Articles, DataX } from '../../data/ArticlesTree';
import { log } from '../../utils/LogUtils';
import { ArticleComponent } from './ArticleComponent';

@Component
export struct ArticleListComponent {
  pathStack: NavPathStack | null = null
  private scroller = new Scroller()
  @State dataXArr: Array<DataX> = []
  @State isRefreshing: boolean = false
  @State isLoadingMore: boolean = false
  @State currentPage: number = 0
  fetchList: ((page: number) => Promise<Articles>) | null = null

  aboutToAppear(): void {
    this.fetchData()
  }

  build() {
    RelativeContainer() {
      Image($r("app.media.icon_scroll_to_top"))
        .width(30)
        .height(30)
        .margin({ bottom: 50, right: 10 })
        .zIndex(1)// Z序控制
        .onClick(() => {
          this.scroller.scrollToIndex(0)
        })
        .alignRules({
          end: { anchor: '__container__', align: HorizontalAlign.End },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        })

      Refresh({ refreshing: $$this.isRefreshing }) {
        List({ space: 10, scroller: this.scroller }) {
          ForEach(this.dataXArr, (item: DataX, index: number) => {
            ArticleComponent(item, index, () => {
              this.pathStack?.pushPathByName("WebPage", item.link, (popInfo) => {
                const result = popInfo.result as Record<string, string>
                if (result) {
                  log(`<<<<<<${result.result}`)
                }
              })
              log("跳转 WebPage")
            })
          });
        }
        .width("100%")
        .height("100%")
        .alignListItem(ListItemAlign.Center)
        .backgroundColor(0xE5E5E5)
        .onReachEnd(() => {
          console.log("onReachEnd")
          if (!this.isLoadingMore) {
            this.isLoadingMore = true
            setTimeout(() => { // 延迟后 恢复可加载更多状态
              this.isLoadingMore = false
            }, 2000)
            this.currentPage++
            this.fetchData()
            console.log(`loadMore: this.currentPage = ${this.currentPage}`)
          }
        })

      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        log('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onOffsetChange((value: number) => {
        log('Refresh onOffsetChange offset:' + value)
      })
      .onRefreshing(() => {
        setTimeout(() => { // 延迟后 恢复可刷新状态
          this.isRefreshing = false
        }, 2000)
        this.currentPage = 0
        this.fetchData()
      })
      .backgroundColor(0xE5E5E5)
      .refreshOffset(64)
      .pullToRefresh(true)
    }
    .width("100%")
    .height("100%")
  }

  fetchData() {
    if (this.fetchList) {
      this.fetchList(this.currentPage).then(result => {
        if (this.currentPage == 0) {
          // 加载首页
          this.dataXArr = result.datas // 不要清空数组再 concat，否则页面会有一瞬间变空
        } else {
          // 加载更多
          this.dataXArr = this.dataXArr.concat(result.datas)
        }
      })
    }
  }
}
