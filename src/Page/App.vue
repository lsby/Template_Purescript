<template>
  <div>{{ state.hello }}!</div>
  <div>{{ state.n }}</div>
  <button @click="event.increase()">增加</button>
  <button @click="event.makeZero()">归零</button>
  <button @click="event.testElectronSync()">测试electron同步事件</button>
  <button @click="event.testElectronAsync_on()">
    测试electron异步事件_打开监听
  </button>
  <button @click="event.testElectronAsync_send()">
    测试electron异步事件_发送
  </button>
</template>

<script lang="ts">
import { getCurrentInstance } from "vue"

export default {
  setup() {
    var { proxy } = getCurrentInstance() as any
    var { state, event } = proxy
    return { state, event }
  },
}
</script>
