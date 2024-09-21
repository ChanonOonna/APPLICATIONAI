import sys
import os
import cv2
import numpy as np
from moviepy.editor import VideoFileClip, ImageSequenceClip
from ultralytics import YOLO

# โหลดโมเดล YOLO
model = YOLO('models/best.pt')

def process_video(input_video_path, output_video_path):
    # ตรวจสอบว่าไฟล์วิดีโอมีอยู่หรือไม่
    if not os.path.exists(input_video_path):
        print(f"Input video file {input_video_path} does not exist.")
        return

    # ใช้ moviepy ในการเปิดและประมวลผลวิดีโอ
    clip = VideoFileClip(input_video_path)
    output_frames = []

    for frame in clip.iter_frames(fps=clip.fps, dtype='uint8'):
        # แปลงเฟรมเป็น array ที่สามารถแก้ไขได้
        frame = np.array(frame)

        # ตรวจจับวัตถุในเฟรม
        results = model(frame)

        # วาดกรอบ bounding box ลงบนเฟรม
        for box in results[0].boxes:
            xyxy = box.xyxy[0].tolist()  # Bounding box coordinates
            conf = box.conf.item()  # Confidence score
            cls = box.cls.item()  # Class index

            # วาดกรอบและชื่อบนเฟรม
            cv2.rectangle(frame, (int(xyxy[0]), int(xyxy[1])), (int(xyxy[2]), int(xyxy[3])), (255, 0, 0), 2)
            label = f'{model.names[int(cls)]} {conf:.2f}'
            cv2.putText(frame, label, (int(xyxy[0]), int(xyxy[1] - 10)), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 2)

        output_frames.append(frame)

    # สร้างวิดีโอผลลัพธ์จากเฟรม
    output_clip = ImageSequenceClip(output_frames, fps=clip.fps)
    output_clip.write_videofile(output_video_path, codec='libx264', audio_codec='aac')

    clip.close()

if __name__ == '__main__':
    input_video_path = sys.argv[1]
    output_video_path = sys.argv[2]

    # ตรวจจับวัตถุในวิดีโอและบันทึกผลลัพธ์
    process_video(input_video_path, output_video_path)
