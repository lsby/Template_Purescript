<template>
  <div>Hello {{ state.name }}!</div>
</template>

<script>
var { state } = require("./State.js")

export default {
  setup() {
    state.name = "aaa"
    return { state }
  },
}
</script>
