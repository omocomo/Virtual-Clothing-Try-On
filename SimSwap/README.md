## Face Swapping - SimSwap
![image](https://user-images.githubusercontent.com/39791467/184496739-b6bbc9f7-9f8b-47c5-9068-045bd14f98e8.png)



### Download Relative Files & Pretrained Model
#### 1. [InsightFace](https://github.com/deepinsight/insightface)
- Download the relative files [here](https://onedrive.live.com/?authkey=%21ADJ0aAOSsc90neY&cid=4A83B6B633B029CC&id=4A83B6B633B029CC%215837&parId=4A83B6B633B029CC%215834&action=locate)
- Unzip them to `SimSwap/insightface_func/models`
#### 2. [Face-Parsing](https://github.com/zllrunning/face-parsing.PyTorch)
- Download weight file [here](https://drive.google.com/file/d/154JgKpzCPW82qINcVieuPH3fZ2e0P812/view)
- Save Directory: `SimSwap/parsing_model/checkpoint`
#### 3. Pretrained Model
- Download trained model [here](https://drive.google.com/drive/folders/1jV6_0FIMPC53FZ2HzZNJZGMe55bbu17R)
- Save Directory
  - `SimSwap/arcface_model/arcface_checkpoint.tar`
  - Unzip `checkpoints.zip` to `SimSwap/checkpoints/`

### Run
```
python test_image.py
```
You can change the image path in `test_image.py`
```
src_img_path = './image/Iron_man.jpg'
trg_img_path = './image/specific1.png'
output_path = './output/img2img_res.png'
```

### Reference
- https://github.com/neuralchen/SimSwap

