<template>
  <div id="main" class="d-flex justify-content-center align-items-center">
    <div id="nav" class="row">
      <button type="button" class="btn btn-primary mb-4" @click="connectWallet">
        Connect Wallet
      </button>
      <!-- <input id="address" v-model="address" type="text" placeholder="" class="mr-3 mt-4" /> -->
      <p>{{ getAddress }}</p>

      <!-- <router-link to="/payments"><button type="button" class="btn btn-primary">Go to Payments</button></router-link> -->
    </div>
    <div id="body" class="row">
      <button type="button" class="btn btn-primary mb-4" @click="chuyenTien">
        Chuyển tiền
      </button>
      <!-- <input id="address" v-model="address" type="text" placeholder="" class="mr-3 mt-4" /> -->
      <input v-model="addNguoiNhan" type="text" />
      <input v-model="soTien" type="text" />
      <!-- <router-link to="/payments"><button type="button" class="btn btn-primary">Go to Payments</button></router-link> -->
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import getContract from "../../dapp/compile";
// import PaymentsService from "../domain/PaymentsService.js";
import web3 from "../domain/web3";
export default {
  name: "home",
  data: function () {
    return {
      address: "",
      addNguoiNhan: "",
      soTien : 0
    };
  },
  computed: {
    ...mapGetters({ getAddress: "getAddress" }),
    ...mapGetters({ getContract: "getContract" }),
  },
  mounted() {
    this.connectWallet();
  },
  methods: {
    async connectWallet() {
      // const paymentsService = new PaymentsService();
      try {
        // this.address = await paymentsService.getLoggedAccount();
        // this.$store.commit("SET_ADDRESS", this.address);
        web3().then((result) => {
          if (result) {
            result.eth.getAccounts().then((res) => {
              this.$store.commit("SET_ADDRESS", res[0]);
            });
            const contract = getContract(result);
            this.$store.commit("SET_CONTRACT", contract);
          }
        });
      } catch (e) {
        console.log(e);
      }
    },
    async chuyenTien() {
      if (!this.addNguoiNhan == "" || !this.addNguoiNhan.length < 10 || !this.soTien == 0) {
        getContract.methods.chuyenTien(this.addNguoiNhan , this.soTien);
      }
    },
    ...mapActions(["changeCurrentAddress"]),
  },
};
</script>

<style scope>
#nav {
  width: 100%;
  border: 1px solid black;
  position: fixed;
  padding-top: 100px;
  display: inline;
}
#body {

  margin-top: 300px;
}
</style>