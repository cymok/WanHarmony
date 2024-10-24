import { WanService } from '../api/service/WanService';
import { ArticlesTree, ArticlesTreeItem } from '../data/ArticlesTree';
import { TextUtils } from '../utils/TextUtils';
import { ArticleListComponent } from './components/ArticleListComponent';

let service: WanService

PersistentStorage.persistProp<ArticlesTree>("projectArticlesTree", null)

@Component
export struct ProjectComponent {
  pathStack: NavPathStack | null = null
  @StorageLink("projectArticlesTree") articlesTree: ArticlesTree | null = null
  private controller = new TabsController()

  aboutToAppear(): void {
    service = new WanService()
    service.getProjectTree().then(result => {
      this.articlesTree = result
    })
  }

  build() {
    Tabs({
      controller: this.controller,
    }) {
      TabContent() {
        ArticleListComponent({
          pathStack: this.pathStack,
          fetchList: page => {
            return service.getNewProjectList(page)
          },
        })
      }
      .tabBar("最新项目")

      ForEach(this.articlesTree, (articlesTreeItem: ArticlesTreeItem, index: number) => {
        TabContent() {
          ArticleListComponent({
            pathStack: this.pathStack,
            fetchList: page => {
              return service.getProjectList(articlesTreeItem.id, page)
            },
          })
        }
        .tabBar(TextUtils.htmlDecode(articlesTreeItem.name))
      })
    }
    .barMode(BarMode.Scrollable) // TabBar 滚动模式
  }
}