import { SupperUserInfo, UserInfo } from '../../data/UserInfo';
import { ApiPath } from '../ApiPath';
import ApiService from '../ApiService';

export class UserService extends ApiService {
  // 注册
  async register(username: string, password: string, repassword: string): Promise<UserInfo | null> {
    let map = new Map<string, string>()
    map.set("username", username)
    map.set("password", password)
    map.set("repassword", repassword)
    return this.request<UserInfo>('post', ApiPath.USER_REGISTER, map)
  }

  // 登录
  async login(username: string, password: string): Promise<UserInfo | null> {
    let map = new Map<string, string>()
    map.set("username", username)
    map.set("password", password)
    return this.request<UserInfo>('post', ApiPath.USER_LOGIN, map)
  }

  // 登出
  async logout(): Promise<null> {
    return this.request<null>('get', ApiPath.USER_LOGOUT)
  }

  // 个人信息接口
  async getUserInfo(): Promise<SupperUserInfo | null> {
    let result = this.request<SupperUserInfo>('get', ApiPath.USER_INFO);
    AppStorage.setOrCreate("SupperUserInfo", JSON.stringify(result))
    return result;
  }

  // 未读消息数量
  async getUnreadMessage(): Promise<string> {
    return this.request<string>('get', ApiPath.UNREAD_MESSAGE_COUNT);
  }

  // 已读消息列表
  async getReadMessage(page: number = 1): Promise<string> {
    return this.request<string>('get', ApiPath.READ_MESSAGE_LIST(page));
  }

  // 未读消息列表
  async getUnreadMessageList(page: number = 1): Promise<string> {
    return this.request<string>('get', ApiPath.UNREAD_MESSAGE_LIST(page));
  }
}
