async function main () {
  const Test = await ethers.getContractFactory('test721');
  console.log('Deploying test721...');
  const test = await Test.deploy();
  await test.deployed();
  console.log('Test deployed to:', test.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
