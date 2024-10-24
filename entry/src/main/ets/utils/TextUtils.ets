export class TextUtils {
  // json 字符串转为为 url编码的键值对字符串
  static jsonToUrlEncodedString(jsonString: string): string {
    console.log(`jsonString = ${jsonString}`)
    let json: Record<string, string>;

    try {
      json = JSON.parse(jsonString);
    } catch (error) {
      throw new Error("Invalid JSON string");
    }

    let result: string = Object.keys(json)
      .map(key => {
        const value = encodeURIComponent(json[key]);
        return `${encodeURIComponent(key)}=${value}`;
      })
      .join('&');
    console.log(`键值对: ${result}`)
    return result
  }

  // map 键值对转为为 url编码的键值对字符串
  static mapToUrlEncodedString(map: Map<string, string>): string {
    // 将 Map 转换为数组，并对每个键值对进行 URI 编码
    const paramsArray = Array.from(map.entries()).map((kv) => {
      return encodeURIComponent(kv[0]) + '=' + encodeURIComponent(kv[1]);
    });
    // 将数组用 `&` 拼接成 URL encoded 字符串
    let result: string = paramsArray.join('&');
    return result;
  }

  // 参考 `android.text.TextUtils.htmlEncode`
  static htmlEncode(str: string): string {
    return str.replace("<", "&lt;")
      .replace(">", "&gt;")
      .replace("&", "&amp;")
      .replace("'", "&#39;")
      .replace("\"", "&quot;")
  }

  // 参考 `android.text.TextUtils.htmlEncode`
  static htmlDecode(str: string): string {
    return str.replace("&lt;", "<")
      .replace("&gt;", ">")
      .replace("&amp;", "&")
      .replace("&#39;", "'")
      .replace("&apos;", "'")// 兼容 &apos;
      .replace("&quot;", "\"")
  }
}