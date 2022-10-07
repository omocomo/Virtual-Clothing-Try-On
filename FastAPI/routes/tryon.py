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
from shutil import copyfile

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(BASE_DIR,'DATA/')

server = 'localhost'

# Directory
HAIR_DIR = os.path.join(DATA_DIR,'hair/')
SERVER_HAIR_DIR = os.path.join(f'http://{server}:8000/','DATA/','hair/')
MODEL_DIR = os.path.join(DATA_DIR,'model/')
MODEL_MAN_DIR = os.path.join(DATA_DIR,'model/man/origin/')
MODEL_MAN_ALL_DIR = os.path.join(DATA_DIR,'model/man/remove_all/')
MODEL_MAN_TOP_DIR = os.path.join(DATA_DIR,'model/man/remove_top/')
MODEL_WOMAN_DIR = os.path.join(DATA_DIR,'model/woman/origin/')
MODEL_WOMAN_ALL_DIR = os.path.join(DATA_DIR,'model/woman/remove_all/')
MODEL_WOMAN_TOP_DIR = os.path.join(DATA_DIR,'model/woman/remove_top/')
SERVER_MODEL_DIR = os.path.join(f'http://{server}:8000/','DATA/','model/')
OUTPUT_DIR = os.path.join(DATA_DIR,'output/')
SERVER_OUTPUT_DIR = os.path.join(f'http://{server}:8000/','DATA/','output/')
USER_DIR = os.path.join(DATA_DIR,'user/')
SERVER_USER_DIR = os.path.join(f'http://{server}:8000/','DATA/','user/')
SWAP_DIR = os.path.join(DATA_DIR,'swap/')
SERVER_SWAP_DIR = os.path.join(f'http://{server}:8000/','DATA/','swap/')


router = APIRouter()

# 회원가입 / 프로필 수정 시 사용자 이미지가 업로드 되면
# 1. user 이미지를 저장하고
# 2. user 이미지에 Hair Segmentation을 수행해 hair_mask를 저장
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

