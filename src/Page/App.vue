<template>
  <div>{{ state.hello }}!</div>
  <div>{{ state.n }}</div>
  <button @click="event.increase()">增加</button>
  <button @click="event.makeZero()">归零</button>
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
