const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("Lock", function () {
  async function deployFixture() {
    const [owner, user1] = await ethers.getSigners();

    //const Lock = await ethers.getContractFactory("Lock");
    //const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

    //return { lock, unlockTime, lockedAmount, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("===test===", async function () {
      expect(true).to.equal(false);
    });

  });
});
