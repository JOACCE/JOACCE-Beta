navigator.mediaDevices.getUserMedia({video: true}).then(stream => {
    const video = document.createElement("video");
    video.srcObject = stream;
    video.play();

    const canvas = document.createElement("canvas");
    canvas.width = 640;
    canvas.height = 480;

    window.captureWebcamFrame = function() {
        const ctx = canvas.getContext('2d');
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

        return canvas.toDataURL("image/jpeg", 0.8);
    };
})
.catch(err => console.error("Webcam not accessible", err));
