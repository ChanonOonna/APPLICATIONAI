const WebSocket = require('ws');
const { exec } = require('child_process');
const fs = require('fs');
const express = require('express');
const path = require('path');

const app = express();
const port = 4000;

// สร้าง WebSocket Server
const wss = new WebSocket.Server({ noServer: true });

// เมื่อมีการเชื่อมต่อ WebSocket
wss.on('connection', (ws) => {
  ws.on('message', (message) => {
    try {
      const videoBuffer = Buffer.from(message);
      console.log(`Received video of size: ${videoBuffer.length} bytes`);
      
      const inputVideoPath = 'uploads/temp_video.mp4';
      fs.writeFileSync(inputVideoPath, videoBuffer);

      if (fs.existsSync(inputVideoPath)) {
        console.log(`Video saved to ${inputVideoPath}`);
      } else {
        console.error('Failed to save video file.');
      }

      const outputVideoPath = 'result/processed_video.mp4';
      exec(`python detect_video.py ${inputVideoPath} ${outputVideoPath}`, (error, stdout, stderr) => {
        if (error || stderr) {
          console.error(`Processing error: ${error || stderr}`);
          ws.send('Error processing video');
        } else {
          ws.send(`http://localhost:4000/${outputVideoPath}`);
        }
      });
    } catch (err) {
      console.error(`Failed to process message: ${err}`);
    }
  });
});

// ให้บริการไฟล์วิดีโอผ่าน HTTP
app.use('/result', express.static(path.join(__dirname, 'result')));

// กำหนด route หลักสำหรับเซิร์ฟเวอร์ HTTP
app.get('/', (req, res) => {
  res.send('Server is running');
});

// จัดการการเชื่อมต่อ WebSocket และ HTTP
const server = app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

server.on('upgrade', (request, socket, head) => {
  wss.handleUpgrade(request, socket, head, (ws) => {
    wss.emit('connection', ws, request);
  });
});
