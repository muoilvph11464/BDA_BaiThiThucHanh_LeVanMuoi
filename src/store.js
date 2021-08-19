import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    contract: {},
    address : ''
  },
  getters: {
    getAddress: (state) => state.address,
    getContract: (state) => state.contract,
  },
  mutations: {
    SET_CONTRACT: (state, contract) =>{
      state.contract = contract
    },
    SET_ADDRESS: (state, address) => {
      state.address = address
    },
    
  },
  
  actions: {
    changeCurrentAddress({ commit }, address) {
      commit("SET_ADDRESS", address);
    },
  },
})
