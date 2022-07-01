<template>
  <div>Hello {{ state.a }}!</div>
  <button @click="state.hello">按钮</button>
  <p>{{ state.myAdd(state.a)(2) }}</p>
  <button @click="state.increase(state)()">按钮</button>
</template>

<script lang="ts">
import { getCurrentInstance } from "vue"

export default {
  setup() {
    var { proxy } = getCurrentInstance() as any
    var state = proxy.state
    console.log(state)
    return { state }
  },
}
</script>
