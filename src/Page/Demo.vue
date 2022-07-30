<template>
  <div>{{ s.hello }}</div>
  <div>{{ s.counter }}</div>
  <button @click="e.onIncrease()">增加</button>
  <button @click="e.onMakeZero()">归零</button>
  <button @click="e.onSyncSendTest()">测试electron同步事件</button>
  <button @click="e.onAsyncListener()">测试electron异步事件_打开监听</button>
  <button @click="e.onAsyncSendTest()">测试electron异步事件_发送</button>
  <div>
    <label>请输入</label
    ><input
      type="text"
      @input="(a) => onInput(a)"
      :value="s.inputTodo"
    /><button @click="e.onAddTodo()">添加</button>
    <li v-for="(item, index) in s.toDoList" :key="index">{{ item }}</li>
  </div>
</template>

<script lang="ts" setup>
import { getCurrentInstance } from "vue"
import { WebState, WebEvent } from "./Types"

var { proxy } = getCurrentInstance() as any
var s = proxy.state as WebState
var e = proxy.event as WebEvent

function onInput(a: any) {
  e.onUpdateTodoText(a.target.value)()
}
</script>
