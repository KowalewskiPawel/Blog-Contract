import { ethers } from "hardhat";

async function main() {
  const IterableMapping = await ethers.getContractFactory("IterableMapping");

  const mapping = await IterableMapping.deploy();

  await mapping.deployed();

  const Blog = await ethers.getContractFactory("Blog", {
    libraries: {
      IterableMapping: mapping.address,
    },
  });
  const blog = await Blog.deploy();

  await blog.deployed();

  console.log("Blog deployed to:", blog.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
