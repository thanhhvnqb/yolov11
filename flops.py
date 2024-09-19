from ultralytics import YOLOv10
# model = YOLOv10("yolov10n.yaml")
model = YOLOv10("cyolov4n.yaml")
model.model.model[-1].export = True
model.model.model[-1].format = "onnx"
del model.model.model[-1].cv2
del model.model.model[-1].cv3
model.fuse()
# model.info(detailed=True, verbose=True)
