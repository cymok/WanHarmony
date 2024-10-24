import { HomePage } from './HomePage';
import { PersonComponent as PersonPage } from './PersonPage';
import { ProjectComponent as ProjectPage } from './ProjectPage';
import { SquareComponent as SquarePage } from './SquarePage';
import { SubscriptComponent as SubscriptPage } from './SubscriptPage';

@Entry
@Component
struct Index {
  pathStack: NavPathStack = new NavPathStack();
  @State currentIndex: number = 0

  build() {
    Navigation(this.pathStack) {
      Tabs() {
        TabContent() {
          HomePage({ pathStack: this.pathStack })
        }
        // .tabBar("首页")
        .tabBar(this.tabBuilder("首页", 0, $r("app.media.icon_home_selected"), $r("app.media.icon_home")))

        TabContent() {
          ProjectPage({ pathStack: this.pathStack })
        }
        .tabBar(this.tabBuilder("项目", 1, $r("app.media.icon_project_selected"), $r("app.media.icon_project")))

        TabContent() {
          SquarePage({ pathStack: this.pathStack })
        }
        .tabBar(this.tabBuilder("广场", 2, $r("app.media.icon_square_selected"), $r("app.media.icon_square")))

        TabContent() {
          SubscriptPage({ pathStack: this.pathStack })
        }
        .tabBar(this.tabBuilder("订阅", 3, $r("app.media.icon_subscribe_selected"), $r("app.media.icon_subscribe")))

        TabContent() {
          PersonPage({ pathStack: this.pathStack })
        }
        .tabBar(this.tabBuilder("个人", 4, $r("app.media.icon_person_selected"), $r("app.media.icon_person")))

      }
      .barPosition(BarPosition.End) // End 底部
      .scrollable(false) // 是否允许滑动
      .onChange((index) => {
        this.currentIndex = index
        console.log(`tab index = ${index}`)
      })
    }
    .title("Index")
    .hideTitleBar(true)
    .hideNavBar(false) // 这个是内容？true就不显示内容了
    .mode(NavigationMode.Auto) // 显示模式：Auto、Split、Stack，即：自适应、分栏、单栏
  }

  // 自定义 tab
  @Builder
  tabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 20, height: 20 })
      Blank().height(5)
      Text(title)
        .fontSize(14)
        .fontColor(this.currentIndex === targetIndex ? $r("app.color.color_fore") : $r("app.color.color_back"))
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }
}
