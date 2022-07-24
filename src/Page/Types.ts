export type WebState = {
  counter: "Counter",
  hello: string,
  inputTodo: string,
  toDoList: Array<string>
};
export type WebEvent = {
  getCounterNum: (a: "Counter") => number,
  onAddTodo: () => Promise<void>,
  onAsyncListener: () => Promise<void>,
  onAsyncSendTest: () => Promise<void>,
  onIncrease: () => Promise<void>,
  onMakeZero: () => Promise<void>,
  onSyncSendTest: () => Promise<void>,
  onUpdateTodoText: (a: string) => () => Promise<void>
};
