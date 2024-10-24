export class SupperUserInfo {
  coinInfo: CoinInfo | null = null;
  collectArticleInfo: CollectArticleInfo | null = null;
  userInfo: UserInfo = new UserInfo();
}

export class UserInfo {
  admin: boolean = false
  chapterTops: Array<object> = []
  coinCount: number = -1
  collectIds: Array<number> = []
  email: string = "null"
  icon: string = ""
  id: number = -1
  nickname: string = "未登录"
  password: string = ""
  publicName: string = ""
  token: string = ""
  type: number = -1
  username: string = "null"
}

export class CoinInfo {
  coinCount: number = -1;
  level: number = -1;
  nickname: string = "";
  rank: number = -1;
  userId: number = -1;
  username: string = "";
}

export class CollectArticleInfo {
  count: number = -1;
}
