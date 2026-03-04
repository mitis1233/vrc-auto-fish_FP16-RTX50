import torch
import os
import sys
from ultralytics import YOLO
import numpy as np

# 導入 config 以獲取 YOLO_HALF 設定
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
try:
    import config
    YOLO_HALF = getattr(config, 'YOLO_HALF', True)
except ImportError:
    YOLO_HALF = True

def verify_fp16():
    model_path = r'yolo\runs\fish_detect\weights\best.pt'
    if not os.path.exists(model_path):
        print(f"[錯誤] 找不到模型文件: {model_path}")
        return

    print("="*50)
    print(f"正在檢查模型: {model_path}")
    print(f"Config.py 中的 YOLO_HALF 設定: {YOLO_HALF}")
    print("="*50)

    try:
        # 1. 檢查磁碟上的模型文件精度
        checkpoint = torch.load(model_path, map_location='cpu', weights_only=False)
        if 'model' in checkpoint:
            # 獲取模型權重的第一個參數的數據類型
            disk_dtype = next(checkpoint['model'].parameters()).dtype
            print(f"磁碟文件原始精度 (On-disk dtype): {disk_dtype}")
        else:
            print("無法直接從 checkpoint 讀取精度，嘗試通過 YOLO 類加載...")

        # 2. 模擬程序加載過程並檢查運行時精度
        model = YOLO(model_path)
        
        # 檢查是否可用 GPU
        device = 0 if torch.cuda.is_available() else "cpu"
        print(f"偵測到設備: {device} ({torch.cuda.get_device_name(0) if device != 'cpu' else 'CPU'})")

        if device != "cpu":
            model.to(device)
            # 模擬 detect 方法中的推論行為
            # 我們傳入 half 參數，這就是 YoloDetector.py 中的實際運算方式
            img = np.zeros((640, 640, 3), dtype=np.uint8)
            
            # 執行一次推論來觸發內部轉換
            results = model.predict(img, device=device, half=YOLO_HALF, verbose=False)
            
            # 檢查模型在顯存中的實際精度
            runtime_dtype = next(model.model.parameters()).dtype
            print(f"運行時顯存精度 (Runtime GPU dtype): {runtime_dtype}")
            
            if runtime_dtype == torch.float16:
                print("\n[確認成功] 您的模型正在以 FP16 (半精度) 運算！")
                print("這能完美發揮 RTX 5090 的 Tensor Core 性能。")
            else:
                print("\n[注意] 模型目前以 FP32 (全精度) 運算。")
                if not YOLO_HALF:
                    print("原因: config.py 中的 YOLO_HALF 被設置為 False。")
        else:
            print("\n[警告] 未偵測到 GPU，目前僅能以 CPU (FP32) 運行。")

    except Exception as e:
        print(f"[發生錯誤] 驗證失敗: {e}")

    print("="*50)

if __name__ == "__main__":
    verify_fp16()
