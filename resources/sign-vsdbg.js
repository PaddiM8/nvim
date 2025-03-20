let vsda_location = "/opt/visual-studio-code/resources/app/node_modules.asar.unpacked/vsda/build/Release/vsda.node";
if (rocess.platform === "win32") {
    vsda_location = "C:/Program Files/Microsoft VS Code/resources/app/node_modules.asar.unpacked/vsda/build/Release/vsda.node"
}

const a = require(vsda_location);
const signer = new a.signer();
process.argv.forEach(function (value, index, array) {
    if (index >= 2) {
        var r = signer.sign(value);
        console.log(r);
    }
});
