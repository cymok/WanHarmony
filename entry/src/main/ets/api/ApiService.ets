import { http } from '@kit.NetworkKit';
import { ApiException, ApiResult } from './ApiResult';
import { ApiPath } from './ApiPath';
import { TextUtils } from '../utils/TextUtils';
import { CookiesUtils } from './CookiesUtils';
import { hilog } from '@kit.PerformanceAnalysisKit';

type HttpMethod = 'get' | 'post' | 'put' | 'delete'

class ApiService {
  async request<T>(
    httpMethod: HttpMethod,
    path: string,
    paramsMap: Map<string, string> | null = null,
    baseUrl: string = ApiPath.BASE_URL
  ): Promise<T> {

    return new Promise((resolve, reject) => {
      let httpRequest = http.createHttp()

      let extraData: string | null
      if (paramsMap == null) {
        extraData = null
      } else {
        extraData = TextUtils.mapToUrlEncodedString(paramsMap)
      }

      let url: string = baseUrl + path

      hilog.info(0, "network", `(${httpMethod}) request: ${url}`)
      if (extraData) {
        hilog.info(0, "network", `parameters: ${extraData}`)
      }

      let method: http.RequestMethod | null
      if (httpMethod == 'get') {
        method = http.RequestMethod.GET
      } else if (httpMethod == 'post') {
        method = http.RequestMethod.POST
      } else if (httpMethod == 'put') {
        method = http.RequestMethod.PUT
      } else if (httpMethod == 'delete') {
        method = http.RequestMethod.DELETE
      } else {
        // 够用了
        method = null
      }

      PersistentStorage.persistProp<string>("cookies", "")
      let cookies = AppStorage.get<string>("cookies") // cookies get
      if (cookies) {
        hilog.info(0, "network", `cookies: ${cookies}`)
      }

      httpRequest.request(
        url,
        {
          method: method,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded', // 数据以键值对形式发送，post 格式为 key1=value1&key2=value2。URL编码
            'Cookie': cookies,
          },
          extraData: extraData,
        },
        (err, data) => {
          hilog.info(0, "network", `(${data?.responseCode}) response: ${data?.result}`)
          if (!err && data) {
            let obj: ApiResult<T>
            if (data.responseCode == 200) {
              // 接口返回
              // cookies
              if (data.cookies) {
                // 当 cookies 有值时才进行保存
                // hilog.info(0, "network", `data.cookies = \n${data.cookies}`)
                let cookies = CookiesUtils.formatWanAndroidCookies(data.cookies)
                hilog.info(0, "network", `response cookies = ${cookies}`)
                AppStorage.setOrCreate("cookies", cookies) // cookies save
              }
              // 解析数据
              obj = JSON.parse(data.result.toString()) as ApiResult<T>
              if (obj.errorCode == 0) {
                // 接口正常返回
                resolve(obj.data!)
              } else {
                // 接口错误码
                let apiErr = new ApiException(obj.errorCode, obj.errorMsg)
                hilog.error(0, "network", `err = (${apiErr.errorCode}) ${apiErr.message}`)
                reject(apiErr)
              }
            }
          } else {
            hilog.error(0, "network", `err = (${err.code}) ${err.message}`)
            reject(err)
          }
          httpRequest.destroy()
        })
    })
  }
}

export default ApiService
