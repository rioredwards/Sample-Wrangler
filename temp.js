const fs = require("fs");
const path = require("path");

console.log("__dirname", __dirname);

// read sampleSamples.txt

// const sampleSamples = fs.readFileSync(path.join(__dirname, "sampleSamples.txt"), "utf8");

//  Separate the lines into an array
// const sampleSamplesArray = sampleSamples.split("\n");

//  Remove the first line
// sampleSamplesArray.shift();

// Get the file name from each sample in the array
// const sampleNames = sampleSamplesArray.map((sample) => {
//   return sample.split("/").pop();
// });

// Write the sample names to a new file
// fs.writeFileSync(path.join(__dirname, "sampleNames.txt"), sampleNames.join("\n"));

const sampleNames = fs.readFileSync(path.join(__dirname, "sampleNames.txt"), "utf8");

// separate the sample names into an array
const sampleNamesArray = sampleNames.split("\n");

// make a new folder for samples
fs.mkdirSync(path.join(__dirname, "samples"));

// create new samples with the same name in the samples folder
sampleNamesArray.forEach((sample) => {
  fs.writeFileSync(path.join(__dirname, "samples", sample), "");
});
