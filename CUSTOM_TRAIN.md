<!---# Ultralytics YOLO 🚀, AGPL-3.0 license
# COCO 2017 dataset http://cocodataset.org by Microsoft
# Example usage: yolo train data=coco.yaml
# parent
# ├── ultralytics
# └── datasets
#     └── coco  ← downloads here (20.1 GB)-->
# Huấn luyện Yolov8 trên máy local

- Đoạn code trỏ đến file config (liên quan đến dataset_dir):
```
if os_name == 'Windows':
    path = Path.home() / 'AppData' / 'Roaming' / sub_dir
elif os_name == 'Darwin':  # macOS
    path = Path.home() / 'Library' / 'Application Support' / sub_dir
elif os_name == 'Linux':
    path = Path.home() / '.config' / sub_dir
else:
    raise ValueError(f'Unsupported operating system: {os_name}')
```
- Khi chạy huấn luyện, chạy lệnh ```./train.sh <ten_model>```. Cần cài đặt docker, docker compose, nvidia-docker để chạy được với GPU.
- Để test speed của model, chạy lệnh ```./speed.sh <ten_model>```.
- Link excel làm việc: https://docs.google.com/spreadsheets/d/1GpOcga7PgX1a2QyrQVaa36dww1n2GsXhqD7AUEivQwE/edit#gid=0

# Chuẩn bị cơ sở dữ liệu
- Tải file coco từ link này:
    - Cho detection: https://github.com/ultralytics/yolov5/releases/download/v1.0/coco2017labels.zip (Nên dùng chung với segmentation luôn cho khỏe)
    - Cho Segmentation: https://github.com/ultralytics/yolov5/releases/download/v1.0/coco2017labels-segments.zip
    - Cho Pose: https://github.com/ultralytics/yolov5/releases/download/v1.0/coco2017labels-pose.zip
- Sau đó tải ảnh về và cho vào thư mục images

# Câu lệnh chạy experiments
## Train
### Detection
- Câu lệnh train với 100 epoch
```yolo detect train data=coco.yaml model=cyolov10n.yaml name=trainval/cyolov10n imgsz=640 batch=64 epochs=100 close_mosaic=10 workers=24 device=0,1,2,3 pretrained=False```
- Câu lệnh train với 500 epoch
```yolo detect train data=coco.yaml model=cyolov10n.yaml name=trainval/cyolov10n imgsz=640 batch=128 epochs=500 close_mosaic=10 workers=24 device=0,1,2,3 pretrained=False```
- Câu lệnh train với 500 epoch với pretrained
```yolo detect train data=coco.yaml model=cyolov10n.yaml name=trainval/cyolov10n imgsz=640 batch=128 epochs=500 close_mosaic=10 workers=24 device=0,1,2,3 pretrained=./pretrained/yolov8n.pt```
### Pose
- Câu lệnh train với 500 epoch
```yolo pose train data=coco-pose.yaml model=cyolov12n-pose.yaml name=trainval/cyolov12n imgsz=640 batch=128 epochs=500 close_mosaic=10 workers=24 device=0,1,2,3 pretrained=False```
### Segmentation
- Câu lệnh train với 500 epoch
```yolo segment train data=coco.yaml model=cyolov12n-seg.yaml name=trainval/cyolov12n imgsz=640 batch=128 epochs=500 close_mosaic=10 workers=24 device=0,1,2,3 pretrained=False```

## Validation
### Detection
- Câu lệnh validate with trained models:
```yolo detect val data=coco.yaml model=cyolov6n.yaml batch=128 device=0 name=val/cyolov6n pretrained=./trained_models/cyolov6n.pt```
### Pose


## Speed
### Detection
- Câu lệnh đo tốc độ của task detection trên CPU:
```yolo detect val data=coco.yaml model=$1.yaml imgsz=640 batch=1 device=cpu name=speed/$1```
- Câu lệnh đo tốc độ của task detection trên GPU:
```yolo val detect data=coco128.yaml model=$1.yaml batch=1 device=0 name=speed/$1``

- Đo tốc độ bằng tensorrt
    - Chạy lệnh `./speed_test.sh <name_of_model>`

