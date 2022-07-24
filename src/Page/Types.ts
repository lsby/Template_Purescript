export type WebState = {
  counter: "_PURETYPE_Counter_",
  hello: string,
  inputTodo: string,
  toDoList: Array<string>
};
export type WebEvent = {
  getCounterNum: (a: "_PURETYPE_Counter_") => number,
  onAddTodo: () => Promise<void>,
  onAsyncListener: () => Promise<void>,
  onAsyncSendTest: () => Promise<void>,
  onIncrease: () => Promise<void>,
  onMakeZero: () => Promise<void>,
  onSyncSendTest: () => Promise<void>,
  onUpdateTodoText: (a: string) => () => Promise<void>
};
