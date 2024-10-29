export class WebData {
  url: string
  title: string
  time: string
  sticky: boolean

  constructor(url: string = "", title: string = "", time: string = "", sticky: boolean = false) {
    this.url = url;
    this.title = title;
    this.time = time;
    this.sticky = sticky;
  }
}