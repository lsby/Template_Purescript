export type WebState = {
  hello: string,
  inputTodo: string,
  n: number,
  toDoList: string[]
};
export type WebEvent = {
  onAddTodo: () => Promise<void>,
  onAsyncListener: () => Promise<void>,
  onAsyncSendTest: () => Promise<void>,
  onIncrease: () => Promise<void>,
  onMakeZero: () => Promise<void>,
  onSyncSendTest: () => Promise<void>,
  onUpdateTodoText: (a: string) => () => Promise<void>
};
