@CustomDialog
export struct MyCustomDialog {
  cancel?: () => void
  confirm?: () => void
  controller: CustomDialogController = new CustomDialogController({
    builder: MyCustomDialog({}),
  })

  build() {
    Column() {
      Text('我是内容').fontSize(20).margin({ top: 20, bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            if (this.cancel) {
              this.cancel()
            }
          }).backgroundColor(Color.White).fontColor(Color.Black)
        Button('确定')
          .onClick(() => {
            this.controller.close()
            if (this.confirm) {
              this.confirm()
            }
          }).backgroundColor(Color.White).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }.backgroundColor(Color.White)
  }
}