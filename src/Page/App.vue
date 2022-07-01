<template>
  <div>Hello {{ state.a }}!</div>
  <button @click="event.increase()">按钮</button>
</template>

<script lang="ts">
import { getCurrentInstance } from "vue"

export default {
  setup() {
    var { proxy } = getCurrentInstance() as any
    var state = proxy.state
    var event = proxy.event
    console.log(state, event)
    return { state, event }
  },
}
</script>
