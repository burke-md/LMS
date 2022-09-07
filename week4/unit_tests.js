const { expect, use } = require('chai');
const { ethers } = require('hardhat');
const { MerkleTree } = require('merkletreejs')
const { keccak256 } = ethers.utils;
const { BigNumber, utils } = ethers;

use(require('chai-as-promised'));

function revertReason(reason) {
    return `VM Exception while processing transaction: reverted with reason string '${reason}'`;
}

const TOKEN_PRICE = "0.07";

describe('The Contract proxy:', function () {
    let instance = null;
    beforeEach(async function () {
        const ContractFactory = await ethers.getContractFactory("Contract");
        instance = await upgrades.deployProxy(ContractFactory);
        await instance.deployed();
    });

    it('Should deploy contract upgrade w/ updated minting implementation', async () => {
        const ContractV2 = await ethers.getContractFactory("ContractV2");
        const upgradeContract = async () => {
            await upgrades.upgradeProxy(instance.address, ContractV2);
        }
        expect(upgradeContract).not.to.throw();
    });
  
    it('Should maintain state values after upgrade.', async () => {
        const ContractV2 = await ethers.getContractFactory("ContractV2");
        await instance.setMetaData("ipfs://Qm123/");

        const upgraded = await upgrades.upgradeProxy(instance.address, ContractV2);
        const uri = await upgraded.base_uri();

        expect(uri).to.equal("ipfs://Qm123/");
    });

    it('Should retrieve data (uri) from updated contract acurately.', async () => {
        const ContractV2 = await ethers.getContractFactory("ContractV2");
        const upgraded = await upgrades.upgradeProxy(instance.address, ContractV2);

        await upgraded.setMetaData("ipfs://Qm/"); 
        const uri = await upgraded.base_uri(); 
        expect(uri).to.equal("ipfs://Qm/"); 
    }); 
});

