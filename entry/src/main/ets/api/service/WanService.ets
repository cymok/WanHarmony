import { ApiPath } from '../ApiPath';
import ApiService from '../ApiService';
import { Articles, ArticlesTree, DataX } from '../../data/ArticlesTree';
import { CommentList } from '../../data/CommentList';
import { BannerItem } from '../../data/BannerItem';

export class WanService extends ApiService {
  // banner
  async getBanner(): Promise<BannerItem[]> {
    return this.request<BannerItem[]>('get', ApiPath.BANNER);
  }

  // 置顶文章
  async getHomeTopList(): Promise<DataX[]> {
    return this.request<DataX[]>('get', ApiPath.HOME_TOP_LIST);
  }

  // 首页文章列表
  async getHomeList(page: number = 0, pageSize: number = 10): Promise<Articles> {
    const map = new Map<string, string>();
    map.set("page", String(page));
    map.set("page_size", String(pageSize));
    return this.request<Articles>('get', ApiPath.HOME_LIST(page), map);
  }

  // 项目分类
  async getProjectTree(): Promise<ArticlesTree> {
    return this.request<ArticlesTree>('get', ApiPath.PROJECT_TREE);
  }

  // 项目列表数据
  async getProjectList(id: number, page: number = 1, pageSize: number = 10): Promise<Articles> {
    const map = new Map<string, string>();
    map.set("cid", String(id));
    map.set("page_size", String(pageSize));
    return this.request<Articles>('get', ApiPath.PROJECT_LIST(page), map);
  }

  // 最新项目 Tab
  async getNewProjectList(page: number = 0, pageSize: number = 10): Promise<Articles> {
    const map = new Map<string, string>();
    map.set("page", String(page));
    map.set("page_size", String(pageSize));
    return this.request<Articles>('get', ApiPath.NEW_PROJECT_LIST(page), map);
  }

  // 广场列表数据
  async getSquareList(page: number = 0, pageSize: number = 10): Promise<Articles> {
    const map = new Map<string, string>();
    map.set("page_size", pageSize.toString());
    return this.request<Articles>('get', ApiPath.SQUARE_LIST(page), map);
  }

  // 分享人对应列表数据
  async getUserShareList(id: number, page: number = 1): Promise<Articles> {
    return this.request<Articles>('get', ApiPath.USER_SHARE_LIST(id, page));
  }

  // 自己的分享的文章列表
  async getMyShareList(page: number = 1): Promise<Articles> {
    return this.request<Articles>('get', ApiPath.MY_SHARE_LIST(page));
  }

  // 删除自己分享的文章
  async deleteMyShare(id: number): Promise<Articles> {
    return this.request<Articles>('post', ApiPath.DELETE_MY_SHARE(id));
  }

  // 分享文章
  async shareArticle(title: string, link: string): Promise<Articles> {
    const map = new Map<string, string>();
    map.set("title", title);
    map.set("link", link);
    return this.request<Articles>('post', ApiPath.SHARE_ARTICLE, map);
  }

  // 获取公众号列表
  async getWxArticleTree(): Promise<ArticlesTree> {
    return this.request<ArticlesTree>('get', ApiPath.WX_ARTICLE_TREE);
  }

  // 获取公众号历史数据
  async getWxArticleList(id: number, page: number = 1, pageSize: number = 10): Promise<Articles> {
    const map = new Map<string, string>();
    map.set("page", String(page));
    map.set("page_size", String(pageSize));
    return this.request<Articles>('get',
      ApiPath.WX_ARTICLE_LIST(id, page), map);
  }

  // 在某个公众号中搜索历史文章
  async searchWxArticleList(id: number, k: string, page: number = 1, pageSize: number = 10): Promise<Articles> {
    const map = new Map<string, string>();
    map.set("k", k);
    map.set("page_size", String(pageSize));
    return this.request<Articles>('get', ApiPath.SEARCH_WX_ARTICLE_LIST(id, k, page), map);
  }

  // 搜索
  async search(k: string, page: number = 0, pageSize: number = 10): Promise<Articles> {
    const map = new Map<string, string>();
    map.set("k", k);
    return this.request<Articles>('post', ApiPath.SEARCH(page), map);
  }

  // 问答
  async getQAList(page: number = 1): Promise<Articles> {
    return this.request<Articles>('get', ApiPath.QA_LIST(page));
  }

  // 问答评论列表
  async getQACommentList(id: number = 1, pageSize: number = 10): Promise<CommentList> {
    const map = new Map<string, string>();
    map.set("page_size", String(pageSize));
    return this.request<CommentList>('get', ApiPath.QA_COMMENT_LIST(id), map);
  }
}
