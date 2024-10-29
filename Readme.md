# 一款 HarmonyOS 5.0.0(12) 版的 WanAndroid App

api 和官方网站 <https://www.wanandroid.com>

"compatibleSdkVersion": "5.0.0(12)"

## 效果

### 手机端

<div style="display: flex; justify-content: space-between;">
    <img src="pictrue/pic_phone.png" width="32%">
    <img src="pictrue/pic_phone2.png" width="32%">
    <img src="pictrue/pic_phone3.png" width="32%">
</div>

### 折叠屏

<img src="pictrue/pic_foldable.png" width="512">

<img src="pictrue/pic_foldable2.png" width="512">

### 平板端

<img src="pictrue/pic_tablet.png" width="768">

<img src="pictrue/pic_tablet2.png" width="768">

<!-- 0.3 倍缩放 -->

### others

<img src="pictrue/pic_code.png" alt="Alt text" width="1080">

## 功能和技术点

- [x] 网络：使用原生 NetworkKit 的 http 进行网络请求（可选三方库 @ohos/axios），cookies 使用原生 PersistentStorage 持久化存储（可选三方库 @tencent/mmkv）
- [x] 图片：使用原生 Image（可选三方库 @ohos/imageknife）
- [x] 状态管理：使用 V1 稳定版。
- [x] 页面路由：原生 NavPathStack + Navigation + NavDestination（可选三方库 @hadss/hmrouter、@hzw/zrouter）
- [x] 首页使用 Tabs 组件，自定义 tabBar
- [x] 页面刷新和加载更多：使用原生 Refresh 组件的 onRefreshing 进行刷新；使用 List 的 onReachEnd 进行加载更多。（可选三方库 @abner/refresh、@ohos/pulltorefresh）
- [x] 适配不同宽度的页面，PersonPage 已使用 Flex 适配
- [x] 浏览历史，侧滑删除使用 @abner/refresh，时间格式化使用 JavaScript 库 dayjs，存储使用原生 PersistentStorage 持久化存储（可选三方库 @tencent/mmkv、@liushengyi/smartdb、@ohos/dataorm）

---

- [ ] 完善其它接口的页面

## 开发过程中的一些记录

### cookies 的处理

这是某次返回的 cookies。可见一共有 5 个 cookie，index = 5 的是 key，index = 6 的是 value

```
#HttpOnly_www.wanandroid.com	FALSE	/	TRUE	0	JSESSIONID	84D02569FC8883FD676A1439F8F6CD909527
 www.wanandroid.com	FALSE	/	FALSE	1732222984	loginUserName	cymok
 www.wanandroid.com	FALSE	/	FALSE	1732222984	token_pass	7c934a41fee93d67b5bcc9c25d498f48
 .wanandroid.com	TRUE	/	FALSE	1732222984	loginUserName_wanandroid_com	cymok
 .wanandroid.com	TRUE	/	FALSE	1732222984	token_pass_wanandroid_com	7c934a41fee93d67b5bcc9c25d498f48
```

按照以上逻辑，取出处理，然后做持久化，下次就可以带上继续请求了

```typescript
// cookies 是接口返回的 cookies，格式是 string
const cookieArray = cookies.trim().split('\n')
const formattedCookies = cookieArray.map(line => {
  const parts = line.split('\t')
  return `${parts[5]}=${parts[6]}` // parts[5] 是 cookie 名称，parts[6] 是 cookie 值
}).join('; ')
```

### Webview

微信文章需要开启 DOM

```typescript
Web().domStorageAccess(true) // 开启 DOM 存储 例如 微信文章 需要
```

### 适配 Tablet、Foldable

利用 Flex 组件，适配了不同宽度的页面。PersonPage 已经适配好。

### 