export class ArticlesTree extends Array<ArticlesTreeItem> {
  constructor() {
    super();
  }
}

export class ArticlesTreeItem {
  articleList: Array<Articles> = []
  author: string = ""
  children: Array<ArticlesTreeItem> = []
  courseId: number = 0
  cover: string = ""
  desc: string = ""
  id: number = 0
  lisense: string = ""
  lisenseLink: string = ""
  name: string = ""
  order: number = 0
  parentChapterId: number = 0
  type: number = 0
  userControlSetTop: boolean = false
  visible: number = 0
}

export class Articles {
  curPage: number = 0
  datas: Array<DataX> = []
  offset: number = 0
  over: boolean = false
  pageCount: number = 0
  size: number = 0
  total: number = 0
}

export class DataX {
  adminAdd: boolean = false
  apkLink: string = ""
  audit: number = 0
  author: string = ""
  canEdit: boolean = false
  chapterId: number = 0
  chapterName: string = ""
  collect: boolean = false
  courseId: number = 0
  desc: string = ""
  descMd: string = ""
  envelopePic: string = ""
  fresh: boolean = false
  host: string = ""
  id: number = 0
  isAdminAdd: boolean = false
  link: string = ""
  niceDate: string = ""
  niceShareDate: string = ""
  origin: string = ""
  originId: number = 0
  prefix: string = ""
  projectLink: string = ""
  publishTime: number = 0
  realSuperChapterId: number = 0
  selfVisible: number = 0
  shareDate: number = 0
  shareUser: string = ""
  superChapterId: number = 0
  superChapterName: string = ""
  tags: Array<Tag> | null = null
  title: string = ""
  type: number = 0
  userId: number = 0
  visible: number = 0
  zan: number = 0
}

export class Tag {
  name: string = ""
  url: string = ""
}
