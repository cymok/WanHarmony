export class CookiesUtils {
  static formatWanAndroidCookies(cookies: string): string {
    /*
    这是某次返回的 cookies。可见 一共有5个，index=5 的是名称，index=6 的是值
```
#HttpOnly_www.wanandroid.com	FALSE	/	TRUE	0	JSESSIONID	84D02569FC8883FD676A1439F8F6CD909527
 www.wanandroid.com	FALSE	/	FALSE	1732222984	loginUserName	cymok
 www.wanandroid.com	FALSE	/	FALSE	1732222984	token_pass	7c934a41fee93d67b5bcc9c25d498f48
 .wanandroid.com	TRUE	/	FALSE	1732222984	loginUserName_wanandroid_com	cymok
 .wanandroid.com	TRUE	/	FALSE	1732222984	token_pass_wanandroid_com	7c934a41fee93d67b5bcc9c25d498f48
```
    */
    try {
      const cookieArray = cookies.trim().split('\n')
      const formattedCookies = cookieArray.map(line => {
        const parts = line.split('\t')
        return `${parts[5]}=${parts[6]}` // parts[5] 是 cookie 名称，parts[6] 是 cookie 值
      }).join('; ')
      return formattedCookies
    } catch (e) {
      return ""
    }
  }
}