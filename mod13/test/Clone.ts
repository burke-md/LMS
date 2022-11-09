import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Clone", function () {
    async function deploymentFixture() {
        const [owner] = await ethers.getSigners();

        const ClonesFactory = await ethers.getContractFactory("Clones");
        const clones = await ClonesFactory.deploy();

        const CloneMakerFactory = await ethers.getContractFactory("CloneMaker");
        const cloneMaker = await CloneMakerFactory.deploy();

        const StandardTokenFactory = await ethers.getContractFactory("StandardToken");
        const standardToken = await StandardTokenFactory.deploy();

        console.log(`clones lib      address    :${clones.address}`);
        console.log(`cloneMaker      address    :${cloneMaker.address}`);
        console.log(`standardToken   address    :${standardToken.address}`);

        return { clones, cloneMaker, standardToken, owner };
    }

    describe("Deployment", function () {
        it("Should deploy StandardToken clone", async function () {
            const { clones, cloneMaker, standardToken, owner } = 
                await loadFixture(deploymentFixture);

            expect(true).to.equal(true);
        });
    });
});
