export class ApiException extends Error {
  errorCode: number

  constructor(errorCode: number, errorMsg: string) {
    super(errorMsg);
    this.errorCode = errorCode
  }
}

export class ApiResult<T> {
  errorCode: number = 0
  errorMsg: string = ""
  data: T | null = null;

  apiData(): T | null {
    // 根据前后端约定具体规则
    if (this.errorCode === 0) {
      return this.data;
    } else {
      throw new ApiException(this.errorCode, this.errorMsg);
    }
  }
}
