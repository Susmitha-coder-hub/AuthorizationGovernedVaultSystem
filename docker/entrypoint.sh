#!/bin/sh

npx hardhat compile
npx hardhat run scripts/deploy.js --network localhost
