import { router, uiObserver } from '@kit.ArkUI';

@Entry
@Component
struct ParentComponent {
  @State showChild: boolean = true;
  @State btnColor: string = "#FF007DFF";
  listener: ((info: uiObserver.RouterPageInfo) => void) = (info: uiObserver.RouterPageInfo) => {
    let routerInfo = this.queryRouterPageInfo()
    if (info.pageId == routerInfo?.pageId) {
      if (info.state == uiObserver.RouterPageState.ABOUT_TO_APPEAR) {
        console.info("listener ABOUT_TO_APPEAR");
      } else if (info.state == uiObserver.RouterPageState.ABOUT_TO_DISAPPEAR) {
        console.info("listener ABOUT_TO_DISAPPEAR");
      } else if (info.state == uiObserver.RouterPageState.ON_PAGE_SHOW) {
        console.info("listener ON_PAGE_SHOW");
      } else if (info.state == uiObserver.RouterPageState.ON_PAGE_HIDE) {
        console.info("listener ON_PAGE_HIDE");
      } else if (info.state == uiObserver.RouterPageState.ON_BACK_PRESS) {
        console.info("listener ON_BACK_PRESS");
      }
    }
  }

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onPageShow() {
    console.info('page onPageShow');
  }

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onPageHide() {
    console.info('page onPageHide');
  }

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onBackPress() {
    console.info('page onBackPress');
    this.btnColor = "#FFEE0606";
    return true // 返回true表示页面自己处理返回逻辑，不进行页面路由；返回false表示使用默认的路由返回逻辑，不设置返回值按照false处理
  }

  // 组件生命周期
  aboutToAppear() {
    console.info('ParentComponent aboutToAppear');
    // uiObserver.on('routerPageUpdate', this.listener); // 在生命周期开始时 注册 listener
  }

  // 组件生命周期
  onDidBuild() {
    console.info('ParentComponent onDidBuild');
  }

  // 组件生命周期
  aboutToDisappear() {
    console.info('ParentComponent aboutToDisappear');
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
    console.info('[lifeCycle] ChildComponent aboutToAppear');
  }

  // 组件生命周期
  onDidBuild() {
    console.info('[lifeCycle] ChildComponent onDidBuild');
  }

  // 组件生命周期
  aboutToDisappear() {
    console.info('[lifeCycle] ChildComponent aboutToDisappear');
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
