export class ApiPath {
  static readonly BASE_URL: string = "https://www.wanandroid.com/"
  // 注册
  static readonly USER_REGISTER = '/user/register';
  // 登录
  static readonly USER_LOGIN = '/user/login';
  // 登出
  static readonly USER_LOGOUT = '/user/logout/json';
  // 个人信息接口
  static readonly USER_INFO = '/user/lg/userinfo/json';
  // 未读消息数量
  static readonly UNREAD_MESSAGE_COUNT = '/message/lg/count_unread/json';
  // 已读消息列表
  static readonly READ_MESSAGE_LIST = (page: number) => `/message/lg/readed_list/${page}/json`;
  // 未读消息列表
  static readonly UNREAD_MESSAGE_LIST = (page: number) => `/message/lg/unread_list/${page}/json`;
  // 首页
  static readonly BANNER = "/banner/json";
  static readonly HOME_TOP_LIST = "/article/top/json";
  static readonly HOME_LIST = (page: number) => `/article/list/${page}/json`;
  // 项目
  static readonly PROJECT_TREE = "/project/tree/json";
  static readonly PROJECT_LIST = (page: number) => `/project/list/${page}/json`;
  static readonly NEW_PROJECT_LIST = (page: number) => `/article/listproject/${page}/json`;
  // 公众号
  static readonly WX_ARTICLE_TREE = "/wxarticle/chapters/json";
  static readonly WX_ARTICLE_LIST = (id: number, page: number) => `/wxarticle/list/${id}/${page}/json`;
  static readonly SEARCH_WX_ARTICLE_LIST =
    (id: number, k: string, page: number) => `/wxarticle/list/${id}/${page}/json?k=${k}`;
  // 搜索
  static readonly SEARCH = (page: number) => `/article/query/${page}/json`;
  // 问答
  static readonly QA_LIST = (page: number) => `/wenda/list/${page}/json`;
  static readonly QA_COMMENT_LIST = (id: number) => `/wenda/comments/${id}/json`;
  // 广场
  static readonly SQUARE_LIST = (page: number) => `/user_article/list/${page}/json`;
  static readonly USER_SHARE_LIST = (id: number, page: number) => `/user/${id}/share_articles/${page}/json`;
  static readonly MY_SHARE_LIST = (page: number) => `/user/lg/private_articles/${page}/json`;
  static readonly DELETE_MY_SHARE = (id: number) => `/lg/user_article/delete/${id}/json`;
  static readonly SHARE_ARTICLE = `/lg/user_article/add/json`;
}
