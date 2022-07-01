import { createApp } from "vue"
import App from "./src/Page/App.vue"
import api from "./output/Web/index.js"

async function main() {
  var app = createApp(App)
  app.config.globalProperties.state = await api.state()
  app.config.globalProperties.event = await api.event()
  app.mount("#app")
}
main()