describe('The Contract minting:', function () {
    let instance = null;
    beforeEach(async function () {
        const ContractFactory = await ethers.getContractFactory("Contract");
        instance = await upgrades.deployProxy(ContractFactory);
        await instance.deployed();
    });

    it('Should respect open/closed public mint setter.', async () => {
        await expect(instance.publicMint())
            .to.be.rejectedWith(revertReason(
                'Contract: Public minting is not available at this time.'));

        await instance.setPublicMint(true);
        expect(instance.publicMint({
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.not.be.rejected;
        expect(await instance.tokenIdCounter()).to.eql(new BigNumber.from('1'));
    });

    it('Should respect max supply.', async () => {
        await instance.setPublicMint(true);

        const setLowSupply = await instance.setSupply(3);
        await setLowSupply.wait();

        await expect(instance.publicMint({
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.not.be.rejected;
        
        await expect(instance.publicMint({
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.not.be.rejected;

        await expect(instance.publicMint({
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.not.be.rejected;

        await expect(instance.publicMint({
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.be.rejectedWith(revertReason(
                    "Contract: This minting would exceed max token supply."));

        expect(await instance.tokenIdCounter()).to.eql(new BigNumber.from('3'));
    });

    it('Should respect token price.', async () => {
        await instance.setPublicMint(true);
        await expect(instance.publicMint({
            value: ethers.utils.parseEther("0.1")
                })).to.be.rejectedWith(revertReason(
                    "Contract: Please review mint price."));
        await expect(instance.publicMint({
            value: ethers.utils.parseEther("0.0009")
                })).to.be.rejectedWith(revertReason(
                    "Contract: Please review mint price."));
    });

    it('Should increment token counter on public mint', async () => {
        await instance.setPublicMint(true);

        expect(await instance.tokenIdCounter()).to.eql(new BigNumber.from('0'));
        await instance.publicMint({
            value: ethers.utils.parseEther(TOKEN_PRICE)});
        expect(await instance.tokenIdCounter()).to.eql(new BigNumber.from('1'));
    });
});

xdescribe('The Contract allowlist minting: ', function () {
    let instance = null;
    let merkleProof0;
    let merkleProof1;
    let merkleProof2;
    let invalidMerkleProof;

    beforeEach(async function () {
        const ContractFactory = await ethers.getContractFactory("Contract");
        instance = await upgrades.deployProxy(ContractFactory);
        await instance.deployed();

        const accounts = await hre.ethers.getSigners()
        const whitelisted = accounts.slice(0, 5)
        const notWhitelisted = accounts.slice(5, 10)

        const padBuffer = (addr) => {
            return Buffer.from(addr.substr(2).padStart(32*2, 0), 'hex')
        }

        const leaves = whitelisted.map(account => padBuffer(account.address))
        const tree = new MerkleTree(leaves, keccak256, { sort: true })
        const merkleRoot = tree.getHexRoot()

        merkleProof0 = tree.getHexProof(padBuffer(whitelisted[0].address))
        merkleProof1 = tree.getHexProof(padBuffer(whitelisted[1].address))
        merkleProof2 = tree.getHexProof(padBuffer(whitelisted[2].address))
        invalidMerkleProof = tree.getHexProof(padBuffer(notWhitelisted[0].address))

        const setRoot = await instance.setMerkleRoot(merkleRoot);
        await setRoot.wait();
    });

    it('Should mint token via allowlist.', async () => {
        const [acct0] = await ethers.getSigners();
        const openAlMint = await instance.setAlMint(true);
        const setLowSupply = await instance.setSupply(1);

        await setLowSupply.wait();
        await openAlMint.wait();

        await expect(instance.connect(acct0).
            allowListMint(merkleProof0, {
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.not.be.rejected;
        expect(await instance.tokenIdCounter()).to.eql(new BigNumber.from('1'));
    });

    it('Should respect max token limit.', async () => {
        const [acct0] = await ethers.getSigners();
        const openAlMint = await instance.setAlMint(true);
        const setLowSupply = await instance.setSupply(2);

        await setLowSupply.wait();
        await openAlMint.wait();

        await expect(instance.connect(acct0).
            allowListMint(merkleProof0, {
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.not.be.rejected;

        await expect(instance.connect(acct0).
            allowListMint(merkleProof0, {
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.not.be.rejected;

        await expect(instance.connect(acct0).
            allowListMint(merkleProof0, {
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.be.rejectedWith(revertReason(
                    "Contract: This minting would exceed max token supply."));

        expect(await instance.tokenIdCounter()).to.eql(new BigNumber.from('2'));
    });

    it('Should respect token price', async () => {
        const [acct0] = await ethers.getSigners();
        const openAlMint = await instance.setAlMint(true);

        await expect(instance.connect(acct0).
            allowListMint(merkleProof0, {
            value: ethers.utils.parseEther("0.1")
                })).to.be.rejectedWith(revertReason(
                    "Contract: Please review mint price."));

        await expect(instance.connect(acct0).
            allowListMint(merkleProof0, {
            value: ethers.utils.parseEther("0.0009")
                })).to.be.rejectedWith(revertReason(
                    "Contract: Please review mint price."));
    });

    it('Should reject invalid proof.', async () => {
        const [acct0] = await ethers.getSigners();
        const openAlMint = await instance.setAlMint(true);

        await expect(instance.connect(acct0).
            allowListMint(invalidMerkleProof, {
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.be.rejectedWith(revertReason(
                    "Contract: Invalid proof."));
    });

    it('Should reject wrong proof.', async () => {
        const [acct0] = await ethers.getSigners();
        const openAlMint = await instance.setAlMint(true);

        await expect(instance.connect(acct0).
            allowListMint(merkleProof1, {
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.be.rejectedWith(revertReason(
                    "Contract: Invalid proof."));
    });

    it('Should limit al mint to 2 tokens', async () => {
        const [acct0] = await ethers.getSigners();
        const openAlMint = await instance.setAlMint(true);

        await expect(instance.connect(acct0).
            allowListMint(merkleProof0, {
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.not.be.rejected;

        await expect(instance.connect(acct0).
            allowListMint(merkleProof0, {
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.not.be.rejected;

        await expect(instance.connect(acct0).
            allowListMint(merkleProof0, {
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.be.rejectedWith(revertReason(
                    "Contract: This wallet address has already claimed available pre-sale NFT."));
    });
});

describe('The Contract URI:', function () {
    let instance = null;
    beforeEach(async function () {
        const ContractFactory = await ethers.getContractFactory("Contract");
        instance = await upgrades.deployProxy(ContractFactory);
        await instance.deployed();
    });

    it('Should return a dummy URI string immediately after deployment/initialization.', async () => {
        expect(await instance.base_uri()).to.equal("ipfs:///");
    });
  
    it('Should return an updated URI string after being set,', async () => {
        const setData = await instance.setMetaData("ipfs://abc/");
        await setData.wait();

        expect(await instance.base_uri()).to.equal("ipfs://abc/");
    });

    it('Should return an appropriate full URI pointer w/ specific token id after being set.', async () => {
        const setMintOpen = await instance.setPublicMint(true);
        const setData = await instance.setMetaData("ipfs://abc/");
        const mintOne = await instance.publicMint({
            value: ethers.utils.parseEther(TOKEN_PRICE)});

        await setMintOpen.wait();
        await setData.wait();
        await mintOne.wait();

        expect((await instance.tokenURI(1))).to.equal('ipfs://abc/1.json');
    });
});

describe('The Contract setters:', function () {
    let instance = null;
    let owner;
    let acct1;
    let admin;
    beforeEach(async function () {
        [owner, acct1, admin] = await ethers.getSigners();
        const ContractFactory = await ethers.getContractFactory("Contract");
        instance = await upgrades.deployProxy(ContractFactory);
        await instance.deployed();
    });

    it('Should restrict access to setSupply.', async () => {
        const updateSupplyOwner = instance.connect(owner).setSupply(1000);
        //const updateSupplyAdmin = instance.connect(admin).setSupply(2000);
        const updateSupplyAcct1 = instance.connect(acct1).setSupply(1000);

        await expect(updateSupplyOwner).to.be.not.rejected;
        //Test skipped because admin is set to multi sig wallet on public test
        //net. Do not have access to multisig wallet obj here for testing...
        //await expect(updateSupplyAdmin).to.be.not.rejected;
        await expect(updateSupplyAcct1).to.be.rejectedWith(revertReason(
            'Contract: Caller is not an Admin or contract owner.'));             
        expect(await instance.maxSupply()).to.eql(new BigNumber.from("1000"));
    });

    it('Should restrict access and properly update setPublicMint.', async () => {
        const updateSetPublicMintOwner = instance.connect(owner).setPublicMint(true);
        const updateSetPublicMintAcct1 = instance.connect(acct1).setPublicMint(true);

        expect(await instance.isMintOpen()).to.equal(false);
        await expect(updateSetPublicMintOwner).to.be.not.rejected;
        await expect(updateSetPublicMintAcct1).to.be.rejectedWith(revertReason(
            'Contract: Caller is not an Admin or contract owner.'));             
        expect(await instance.isMintOpen()).to.equal(true);
    });

    it('Should restrict access and properly update setAlMint.', async () => {
        const updateSetAlMintOwner = instance.connect(owner).setAlMint(true);
        const updateSetAlMintAcct1 = instance.connect(acct1).setAlMint(true);

        expect(await instance.isAlMintOpen()).to.equal(false);
        await expect(updateSetAlMintOwner).to.be.not.rejected;
        await expect(updateSetAlMintAcct1).to.be.rejectedWith(revertReason(
            'Contract: Caller is not an Admin or contract owner.'));             
        expect(await instance.isAlMintOpen()).to.equal(true);
    });

    it('Should transfer ownership w/o error.', async () => {
        const [owner, newOwner, acct2] = await ethers.getSigners();

        await expect(instance.transferOwnership(newOwner.address)).to.not.be.rejected;
        expect(await instance.owner()).to.equal(newOwner.address);
    });
});

describe('The Contract withdrawl:', function () {
    let instance = null;
    let provider = null;
    beforeEach(async function () {
        const ContractFactory = await ethers.getContractFactory("Contract");
        instance = await upgrades.deployProxy(ContractFactory);
        provider = await ethers.provider;

        await instance.deployed();
        await instance.setPublicMint(true);
    });

    it('Should reject users from calling withdraw.', async () => {
        const [owner, user, user2] = await ethers.getSigners();

        await expect(instance.connect(user).withdrawFunds(0))
            .to.be.rejectedWith(revertReason(
                "Contract: Caller is not an Admin or contract owner."));             
        await expect(instance.connect(user2).withdrawFunds(0))
            .to.be.rejectedWith(revertReason(
                "Contract: Caller is not an Admin or contract owner."));             
    });
    context("Owner withdrawl: ", async function () {
        it('Should have an initial conract of 0 eth', async () => {
            const contractBalance = await provider.getBalance(instance.address);
            expect(contractBalance).to.eql(new BigNumber.from("0"));
        });

        it('Should NOT reject the owner from calling withdrawl.', async () => {
            const mintToken = await instance.publicMint({
                value: ethers.utils.parseEther(TOKEN_PRICE)
                     });
            await mintToken.wait(); 

            const [owner, user, admin] = await ethers.getSigners();
            const twentyThousandEthInHex = utils.hexStripZeros(
                utils.parseEther("20000").toHexString());
            await provider.send("hardhat_setBalance", [
                owner.address,
                twentyThousandEthInHex,
            ]);

            const ownerBalance = await provider.getBalance(owner.address);
            const contractBalance = await provider.getBalance(instance.address);

            expect(contractBalance).to.eql(new BigNumber.from(utils.parseEther(TOKEN_PRICE)));
            expect(ownerBalance).to.eql(new BigNumber.from(utils.parseEther("20000")));
            await expect(instance.connect(owner)
                .withdrawFunds(utils.parseEther("0.0009"))).to.not.be.rejected;
            expect(await provider.getBalance(owner.address)).to.be.closeTo(
                new BigNumber.from(utils.parseEther("20000.001")),
                new BigNumber.from(utils.parseEther("0.0002")));
        });

        it('Should allow the new owner and reject the old owner after trasfering ownership', async () => {
            const [oldOwner, newOwner, user] = await ethers.getSigners();
            const mintToken = await instance.publicMint({
                value: ethers.utils.parseEther(TOKEN_PRICE)
                     });
            const transferOwnership = await instance.transferOwnership(newOwner.address);

            await mintToken.wait();
            await transferOwnership.wait();

            await expect(instance.connect(user).withdrawFunds(0))
                .to.be.rejectedWith(revertReason(
                    "Contract: Caller is not an Admin or contract owner."));             
            await expect(instance.connect(oldOwner).withdrawFunds(0))
                .to.be.rejectedWith(revertReason(
                    "Contract: Caller is not an Admin or contract owner."));             
            await expect(instance.connect(newOwner)
                .withdrawFunds(utils.parseEther("0.0005"))).to.not.be.rejected;
        });
    });
});

describe('The Contract custom events:', function () {
    let instance = null;
    beforeEach(async function () {
        const ContractFactory = await ethers.getContractFactory("Contract");
        instance = await upgrades.deployProxy(ContractFactory);
        await instance.deployed();
    });

    it('Should emit an event when the uri is set.', async () => {
        await expect(instance.setMetaData("ipfs://abcd/")).to.emit(instance, 'MetaDataReleased')
            .withArgs();
    });
  
    it('Should emit an event when the allowlist(WL) mint availability is toggled.', async () => {
        await expect(instance.setAlMint(true)).to.emit(instance, "AlMintToggle")
            .withArgs(true);
    });

    it('Should emit an event when the publicMint availability is toggled.', async () => {
        await expect(instance.setPublicMint(true)).to.emit(instance, "PublicMintToggle")
            .withArgs(true);
    });
});

describe('The Contract pausing:', function () {
    let instance = null;
    beforeEach(async function () {
        const ContractFactory = await ethers.getContractFactory("Contract");
        instance = await upgrades.deployProxy(ContractFactory);
        await instance.deployed();
    });

    it('Should toggle pause on and off and then mint w/o issue.', async () => {
        await instance.pause();
        await instance.unpause();
        await instance.setPublicMint(true);
        
        await expect(instance.publicMint({
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.not.be.rejected;
        expect(await instance.tokenIdCounter()).to.eql(new BigNumber.from('1'));
    });

    it('Should throw minting error when paused.', async () => {
        await instance.pause();
        await instance.setPublicMint(true);

        await expect(instance.publicMint({
            value: ethers.utils.parseEther(TOKEN_PRICE)
                })).to.be.rejectedWith(revertReason(
                    "Pausable: paused"));
        expect(await instance.tokenIdCounter()).to.eql(new BigNumber.from('0'));
    });
});