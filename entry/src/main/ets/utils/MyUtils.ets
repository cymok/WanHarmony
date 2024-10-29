// 可以在 build 里面对使用的实例做一些处理，函数返回值是实例本身
export function alsoKt<T>(obj: T, block: (it: T) => void): T {
  block(obj);
  return obj;
}

// 没有扩展函数 apply run 实现不了

// 可以在 build 里面对使用的实例做一些处理，函数返回值是 lambda 的返回值
export function letKt<T, R>(obj: T, block: (it: T) => R): R {
  return block(obj);
}
