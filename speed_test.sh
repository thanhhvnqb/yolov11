if [ "$2" = "rebuild" ]; then
    rm -rf ./runs/detect/speed-model/$1
fi

if [ -f "./runs/detect/speed-model/$1/weights/best.engine" ]; then
    echo "Already compile model."
else
    echo "Compile model."
    # rm -rf ./runs/detect/speed-model/$1
    yolo detect train data=coco8.yaml model=$1.yaml name=speed-model/$1 imgsz=640 batch=8 epochs=1 workers=8 device=0 pretrained=False
    yolo export format=engine half=True simplify opset=13 workspace=16 model=./runs/detect/speed-model/$1/weights/best.pt
fi

echo "#####ONNX CPU#####"
yolo val detect data=coco128.yaml model=./runs/detect/speed-model/$1/weights/best.onnx batch=1 device=cpu name=speed/$1

echo "#####TensorRT FP16#####"
yolo val detect data=coco128.yaml model=./runs/detect/speed-model/$1/weights/best.engine batch=1 device=0 name=speed/$1