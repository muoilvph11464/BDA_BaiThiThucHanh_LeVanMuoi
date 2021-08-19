import NganHang from "./build/NganHang.json";

export default (web3) => {
  return new web3.eth.Contract(
    NganHang.abi,
    "0x205ef40e6E01f15c7F4ef5058d8629E4C1d30Fc0"
  );
};