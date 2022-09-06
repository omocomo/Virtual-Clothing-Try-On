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

HAIR_DIR = os.path.join(DATA_DIR,'hair/')
SERVER_HAIR_DIR = os.path.join('http://localhost:8000/','DATA/','hair/')
MODEL_DIR = os.path.join(DATA_DIR,'model/')
SERVER_MODEL_DIR = os.path.join('http://localhost:8000/','DATA/','model/')
OUTPUT_DIR = os.path.join(DATA_DIR,'output/')
SERVER_OUTPUT_DIR = os.path.join('http://localhost:8000/','DATA/','output/')
USER_DIR = os.path.join(DATA_DIR,'user/')
SERVER_USER_DIR = os.path.join('http://localhost:8000/','DATA/','user/')
SWAP_DIR = os.path.join(DATA_DIR,'swap/')
SERVER_SWAP_DIR = os.path.join('http://localhost:8000/','DATA/','swap/')


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

@router.post('/get_tryon')
async def get_tryon(try_on_data: TryOnData): 
    # print(try_on_data.model_image)
    # print(try_on_data.user_image)
    
    select_model_path = os.path.join(MODEL_DIR, try_on_data.model_image.split('/')[1])
    select_user_path = os.path.join(USER_DIR, try_on_data.user_image.split('/')[1])
    output_path = os.path.join(SWAP_DIR, try_on_data.model_image.split('/')[1])

    # Face Swapping
    test_image(select_user_path, select_model_path, output_path)

    user_hair_path = os.path.join(HAIR_DIR, try_on_data.user_image.split('/')[1])

    # 머리 합성하기
    final_image = HairSwap(select_user_path, output_path, user_hair_path)
    print(final_image)

    # test_image(select_user_path, output_path, output_path)

    # output_url = SERVER_OUTPUT_DIR + OUTPUT_VIDEO_NAME
    result = {'outputName' : final_image}
    return result

