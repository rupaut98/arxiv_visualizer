// app/frontend/store/index.js
import { createStore } from 'vuex'
import axios from 'axios'

export default createStore({
    state: {
      token: localStorage.getItem('token') || '',
      user: JSON.parse(localStorage.getItem('user') || '{}')
    },
    getters: {
      isLoggedIn: state => !!state.token,
      currentUser: state => state.user
    },
    mutations: {
      auth_success(state, { token, user }) {
        state.token = token
        state.user = user
        localStorage.setItem('user', JSON.stringify(user))
      },
      logout(state) {
        state.token = ''
        state.user = {}
        localStorage.removeItem('token')
        localStorage.removeItem('user')
      }
    },
  actions: {
    login({ commit }, user) {
      return new Promise((resolve, reject) => {
        axios.post('/api/v1/login', user)
          .then(resp => {
            const token = resp.data.token
            const user = resp.data.user
            localStorage.setItem('token', token)
            localStorage.setItem('user', JSON.stringify(user))
            axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
            commit('auth_success', { token, user })
            resolve(resp)
          })
          .catch(err => {
            localStorage.removeItem('token')
            localStorage.removeItem('user')
            reject(err)
          })
      })
    },
    register({ commit }, user) {
      return new Promise((resolve, reject) => {
        axios.post('/api/v1/register', user)
          .then(resp => {
            const token = resp.data.token
            const user = resp.data.user
            localStorage.setItem('token', token)
            localStorage.setItem('user', JSON.stringify(user))
            axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
            commit('auth_success', { token, user })
            resolve(resp)
          })
          .catch(err => {
            localStorage.removeItem('token')
            localStorage.removeItem('user')
            reject(err)
          })
      })
    },
    logout({ commit }) {
      return new Promise(resolve => {
        commit('logout')
        localStorage.removeItem('token')
        localStorage.removeItem('user')
        delete axios.defaults.headers.common['Authorization']
        resolve()
      })
    }
  }
})