### 이미지 GET ###
@router.get('/DATA/output/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([OUTPUT_DIR, file_name]))

@router.get('/DATA/model/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([MODEL_DIR, file_name]))

@router.get('/DATA/model/man/origin/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([MODEL_MAN_DIR, file_name]))

@router.get('/DATA/model/woman/origin/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([MODEL_WOMAN_DIR, file_name]))

@router.get('/DATA/user/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([USER_DIR, file_name]))
#################


# 성별에 따라 원본 모델 이미지 보여주기
class Original(BaseModel):
    model_image: str
    gender: str

@router.post('/print_original')
async def print_original(original: Original):
    model_image_name = original.model_image.split('/')[-1]
    if original.gender == '남자':
        src_path = os.path.join(MODEL_MAN_DIR, model_image_name)
    else:
        src_path = os.path.join(MODEL_WOMAN_DIR, model_image_name)
    dst_path = os.path.join(OUTPUT_DIR, f'temp_{model_image_name}')
    copyfile(src_path, dst_path)

    print(original.model_image)
    result = {'outputName' : f'temp_{model_image_name}'}
    return result

# 입어보기 실행 시, Face Swapping 수행
class FaceSwap(BaseModel):
    model_image: str
    user_image: str
    gender: str

# 처음으로 Face Swapping 할 때,
# 모델 이미지 origin / remove_all / remove_top 각각에 모두 수행
# origin: 원본 모델 이미지
# remove_all: 모델 머리카락 전체 제거
# remove_top: 모델 머리카락 윗 부분만 제거
# 헤어 스타일에 따라 3가지 중 어디에 적용할지 달라짐
@router.post('/face_swapping')
async def face_swapping(face_swap: FaceSwap): 
    print(face_swap.model_image)
    print(face_swap.user_image)
    print(face_swap.gender)

    user_image_name = face_swap.user_image.split('/')[-1].split('.')[0]
    model_image_name = face_swap.model_image.split('/')[-1].split('.')[0]

    output_image_name_origin = user_image_name + '_' + model_image_name 
    output_image_name_all = user_image_name + '_' + model_image_name + '_all'
    output_image_name_top = user_image_name + '_' + model_image_name + '_top'
    

    if face_swap.gender == '남자':
        select_model_path = os.path.join(MODEL_MAN_DIR, model_image_name + '.jpg')
        select_model_all_path = os.path.join(MODEL_MAN_ALL_DIR, model_image_name + '.jpg')
        select_model_top_path = os.path.join(MODEL_MAN_TOP_DIR, model_image_name + '.jpg')
    else:
        select_model_path = os.path.join(MODEL_WOMAN_DIR, model_image_name + '.jpg')
        select_model_all_path = os.path.join(MODEL_WOMAN_ALL_DIR, model_image_name + '.jpg')
        select_model_top_path = os.path.join(MODEL_WOMAN_TOP_DIR, model_image_name + '.jpg')
    select_user_path = os.path.join(USER_DIR, user_image_name + '.jpg')
    output_path = os.path.join(OUTPUT_DIR, output_image_name_origin + '.jpg')
    output_all_path = os.path.join(OUTPUT_DIR, output_image_name_all + '.jpg')
    output_top_path = os.path.join(OUTPUT_DIR, output_image_name_top + '.jpg')

    # Face Swapping
    test_image(select_user_path, select_model_path, output_path) # origin
    test_image(select_user_path, select_model_all_path, output_all_path) # remove_all
    test_image(select_user_path, select_model_top_path, output_top_path) # remove_top

    # output_url = SERVER_OUTPUT_DIR + OUTPUT_VIDEO_NAME
    result = {'outputName' : output_image_name_origin + '.jpg'}
    return result

# 헤어 스타일 적용하기
# 모델 이미지, 사용자 이미지, 적용할 헤어 스타일에 따라서 적용
class TryOnData(BaseModel):
    model_image: str
    user_image: str
    hair_code: int

@router.post('/change_hair')
async def change_hair(try_on_data: TryOnData): 
    print(try_on_data.model_image)
    print(try_on_data.user_image)
    print(try_on_data.hair_code)

    user_image_name = try_on_data.user_image.split('/')[-1].split('.')[0]
    model_image_name = try_on_data.model_image.split('/')[-1].split('.')[0]
    output_image_name = user_image_name + '_' + model_image_name 

    output_path = os.path.join(OUTPUT_DIR, output_image_name + '.jpg')
    output_all_path = os.path.join(OUTPUT_DIR, output_image_name + '_all.jpg')
    output_top_path = os.path.join(OUTPUT_DIR, output_image_name + '_top.jpg')

    if try_on_data.hair_code == -1:
        # 사용자 머리 합성하기
        hair_man_path = f'C:/Users/omocomo/Documents/GitHub/Virtual-Clothing-Try-On/FastAPI/DATA/user/{user_image_name}.jpg'
        hair_mask_path = f'C:/Users/omocomo/Documents/GitHub/Virtual-Clothing-Try-On/FastAPI/DATA/hair/{user_image_name}.png'
        final_image = HairSwap(hair_man_path, output_all_path, hair_mask_path) # 사용자 머리의 배경
    elif try_on_data.hair_code == 0:
        final_image = output_image_name + '.jpg'
    else:
        # 머리 합성하기
        hair_man_path = f'C:/Users/omocomo/Documents/GitHub/Virtual-Clothing-Try-On/FastAPI/DATA/hair/hair_man_{str(try_on_data.hair_code).zfill(3)}.png'
        hair_mask_path = f'C:/Users/omocomo/Documents/GitHub/Virtual-Clothing-Try-On/FastAPI/DATA/hair/hair_mask_{str(try_on_data.hair_code).zfill(3)}.png'
        if try_on_data.hair_code in [1, 2, 6]: # remove_top
            final_image = HairSwap(hair_man_path, output_top_path, hair_mask_path)
        else: # remove_all
            final_image = HairSwap(hair_man_path, output_all_path, hair_mask_path)

    print(final_image)
        
    # output_url = SERVER_OUTPUT_DIR + OUTPUT_VIDEO_NAME
    result = {'outputName' : final_image}
    return result