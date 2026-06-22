# Antigravity Vision 🚀

[![Flutter](https://img.shields.io/badge/Flutter-SDK%20%3E%3D3.0.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![TensorFlow Lite](https://img.shields.io/badge/TensorFlow-Lite%20v1.0.1-FF6F00?logo=tensorflow&logoColor=white)](https://tensorflow.org/lite)
[![Dart](https://img.shields.io/badge/Dart-3-0175C2?logo=dart&logoColor=white)](https://dart.dev)

A modern, high-performance Flutter mobile application featuring real-time, on-device edge intelligence. Powered by TensorFlow Lite, **Antigravity Vision** runs deep learning models locally, rendering bounding boxes, image classification results, and skeletal human pose structures with ultra-low latency and zero cloud dependency.

---

## 📸 Key Features

- **Real-Time Inference:** Live camera stream processing with dynamic bounding box localization and keypoint overlay rendering.
- **Multi-Model Support:** Toggle between four state-of-the-art architectures optimized for mobile processors.
- **Performance Analytics Dashboard:** Glassmorphic overlay displaying the active model name and real-time inference speed (latency in milliseconds).
- **Interactive Model Comparison:** In-app metrics comparison matrix illustrating task type, file size, processing speed, and optimal use cases.
- **Premium Aesthetics:** Curated dark UI styled with premium radial gradients, backdrop filters, and neon indicators.

---

## 🧠 Supported Models

The application is pre-configured with four lightweight models located in the `assets/` directory:

| Model Name | Task | Disk Size | Latency | Input Resolution | Model File | Description |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| **SSD MobileNet v1** | Multi-Object Detection | 4.2 MB | ~30ms | 300 × 300 | `ssd_mobilenet.tflite` | Single Shot Detector with MobileNet backbone. Detects 80 classes. Excellent balance of speed and localization accuracy. |
| **Tiny YOLOv2** | High-Speed Object Detection | 44.9 MB | ~120ms | 416 × 416 | `yolov2_tiny.tflite` | A compact single-pass regression detector. Has a higher memory footprint but is highly responsive on high-end edge chips. |
| **MobileNet v1** | Image Classification | 16.9 MB | ~15ms | 224 × 224 | `mobilenet_v1_1.0_224.tflite` | Blazing-fast 1000-class classifier based on ImageNet. Identifies the primary subject without drawing boxes. |
| **PoseNet** | Human Pose Estimation | 5.0 MB | ~45ms | 257 × 257 | `posenet_mv1_075_float_from_checkpoints.tflite` | Identifies 17 skeletal joint coordinates for posture tracking, fitness evaluation, and motion gaming. |

> [!NOTE]
> The **SSD MobileNet v1** (`ssd_mobilenet_v1`) model was originally retrieved from `ssd_mobilenet_v1_coco_2017_11_17` and optimized into the TFLite representation (`ssd_mobilenet.tflite`) for this application.

---

## 📂 Project Structure

```
.
├── android/                   # Native Android setup (permissions, gradle builds)
├── ios/                       # Native iOS setup (info plist strings, build targets)
├── assets/                    # Compiled TensorFlow Lite models and label maps
│   ├── ssd_mobilenet.tflite   # SSD MobileNet v1 model file
│   ├── ssd_mobilenet.txt      # COCO class label list (80 labels)
│   ├── yolov2_tiny.tflite     # Tiny YOLOv2 model file
│   ├── yolov2_tiny.txt        # YOLO class label list
│   ├── mobilenet_v1_1.0_224.tflite # MobileNet v1 classifier model
│   ├── mobilenet_v1_1.0_224.txt    # ImageNet classification label list
│   └── posenet_mv1_075_float_from_checkpoints.tflite # PoseNet model file
├── lib/                       # Flutter Application source code
│   ├── main.dart              # App bootstrap and camera access initialization
│   ├── home_screen.dart       # Glassmorphic model selection screen and comparison bottom sheet
│   ├── detection_screen.dart  # Inference controller and layout stack
│   ├── camera.dart            # Camera controller wrapper & real-time frame streaming pipeline
│   ├── bndbox.dart            # Bounding box & PoseNet skeleton overlay drawing library
│   └── models.dart            # Static model constants
├── Object Detection model/    # Original training resources and notebooks
│   ├── ssd_mobilenet_v1/      # Contains frozen TensorFlow protobuf inference graphs (.pb)
│   ├── object_detection.ipynb # Jupyter notebook for model training, analysis, and conversion
│   └── detected_image1.jpg    # Sample detection output previews
└── pubspec.yaml               # Flutter package configuration and asset references
```

---

## 🛠️ Setup & Installation

### Prerequisites

- **Flutter SDK:** `>=3.0.0`
- **Dart SDK:** `>=3.0.0 <4.0.0`
- A physical Android/iOS device with camera access. (Emulators do not reliably support real-time camera frames required by the TFLite pipeline).

### 1. Platform Configurations

#### Android
Camera permissions are pre-configured in [AndroidManifest.xml](file:///d:/Projects/Object%20Detector/android/app/src/main/AndroidManifest.xml):
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
```
Make sure `minSdkVersion` in `android/app/build.gradle` is set to **21** or higher.

#### iOS
Camera and microphone usage descriptions are configured in [Info.plist](file:///d:/Projects/Object%20Detector/ios/Runner/Info.plist):
```xml
<key>NSCameraUsageDescription</key>
<string>We need your permission to access the camera</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need your permission to access the microphone</string>
```

### 2. Install Dependencies

Fetch the packages specified in `pubspec.yaml`:
```bash
flutter pub get
```

### 3. Run the App

Ensure a physical device is connected, then compile and run the project:
```bash
flutter run
```

---

## 🧪 Model Conversion & Custom Training

To customize the detection models or train on your own data:
1. Open the [object_detection.ipynb](file:///d:/Projects/Object%20Detector/Object%20Detection%20model/object_detection.ipynb) notebook in the `Object Detection model/` directory.
2. Follow the steps inside to set up the TensorFlow Object Detection API, inspect the pre-trained `ssd_mobilenet_v1` model, and convert the resulting frozen graph (`.pb` format) into a mobile-friendly `.tflite` model using `TFLiteConverter`.
3. Swap the generated `.tflite` and label `.txt` files in the `assets/` directory and run the application.

---

## 🔗 Technical Credits & Resources

- TensorFlow Lite: https://tensorflow.org/lite
- MSCOCO Dataset: https://cocodataset.org
- Flutter TFLite Plugin: https://pub.dev/packages/flutter_tflite
