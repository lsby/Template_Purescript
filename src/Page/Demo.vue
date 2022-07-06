<template>
  <div>{{ s.hello }}</div>
  <div>{{ s.n }}</div>
  <button @click="e.increase()">增加</button>
  <button @click="e.makeZero()">归零</button>
  <button @click="e.testElectronSync()">测试electron同步事件</button>
  <button @click="e.testElectronAsync_on()">
    测试electron异步事件_打开监听
  </button>
  <button @click="e.testElectronAsync_send()">测试electron异步事件_发送</button>
  <div>
    <label>请输入</label
    ><input
      type="text"
      @input="(a) => e.inputTodo(a.target.value)()"
      :value="s.inputTodo"
    /><button @click="e.addTodo()">添加</button>
    <li v-for="(item, index) in s.toDoList" :key="index">{{ item }}</li>
  </div>
</template>

<script lang="ts">
import { getCurrentInstance } from "vue"
import { WebState, WebEvent } from "./Types"

export default {
  setup() {
    var { proxy } = getCurrentInstance() as any
    var s = proxy.state as WebState
    var e = proxy.event as WebEvent
    return { s, e, w: window }
  },
}
</script>
