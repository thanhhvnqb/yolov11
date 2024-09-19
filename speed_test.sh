if [ -n "$3" ]; then
    imgsz=$3
else
    imgsz=640
fi

if [ "$2" = "rebuild" ]; then
    rm -rf ./runs/detect/speed-model/$1-$imgsz
fi

if [ -f "./runs/detect/speed-model/$1-$imgsz/weights/best.engine" ]; then
    echo "Already compile model."
else
    echo "Compile model."
    rm -rf ./runs/detect/speed-model/$1-$imgsz
    yolo detect train val=False data=coco128.yaml model=$1.yaml name=speed-model/$1-$imgsz imgsz=$imgsz batch=8 epochs=1 workers=8 device=0 pretrained=False
    yolo export format=engine half=True simplify workspace=16 model=./runs/detect/speed-model/$1-$imgsz/weights/best.pt
fi

echo "#####ONNX CPU#####"
yolo val detect data=coco.yaml model=./runs/detect/speed-model/$1-$imgsz/weights/best.onnx imgsz=$imgsz batch=1 device=cpu name=speed/$1

echo "#####TensorRT FP16#####"
yolo val detect data=coco.yaml model=./runs/detect/speed-model/$1-$imgsz/weights/best.engine imgsz=$imgsz batch=1 device=0 name=speed/$1