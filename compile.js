const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

const buildPath = path.resolve(__dirname, 'build');

// Delete the build folder
fs.removeSync(buildPath);

// Read mainContract.sol
const mainContractPath = path.resolve(__dirname, 'contracts', 'mainContract.sol');

// Read source code
const source = fs.readFileSync(mainContractPath, 'utf8');

// Compile
const output = solc.compile(source, 1).contracts;


// Create build folder
fs.ensureDirSync(buildPath);
console.log('Output:', output);

// Get from contract compiled and write it to a file in the build folder
for (let contract in output) {
    fs.outputJSONSync(
        path.resolve(buildPath, contract + '.json'),
        output[contract]
    );
}
