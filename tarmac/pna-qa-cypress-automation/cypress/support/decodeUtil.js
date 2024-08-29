export function b64Decode(encodedString) {
    let decodedText = new Buffer.from(encodedString, "base64");
    return decodedText.toString("utf8")
}
