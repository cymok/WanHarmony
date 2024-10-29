import { fileIo, fileUri, picker } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { camera, cameraPicker } from '@kit.CameraKit';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios';
import { ToastUtil } from '@pura/harmony-utils';
import { DialogHelper } from '@pura/harmony-dialog';
import { MMKV } from '@tencent/mmkv';
import { showDialogAddress, toast } from '@abner/dialog';
import { log, logError } from '../../utils/LogUtils';

@Builder
export function SecondPageBuilder(name: string, param: string) {
  SecondPage({ name: name, param: param })
}

@Component
struct SecondPage {
  name: string = ""
  param: string = ""
  pathStack: NavPathStack = new NavPathStack()
  @State uri: string = ""
  @State audioUri: string = ""
  @State imgSrc: string = '';
  @State videoSrc: string = '';

  aboutToAppear(): void {
    log(`构造传递参数 param：${this.param}`)
  }

  build() {
    NavDestination() {
      // 布局内容
      Column() {
        Text('这里是 SecondPage')
          .align(Alignment.Center)
        Text("构造传递参数 param：" + this.param)
          .align(Alignment.Center)
        Text("pathStack 获取参数：" + this.pathStack.getParamByName("SecondPage"))
          .align(Alignment.Center)

        Button("选择图片")
          .onClick(() => {
            const documentSelectOptions = new picker.DocumentSelectOptions();
            // 选择文档的最大数目（可选）
            documentSelectOptions.maxSelectNumber = 2;
            // 选择文件的后缀类型['后缀类型描述|后缀类型']（可选） 若选择项存在多个后缀名，则每一个后缀名之间用英文逗号进行分隔（可选），后缀类型名不能超过100,选择所有文件：'所有文件(*.*)|.*';
            // documentSelectOptions.fileSuffixFilters = ['图片(.png, .jpg)|.png,.jpg', '文档|.txt', '视频|.mp4', '.pdf'];
            documentSelectOptions.fileSuffixFilters = ['图片(.png, .jpg)|.png,.jpg'];
            // 指定选择的文件或者目录路径（可选）
            // documentSelectOptions.defaultFilePathUri = "file://docs/storage/Users/currentUser/test";
            //选择是否对指定文件或目录授权，true为授权，当为true时，defaultFilePathUri为必选参数，拉起文管授权界面；false为非授权，拉起常规文管界面（可选）
            // documentSelectOptions.authMode = true;

            let uris: Array<string> = [];
            let context = getContext(this) as common.Context; // 请确保 getContext(this) 返回结果为 UIAbilityContext
            // 创建文件选择器实例
            const documentViewPicker = new picker.DocumentViewPicker(context);
            documentViewPicker.select(documentSelectOptions).then((documentSelectResult: Array<string>) => {
              //文件选择成功后，返回被选中文档的uri结果集。
              uris = documentSelectResult;
              this.uri = documentSelectResult[0]
              log('documentViewPicker.select to file succeed and uris are:' + uris);
            }).catch((err: BusinessError) => {
              logError(`Invoke documentViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
            })
          })

        // 显示选择的图片
        if (this.uri) {
          Image(this.uri)
            .width(200)
            .height(200)
        }


        Button("选择文件")
          .onClick(() => {
            const audioSelectOptions = new picker.AudioSelectOptions();
            // 目前AudioSelectOptions不支持参数配置，默认可以选择所有类型的用户文件。

            let uris: Array<string> = [];
            // 请确保 getContext(this) 返回结果为 UIAbilityContext
            let context = getContext(this) as common.Context;
            const audioViewPicker = new picker.AudioViewPicker(context);
            audioViewPicker.select(audioSelectOptions).then((audioSelectResult: Array<string>) => {
              //文件选择成功后，返回被选中音频的uri结果集。
              uris = audioSelectResult;
              this.audioUri = audioSelectResult[0];
              log('audioViewPicker.select to file succeed and uri is:' + uris);
            }).catch((err: BusinessError) => {
              logError(`Invoke audioViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
            })
          })

        Button("拍照")
          .onClick(async () => {
            let cameraManager = camera.getCameraManager(getContext())
            // 获取相机（摄像头）数据列表
            let cameraArray: Array<camera.CameraDevice> = cameraManager.getSupportedCameras();
            if (cameraArray != undefined && cameraArray.length > 0) {
              for (let index = 0; index < cameraArray.length; index++) {
                log('cameraId : ' + cameraArray[index].cameraId); // 获取相机ID
                log('cameraPosition : ' + cameraArray[index].cameraPosition); // 获取相机位置
                log('cameraType : ' + cameraArray[index].cameraType); // 获取相机类型
                log('connectionType : ' + cameraArray[index].connectionType); // 获取相机连接类型
              }
            } else {
              toast("当前设备不支持拍照")
              return
            }

            let pathDir = getContext().filesDir;
            let fileName = `${new Date().getTime()}`
            let filePath = pathDir + `/${fileName}.tmp`
            fileIo.createRandomAccessFileSync(filePath, fileIo.OpenMode.CREATE);

            let uri = fileUri.getUriFromPath(filePath);
            let pickerProfile: cameraPicker.PickerProfile = {
              cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK,
              saveUri: uri
            };

            let result: cameraPicker.PickerResult =
              await cameraPicker.pick(getContext(),
                // 拍照，录像
                [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO],
                pickerProfile);
            log(`picker resultCode: ${result.resultCode},resultUri: ${result.resultUri},mediaType: ${result.mediaType}`);
            if (result.resultCode == 0) {
              if (result.mediaType === cameraPicker.PickerMediaType.PHOTO) {
                this.imgSrc = result.resultUri;
              } else {
                this.videoSrc = result.resultUri;
              }
            }
          })

        // 显示拍照的图片
        if (this.imgSrc) {
          Image(this.imgSrc)
            .width(200)
            .height(200)
        }

        Button("test axios")
          .onClick(() => {
            axios.request({
              method: "get",
              url: "https://ohpm.openharmony.cn/"
            }).then((response: AxiosResponse) => {
              log('result:' + JSON.stringify(response.data));
            }).catch((error: AxiosError) => {
              logError(error.message);
            })
          })

        Button("test harmony-utils")
          .onClick(() => {
            ToastUtil.showToast("测试 ToastUtil")
          })

        Button("test harmony-dialog")
          .onClick(() => {
            DialogHelper.showTipsDialog({
              content: "test showTipsDialog",
              onAction: () => {
                ToastUtil.showShort("ok")
              }
            })
          })

        Button("test dialog 城市地址弹窗")
          .onClick(() => {
            showDialogAddress({
              titleBarAttribute: {
                titleText: "城市地址弹窗",
              },
              confirmClick: (value, index) => {
                toast(value.toString())
              }
            })
          })

        Button("test mmkv get")
          .onClick(() => {
            let mmkv = MMKV.defaultMMKV();
            let str = mmkv.decodeString('string');
            log(`mmkv decodeString: `, str)
            ToastUtil.showToast(str)
          })

      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .title("SecondPage")
    .hideTitleBar(true)
    .onReady((context) => {
      this.pathStack = context.pathStack
      log(`pathStack 获取参数：${this.param}`)
    })
    .onBackPressed(() => {

      this.pathStack.pop({ result: "<<<<<< 我是从 SecondPage 返回的数据" })

      return true // true 拦截返回键
    })
  }
}
