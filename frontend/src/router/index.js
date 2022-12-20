import { createRouter, createWebHistory } from 'vue-router'
// import VueRouter from 'vue-router'
import loginPage from '@/components/loginPage.vue'
import personalHomePage from '@/components/personalHomePage.vue'
import raffle from '@/components/raffle.vue'
import Upgrade from '@/components/Upgrade.vue'
import marketHomePage from '@/components/marketPage.vue'
import userOwned from '@/components/myOwnedPage.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
        path: '/user',
        name: 'personalHomePage',
        component: personalHomePage
    },
    {
      path: '/userOwned',
      name: 'userOwned',
      component: userOwned
    },
    {
        path: '/raffle',
        name: 'raffle',
        component: raffle
    },
    {
        path: '/',
        name: 'loginPage',
        component: loginPage
    },
    {
      path: '/upgrade',
      name: 'Upgrade',
      component: Upgrade
    },
    {
      path: '/market',
      name: 'MarketPage',
      component: marketHomePage
    },
  ]
})

export default router
