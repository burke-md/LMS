const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

const regularProofs = {
  user1Proof:["0x0000000000000000000000003c44cdddb6a900fa2b585dd299e03d12fa4293bc","0x00000000000000000000000090f79bf6eb2c4f870365e785982e1f101e93b906"],
  user2Proof:["0x00000000000000000000000070997970c51812dc3a010c7d01b50e0d17dc79c8","0x00000000000000000000000090f79bf6eb2c4f870365e785982e1f101e93b906"],
  user3Proof:["0x43c8bee048e0480d644b3fe14e67fe0bf976d6ec2c649e37c28719ce63f6a1c8"]
}
const treeProofs = {
  user4Proof:["0x7b270d066cad89ebcf19bf9932908634b38121e1a0f5c70ba7459d8234cb721d","0xf55f0dad9adfe0f2aa1946779b3ca83c165360edef49c6b72ddc0e2f070f7ff6"],
  user5Proof:["0x95cecffd2fc1ecfcd6d165dd1f886bde991548dccdcfb8592b3fa17f776d70b9"],
  user5Proof:["0x2c70357a690b685ecef91703e08c73f3be5a8fe584b65cb1de18eb9dd3308dcd","0xf55f0dad9adfe0f2aa1946779b3ca83c165360edef49c6b72ddc0e2f070f7ff6"]

}

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
    it("Should validate regular merkle proofs", async function () {
      const { nft721, user1 } = await loadFixture(deployFixture);

      await nft721.connect(user1).whiteListMintMapping(regularProofs.user1Proof, {
        value: ethers.utils.parseEther('0.05')
            });

      const numUser1Tokens = await nft721.balanceOf(user1.address);
      expect(numUser1Tokens).to.equal(Number(1));
    });
    it("Should validate special merkle proofs (address hashed w/ ticket", async function () {
      const { nft721, user4 } = await loadFixture(deployFixture);

      await nft721.connect(user4).whiteListMintBitmap(treeProofs.user4Proof, 4, {
        value: ethers.utils.parseEther('0.05')
            });

      const numUser4Tokens = await nft721.balanceOf(user4.address);
      expect(numUser4Tokens).to.equal(Number(1));
    });
    xit("===test===", async function () {
      const { user1 } = await loadFixture(deployFixture);
      expect(true).to.equal(false);
    });
  });
});
