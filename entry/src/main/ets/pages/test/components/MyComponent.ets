import { router, uiObserver } from '@kit.ArkUI';
import { log } from '../../../utils/LogUtils';

@Entry
@Component
struct ParentComponent {
  @State showChild: boolean = true;
  @State btnColor: string = "#FF007DFF";
  listener: ((info: uiObserver.RouterPageInfo) => void) = (info: uiObserver.RouterPageInfo) => {
    let routerInfo = this.queryRouterPageInfo()
    if (info.pageId == routerInfo?.pageId) {
      if (info.state == uiObserver.RouterPageState.ABOUT_TO_APPEAR) {
        log("listener ABOUT_TO_APPEAR");
      } else if (info.state == uiObserver.RouterPageState.ABOUT_TO_DISAPPEAR) {
        log("listener ABOUT_TO_DISAPPEAR");
      } else if (info.state == uiObserver.RouterPageState.ON_PAGE_SHOW) {
        log("listener ON_PAGE_SHOW");
      } else if (info.state == uiObserver.RouterPageState.ON_PAGE_HIDE) {
        log("listener ON_PAGE_HIDE");
      } else if (info.state == uiObserver.RouterPageState.ON_BACK_PRESS) {
        log("listener ON_BACK_PRESS");
      }
    }
  }

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onPageShow() {
    log('page onPageShow');
  }

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onPageHide() {
    log('page onPageHide');
  }

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onBackPress() {
    log('page onBackPress');
    this.btnColor = "#FFEE0606";
    return true // 返回true表示页面自己处理返回逻辑，不进行页面路由；返回false表示使用默认的路由返回逻辑，不设置返回值按照false处理
  }

  // 组件生命周期
  aboutToAppear() {
    log('ParentComponent aboutToAppear');
    // uiObserver.on('routerPageUpdate', this.listener); // 在生命周期开始时 注册 listener
  }

  // 组件生命周期
  onDidBuild() {
    log('ParentComponent onDidBuild');
  }

  // 组件生命周期
  aboutToDisappear() {
    log('ParentComponent aboutToDisappear');
    // uiObserver.off('routerPageUpdate', this.listener); // 在生命周期结束时 注销 listener
  }

  build() {
    Column() {
      // this.showChild为true，创建Child子组件，执行Child aboutToAppear
      if (this.showChild) {
        ChildComponent()
      }
      // this.showChild为false，删除Child子组件，执行Child aboutToDisappear
      Button('delete Child')
        .margin(20)
        .backgroundColor(this.btnColor)
        .onClick(() => {
          this.showChild = false;
        })
      // push到page页面，执行onPageHide
      Button('push to next page')
        .onClick(() => {
          router.pushUrl({ url: 'pages/page' });
        })
    }
  }
}

@Component
struct ChildComponent {
  @State title: string = 'Hello World';

  // 组件生命周期
  aboutToAppear() {
    log('[lifeCycle] ChildComponent aboutToAppear');
  }

  // 组件生命周期
  onDidBuild() {
    log('[lifeCycle] ChildComponent onDidBuild');
  }

  // 组件生命周期
  aboutToDisappear() {
    log('[lifeCycle] ChildComponent aboutToDisappear');
  }

  build() {
    Text(this.title)
      .fontSize(50)
      .margin(20)
      .onClick(() => {
        this.title = 'Hello ArkUI';
      })
  }
}
