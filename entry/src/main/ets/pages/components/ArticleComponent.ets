import { DataX } from '../../data/ArticlesTree';
import { TextUtils } from '../../utils/TextUtils';

@Builder
export function ArticleComponent(item: DataX, index: number, onClick: () => void) {
  ListItem() {
    Column() {
      Row() {
        Text(item.niceDate)
          .fontColor($r("app.color.secondaryText"))
          .fontSize(14)
        Blank()
        if (item.superChapterName == "广场Tab") {
          Text(`分享人: ${item.shareUser}`)
            .fontColor($r("app.color.secondaryText"))
            .fontSize(14)
        } else {
          Text(`作者: ${item.author}`)
            .fontColor($r("app.color.secondaryText"))
            .fontSize(14)
        }
      }
      .width("100%")
      .alignItems(VerticalAlign.Center) // 垂直方向的对齐格式
      // .justifyContent(FlexAlign.SpaceAround) // 水平方向的对齐格式

      Blank().height(16)
      Row() {
        if (item.envelopePic) {
          // 有图片
          Image(item.envelopePic)
            .width(100)
            .height(100)
            .borderRadius(10)
          Blank().width(10)
          Column() {
            Text(TextUtils.htmlDecode(item.title)).fontWeight(FontWeight.Bold).fontSize(16).maxLines(2)
            Blank().height(10)
            if (item.desc) {
              Text(TextUtils.htmlDecode(item.desc)).fontSize(16).maxLines(4)
            }
          }
          .width("70%")
          .alignItems(HorizontalAlign.Start)
        } else {
          // 没有图片，首页没有
          Column() {
            Text(TextUtils.htmlDecode(item.title)).fontWeight(FontWeight.Bold).fontSize(16).maxLines(2)
            Blank().height(10)
            if (item.desc) {
              Text(TextUtils.htmlDecode(item.desc)).fontSize(16).maxLines(4)
            }
          }
          .width("100%")
          .alignItems(HorizontalAlign.Start)
        }
      }
      .width("100%")

      Blank().height(16)
      Row() {
        Column() {
          Text(`${item.superChapterName}/${TextUtils.htmlDecode(item.chapterName)}`)
            .fontColor($r("app.color.secondaryText"))
            .fontSize(14)
          if (item.tags) {
            Text(item.tags.map(tag => {
              return tag.name
            })?.join("/"))
              .fontColor($r("app.color.secondaryText"))
              .fontSize(14)
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width("100%")

      Text(`[ ${index + 1} ]`)
        .fontSize(12)
        .fontColor(0x30000000)
    }
    .onClick(onClick)
  }
  .padding(16)
  .backgroundColor(Color.White)
}
