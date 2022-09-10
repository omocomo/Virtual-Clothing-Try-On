from fastapi import APIRouter
from fastapi import UploadFile, File
from fastapi.responses import FileResponse
from pydantic import BaseModel
from SimSwap.test_image import test_image
from HairSegmentation.img_hair_seg import img_hair_seg
from HairSegmentation.hair_swap import HairSwap
import os
from glob import glob
from typing import List

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(BASE_DIR,'DATA/')

server = 'localhost'

HAIR_DIR = os.path.join(DATA_DIR,'hair/')
SERVER_HAIR_DIR = os.path.join(f'http://{server}:8000/','DATA/','hair/')
MODEL_DIR = os.path.join(DATA_DIR,'model/')
SERVER_MODEL_DIR = os.path.join(f'http://{server}:8000/','DATA/','model/')
OUTPUT_DIR = os.path.join(DATA_DIR,'output/')
SERVER_OUTPUT_DIR = os.path.join(f'http://{server}:8000/','DATA/','output/')
USER_DIR = os.path.join(DATA_DIR,'user/')
SERVER_USER_DIR = os.path.join(f'http://{server}:8000/','DATA/','user/')
SWAP_DIR = os.path.join(DATA_DIR,'swap/')
SERVER_SWAP_DIR = os.path.join(f'http://{server}:8000/','DATA/','swap/')


router = APIRouter()

@router.post('/user_image_upload')
async def user_image_upload(in_files: List[UploadFile] = File(...)): 
    # 사용자 이미지 입력 받고 저장
    image = in_files[0]
    saved_file_name = image.filename.split('/')[-1] # 이미지 name
    IMG_PATH = os.path.join(USER_DIR, saved_file_name)
    with open(IMG_PATH, "wb+") as file_object:
        file_object.write(image.file.read())
    img_url = SERVER_USER_DIR + saved_file_name
    
    # hair segmentation 해서 mask 저장
    img_hair_seg(IMG_PATH)

    result = {'imgUrl' : img_url}
    return result

@router.get('/DATA/output/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([OUTPUT_DIR, file_name]))

@router.get('/DATA/model/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([MODEL_DIR, file_name]))

@router.get('/DATA/user/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([USER_DIR, file_name]))

class TryOnData(BaseModel):
    model_image: str
    user_image: str
    hair_code: int

class FaceSwap(BaseModel):
    model_image: str
    user_image: str

@router.post('/face_swapping')
async def get_tryon(face_swap: FaceSwap): 
    print(face_swap.model_image)
    print(face_swap.user_image)

    user_image_name = face_swap.user_image.split('/')[-1].split('.')[0]
    model_image_name = face_swap.model_image.split('/')[-1].split('.')[0]
    output_image_name = user_image_name + '_' + model_image_name 

    select_model_path = os.path.join(MODEL_DIR, model_image_name + '.jpg')
    select_user_path = os.path.join(USER_DIR, user_image_name + '.jpg')
    output_path = os.path.join(OUTPUT_DIR, output_image_name + '.jpg')

    # Face Swapping
    test_image(select_user_path, select_model_path, output_path)

    # output_url = SERVER_OUTPUT_DIR + OUTPUT_VIDEO_NAME
    result = {'outputName' : output_image_name + '.jpg'}
    return result


@router.post('/change_hair')
async def change_hair(try_on_data: TryOnData): 
    print(try_on_data.model_image)
    print(try_on_data.user_image)
    print(try_on_data.hair_code)

    user_image_name = try_on_data.user_image.split('/')[-1].split('.')[0]
    model_image_name = try_on_data.model_image.split('/')[-1].split('.')[0]
    output_image_name = user_image_name + '_' + model_image_name 

    output_path = os.path.join(OUTPUT_DIR, output_image_name + '.jpg')

    if try_on_data.hair_code == 0:
        final_image = output_image_name + '.jpg'
    else:
        # 머리 합성하기
        hair_man_path = f'C:/Users/omocomo/Documents/GitHub/Virtual-Clothing-Try-On/FastAPI/DATA/hair/hair_man_{str(try_on_data.hair_code).zfill(3)}.png'
        hair_mask_path = f'C:/Users/omocomo/Documents/GitHub/Virtual-Clothing-Try-On/FastAPI/DATA/hair/hair_mask_{str(try_on_data.hair_code).zfill(3)}.png'
        final_image = HairSwap(hair_man_path, output_path, hair_mask_path)

    print(final_image)
        
    # output_url = SERVER_OUTPUT_DIR + OUTPUT_VIDEO_NAME
    result = {'outputName' : final_image}
    return result