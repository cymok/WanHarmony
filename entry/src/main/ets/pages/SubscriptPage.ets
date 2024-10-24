import { WanService } from '../api/service/WanService'
import { ArticlesTree, ArticlesTreeItem } from '../data/ArticlesTree'
import { TextUtils } from '../utils/TextUtils'
import { ArticleListComponent } from './components/ArticleListComponent'

let service: WanService

PersistentStorage.persistProp<ArticlesTree>("subscriptArticlesTree", null)

@Component
export struct SubscriptComponent {
  pathStack: NavPathStack | null = null
  @StorageLink("subscriptArticlesTree") articlesTree: ArticlesTree | null = null
  private controller = new TabsController()

  aboutToAppear(): void {
    service = new WanService()
    service.getWxArticleTree().then(result => {
      this.articlesTree = result
    })
  }

  build() {
    Tabs({
      controller: this.controller,
    }) {
      ForEach(this.articlesTree, (articlesTreeItem: ArticlesTreeItem, index: number) => {
        TabContent() {
          ArticleListComponent({
            pathStack: this.pathStack,
            fetchList: page => {
              return service.getWxArticleList(articlesTreeItem.id, page + 1) // 此接口从 1 开始，页面统一从 0 开启，这里传参 +1
            },
          })
        }
        .tabBar(TextUtils.htmlDecode(articlesTreeItem.name))
      })
    }
    .barMode(BarMode.Scrollable) // TabBar 滚动模式
  }
}