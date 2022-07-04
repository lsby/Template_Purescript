export type WebState = {
  hello: string,
  inputTodo: string,
  n: number,
  toDoList: string[]
};
export type WebEvent = {
  addTodo: () => Promise<void>,
  increase: () => Promise<void>,
  inputTodo: (a: string) => () => Promise<void>,
  makeZero: () => Promise<void>,
  testElectronAsync_on: () => Promise<void>,
  testElectronAsync_send: () => Promise<void>,
  testElectronSync: () => Promise<void>
};
