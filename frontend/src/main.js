/**
 * main.js
 *
 * Bootstraps Vuetify and other plugins then mounts the App`
 */

// Components
import App from './App.vue'
import router from './router'
import contract from './utils/contract'

// Composables
import { createApp } from 'vue'

// Plugins
import { registerPlugins } from '@/plugins'

const app = createApp(App)
app.config.globalProperties.account = null
app.config.globalProperties.productionTip = false
app.config.globalProperties.contract = contract.contract
app.use(router)
registerPlugins(app)

app.mount('#app')
