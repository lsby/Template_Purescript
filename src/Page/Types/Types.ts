type WebState = {
  counter: number
  hello: string
  inputTodo: string
  toDoList: Array<string>
}
type WebEvent = {
  onAddTodo: () => Promise<{}>
  onAsyncListener: () => Promise<{}>
  onAsyncSendTest: () => Promise<{}>
  onIncrease: () => Promise<{}>
  onMakeZero: () => Promise<{}>
  onSyncSendTest: () => Promise<{}>
  onUpdateTodoText: (a: string) => () => Promise<{}>
}
