export class CommentList {
  curPage: number = 0;
  datas: Comment[] = [];
  offset: number = 0;
  over: boolean = false;
  pageCount: number = 0;
  size: number = 0;
  total: number = 0;
}

export class Comment {
  anonymous: number = 0;
  appendForContent: number = 0;
  articleId: number = 0;
  canEdit: boolean = false;
  content: string = "";
  contentMd: string = "";
  id: number = 0;
  niceDate: string = "";
  publishDate: number = 0;
  replyCommentId: number = 0;
  replyComments: ReplyComment[] = [];
  rootCommentId: number = 0;
  status: number = 0;
  toUserId: number = 0;
  toUserName: string = "";
  userId: number = 0;
  userName: string = "";
  zan: number = 0;
}

export class ReplyComment {
  anonymous: number = 0;
  appendForContent: number = 0;
  articleId: number = 0;
  canEdit: boolean = false;
  content: string = "";
  contentMd: string = "";
  id: number = 0;
  niceDate: string = "";
  publishDate: number = 0;
  replyCommentId: number = 0;
  replyComments: object[] = [];
  rootCommentId: number = 0;
  status: number = 0;
  toUserId: number = 0;
  toUserName: string = "";
  userId: number = 0;
  userName: string = "";
  zan: number = 0;
}
