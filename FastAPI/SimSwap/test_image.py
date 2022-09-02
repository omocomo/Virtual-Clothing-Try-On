import warnings
warnings.filterwarnings('ignore')
import os
import sys
sys.path.append(os.path.abspath(os.path.dirname(__file__)))
import cv2
import torch
import numpy as np
from PIL import Image
import torch.nn.functional as F
from torchvision import transforms
from models.models import create_model
from easy_options.test_options import TestOptions
# from insightface_func.face_detect_crop_single import Face_detect_crop  # 내가 추가한 코드
from insightface_func.face_detect_crop_multi import Face_detect_crop
from util.imageswap import image_swap  # 내가 추가한 코드

transformer_Arcface = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

def test_image(src_img_path, trg_img_path, output_path):
    args = TestOptions().initialize()
    # opt.initialize()
    # opt.parser.add_argument('-f') ## dummy arg to avoid bug
    # opt = opt.parse()

    args.pic_a_path = src_img_path ## or replace it with image from your own google drive, 얼굴
    args.pic_b_path = trg_img_path ## 모델

    args.output_path = output_path
    args.Arc_path = './SimSwap/arcface_model/arcface_checkpoint.tar'

    args.isTrain = False
    args.use_mask = True  ## new feature up-to-date

    crop_size = args.crop_size

    torch.nn.Module.dump_patches = True
    model = create_model(args)

    model.eval()

    app = Face_detect_crop(name='antelope', root='./SimSwap/insightface_func/models')
    app.prepare(ctx_id= 0, det_thresh=0.6, det_size=(640,640))

    with torch.no_grad():
        pic_a = args.pic_a_path
        # 이미지 읽기
        img_a_whole = cv2.imread(pic_a)
        # 얼굴 부분 찾아서 자르기
        img_a_align_crop, _ = app.get(img_a_whole, crop_size)
        img_a_align_crop_pil = Image.fromarray(cv2.cvtColor(img_a_align_crop[0],cv2.COLOR_BGR2RGB)) 
        img_a = transformer_Arcface(img_a_align_crop_pil)
        img_id = img_a.view(-1, img_a.shape[0], img_a.shape[1], img_a.shape[2])

        # convert numpy to tensor
        img_id = img_id.cuda()

        #create latent id
        img_id_downsample = F.interpolate(img_id, size=(112,112))
        latend_id = model.netArc(img_id_downsample)
        latend_id = latend_id.detach().to('cpu')
        latend_id = latend_id/np.linalg.norm(latend_id,axis=1,keepdims=True)
        latend_id = latend_id.to('cuda')

        image_swap(args.pic_b_path, latend_id, model, app, args.output_path, use_mask=args.use_mask)

if __name__ == '__main__':
    src_img_path = './image/Iron_man.jpg'
    trg_img_path = './image/specific1.png'
    output_path = './output/img2img_res.png'
    test_image(src_img_path, trg_img_path, output_path)