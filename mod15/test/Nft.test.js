const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

const regularProofs = {
  user1Proof:["0x0000000000000000000000003c44cdddb6a900fa2b585dd299e03d12fa4293bc","0x00000000000000000000000090f79bf6eb2c4f870365e785982e1f101e93b906"],
  user2Proof:["0x00000000000000000000000070997970c51812dc3a010c7d01b50e0d17dc79c8","0x00000000000000000000000090f79bf6eb2c4f870365e785982e1f101e93b906"],
  user3Proof:["0x43c8bee048e0480d644b3fe14e67fe0bf976d6ec2c649e37c28719ce63f6a1c8"]
}
const bitmapProofs = {}

describe("Advanced Nft", function () {
  async function deployFixture() {
    const [owner, user1, user2, user3, user4, user5, user6] = await ethers.getSigners();

    const Nft721 = await ethers.getContractFactory("Nft721");
    const nft721 = await Nft721.deploy();

    return { nft721, user1, user4 };
  }

  describe("Bench mark gas", function () {
    it("Display gas estimate above", async function () {
      const { nft721, user1 } = await loadFixture(deployFixture);

      const gasEstimate = await nft721.connect(user1).whiteListMintMapping(regularProofs.user1Proof, {
        value: ethers.utils.parseEther('0.05')
            });

      console.log(`\t\tMerkle proof w/ mapping: ${gasEstimate.gasLimit.toString()}`);
    });

    xit("Display gas estimate above", async function () {
      const { nft721, user4 } = await loadFixture(deployFixture);
      console.log(`\t\tMerkle proof w/ bitmap: `);
    });
  });
  describe("Business Logic", function () {
    it("Should validate merkle proofs", async function () {
      const { nft721, user1 } = await loadFixture(deployFixture);

      await nft721.connect(user1).whiteListMintMapping(regularProofs.user1Proof, {
        value: ethers.utils.parseEther('0.05')
            });

      const numUser1Tokens = await nft721.balanceOf(user1.address);
      expect(numUser1Tokens).to.equal(Number(1));
    });
    xit("===test===", async function () {
      const { user1 } = await loadFixture(deployFixture);
      expect(true).to.equal(false);
    });
  });
});
