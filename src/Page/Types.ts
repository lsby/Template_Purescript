export type WebState = {
  hello: string,
  inputTodo: "PureType_ToDoItem",
  n: "PureType_Counter",
  toDoList: Array<"PureType_ToDoItem">
};
export type WebEvent = {
  onAddTodo: () => Promise<void>,
  onAsyncListener: () => Promise<void>,
  onAsyncSendTest: () => Promise<void>,
  onIncrease: () => Promise<void>,
  onMakeZero: () => Promise<void>,
  onSyncSendTest: () => Promise<void>,
  onUpdateTodoText: (a: "PureType_ToDoItem") => () => Promise<void>
};
