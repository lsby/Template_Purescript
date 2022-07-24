export type WebState = {
  counter: { __PURSTYPE__: "Model.Counter.Counter" },
  hello: string,
  inputTodo: string,
  n: number,
  toDoList: Array<string>
};
export type WebEvent = {
  getCounterNum: (a: { __PURSTYPE__: "Model.Counter.Counter" }) => number,
  onAddTodo: () => Promise<void>,
  onAsyncListener: () => Promise<void>,
  onAsyncSendTest: () => Promise<void>,
  onIncrease: () => Promise<void>,
  onMakeZero: () => Promise<void>,
  onSyncSendTest: () => Promise<void>,
  onUpdateTodoText: (a: string) => () => Promise<void>
};
