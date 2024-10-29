import { WanService } from '../api/service/WanService';
import { log } from '../utils/LogUtils';
import { ArticleListComponent as ArticleListComponent } from './components/ArticleListComponent';

let service: WanService

@Component
export struct SquareComponent {
  pathStack: NavPathStack | null = null
  private controller = new TabsController()

  aboutToAppear(): void {
    service = new WanService()
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image($r("app.media.icon_search"))
        .width(30)
        .height(30)
        .margin({ top: 15, right: 20 })
        .zIndex(1)
        .onClick(() => {
          this.pathStack?.pushPathByName("SearchPage", "", (popInfo) => {
            const result = popInfo.result as Record<string, string>
            if (result) {
              log(`<<<<<<${result.result}`)
            }
          })
          log("跳转 SearchPage")
        })

      Tabs({
        controller: this.controller,
      }) {
        TabContent() {
          ArticleListComponent({
            pathStack: this.pathStack,
            fetchList: page => {
              return service.getSquareList(page)
            },
          })
        }
        .tabBar("广场")

        TabContent() {
          ArticleListComponent({
            pathStack: this.pathStack,
            fetchList: page => {
              return service.getQAList(page + 1) // 此接口从 1 开始，页面统一从 0 开启，这里传参 +1
            },
          })
        }
        .tabBar("问答")
      }
      .barMode(BarMode.Scrollable) // TabBar 滚动模式
    }
  }
}