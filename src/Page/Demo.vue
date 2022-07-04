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
</template>

<script lang="ts">
import { getCurrentInstance } from "vue"
import { WebState, WebEvent } from "./Types"

export default {
  setup() {
    var { proxy } = getCurrentInstance() as any
    var s = proxy.state as WebState
    var e = proxy.event as WebEvent
    return { s, e }
  },
}
</script>
