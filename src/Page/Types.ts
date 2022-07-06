export type WebState = {
  hello: string,
  inputTodo: string,
  n: number,
  toDoList: string[]
};
export type WebEvent = {
  onClick_AddTodo: () => Promise<void>,
  onClick_AsyncListener: () => Promise<void>,
  onClick_AsyncSendTest: () => Promise<void>,
  onClick_Increase: () => Promise<void>,
  onClick_MakeZero: () => Promise<void>,
  onClick_SyncSendTest: () => Promise<void>,
  onInput_Todo: (a: string) => () => Promise<void>
};
