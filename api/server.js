const WebSocket = require('ws');
const { exec } = require('child_process');
const fs = require('fs');
const express = require('express');
const path = require('path');

const app = express();
const port = 4000;

// สร้าง WebSocket Server
const wss = new WebSocket.Server({ noServer: true });

// ฟังก์ชันเพื่อลบไฟล์ทั้งหมดในโฟลเดอร์
function clearFolder(folderPath) {
  fs.readdir(folderPath, (err, files) => {
    if (err) {
      console.error(`Error reading directory ${folderPath}: ${err}`);
      return;
    }

    // ลบไฟล์ทั้งหมดในโฟลเดอร์
    for (const file of files) {
      const filePath = path.join(folderPath, file);
      fs.unlink(filePath, (err) => {
        if (err) {
          console.error(`Error deleting file ${filePath}: ${err}`);
        } else {
          console.log(`Deleted file: ${filePath}`);
        }
      });
    }
  });
}

// เมื่อมีการเชื่อมต่อ WebSocket
wss.on('connection', (ws) => {
  console.log('WebSocket connection established');

  ws.on('message', (message) => {
    try {
      const videoBuffer = Buffer.from(message);
      console.log(`Received video of size: ${videoBuffer.length} bytes`);

      const uploadsFolder = path.join(__dirname, 'uploads');
      const resultFolder = path.join(__dirname, 'result');

      // ตรวจสอบว่าโฟลเดอร์ result ว่างหรือไม่
      fs.readdir(resultFolder, (err, files) => {
        if (err) {
          console.error(`Error reading directory ${resultFolder}: ${err}`);
          return;
        }

        if (files.length > 0) {
          console.log('Result folder is not empty. Clearing the folder before processing.');
          clearFolder(resultFolder); // ล้างโฟลเดอร์ result
        }

        // บันทึกวิดีโอที่ได้รับลงในโฟลเดอร์ uploads
        const inputVideoPath = path.join(uploadsFolder, 'upload.mp4');
        fs.writeFileSync(inputVideoPath, videoBuffer);

        const outputVideoPath = path.join(resultFolder, 'result.mp4');
        exec(`python detect_video.py "${inputVideoPath}" "${outputVideoPath}"`, (error, stdout, stderr) => {
          if (error) {
            console.error(`Processing error: ${error.message}`);
            ws.send('Error processing video');
            return;
          }

          console.log('Video processed successfully');
          ws.send(`http://localhost:${port}/result/result.mp4`);
        });
      });
    } catch (err) {
      console.error(`Failed to process message: ${err}`);
    }
  });

  ws.on('close', () => {
    console.log('WebSocket connection closed');
  });

  ws.on('error', (err) => {
    console.error('WebSocket error:', err);
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
