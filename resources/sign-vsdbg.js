const vsdaLocation = "/opt/visual-studio-code/resources/app/node_modules.asar.unpacked/vsda/build/Release/vsda.node";
var signature = require(vsdaLocation).signer().sign(process.argv[2]);
console.log(signature);
