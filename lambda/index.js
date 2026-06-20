exports.handler = async (event) => {
    // Structural JSON extraction parameters parsed out for real-time monitoring
    const filename = event.Records[0].s3.object.key;
    console.log(`Image received: ${filename}`);
    return {
        statusCode: 200,
        body: JSON.stringify(`Successfully registered image: ${filename}`),
    };
};