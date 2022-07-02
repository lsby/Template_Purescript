<template>
  <Demo></Demo>
</template>

<script lang="ts">
import { getCurrentInstance } from "vue"
import Demo from "./Demo.vue"

export default {
  components: {
    Demo,
  },
  setup() {
    var { proxy } = getCurrentInstance() as any
    var { state, event } = proxy
    return { state, event }
  },
}
</script>
