import { createApp } from "vue"
import App from "./src/Page/App.vue"
import api from "./output/Web/index.js"

var app = createApp(App)
app.config.globalProperties.state = api.state
app.config.globalProperties.event = api.event
app.mount("#app")
