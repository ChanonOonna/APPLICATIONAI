import cv2
import torch
import sys
import os
from ultralytics import YOLO

# โหลดโมเดล YOLO
model = YOLO('models/best.pt')

def process_video(input_video_path, output_video_path):
    # ตรวจสอบว่าไฟล์วิดีโอมีอยู่หรือไม่
    if not os.path.exists(input_video_path):
        print(f"Input video file {input_video_path} does not exist.")
        return
    
    cap = cv2.VideoCapture(input_video_path)
    if not cap.isOpened():
        print(f"Failed to open video file {input_video_path}.")
        return
    
    # กำหนด codec และสร้าง VideoWriter สำหรับบันทึกวิดีโอผลลัพธ์
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # เปลี่ยน codec ให้เหมาะสมกับ mp4
    out = cv2.VideoWriter(output_video_path, fourcc, 20.0, (int(cap.get(3)), int(cap.get(4))))

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        
        # ตรวจจับวัตถุในเฟรม
        results = model(frame)
        
        # วาดกรอบ bounding box ลงบนเฟรม
        for box in results[0].boxes:
            xyxy = box.xyxy[0]  # Bounding box coordinates
            conf = box.conf.item()  # Confidence score
            cls = box.cls.item()  # Class index
            
            label = f'{model.names[int(cls)]} {conf:.2f}'
            cv2.rectangle(frame, (int(xyxy[0]), int(xyxy[1])), (int(xyxy[2]), int(xyxy[3])), (255, 0, 0), 2)
            cv2.putText(frame, label, (int(xyxy[0]), int(xyxy[1] - 10)), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 2)
        
        # เขียนเฟรมลงในไฟล์วิดีโอผลลัพธ์
        out.write(frame)
    
    cap.release()
    out.release()

if __name__ == '__main__':
    input_video_path = sys.argv[1]
    output_video_path = sys.argv[2]
    
    # ตรวจจับวัตถุในวิดีโอและบันทึกผลลัพธ์
    process_video(input_video_path, output_video_path)
