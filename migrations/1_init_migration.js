import { artifacts } from "truffle";

const Migrations = artifacts.require("Migrations");

export default function(deployer) {
  deployer.deploy(Migrations);
}
