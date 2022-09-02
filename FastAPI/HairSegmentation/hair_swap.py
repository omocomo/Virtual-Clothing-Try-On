import sys
import cv2
import math
import numpy as np
import mediapipe as mp
from img_hair_seg import img_hair_seg


mp_face_detection = mp.solutions.face_detection


# 입력: 이미지 경로
# 출력: (너비, 높이), 상대적인 얼굴 키포인트 좌표
def ReadImage(img_path):

    # 이미지 읽기
    image = cv2.imread(img_path)

    with mp_face_detection.FaceDetection(
            min_detection_confidence=0.5, model_selection=0) as face_detection:

        # BGR 이미지를 RGB로 변환하고 MediaPipe face detection 처리
        results = face_detection.process(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))

        # 이미지 너비, 높이에 대한 상대적인 얼굴 키포인트 좌표
        keypoints = results.detections[0].location_data.relative_keypoints

        return image, keypoints


# 입력: 이미지 너비, 이미지 높이, 상대적인 얼굴 키포인트 좌표
# 출력: 오른쪽 눈 좌표, 왼쪽 눈 좌표 (오른쪽 눈은 우리가 봤을 때 왼쪽에 있는 눈을 가리킴)
def GetEyesKeypoint(width, height, relative_keypoints, EYE_MODE = True):
    # 0: RIGHT_EYE
    # 1: LEFT_EYE
    # 2: NOSE_TIP
    # 3: MOUTH_CENTER
    # 4: RIGHT_EAR_TRAGION
    # 5: LEFT_EAR_TRAGION

    # EYE_MODE / EAR_MODE
    if (EYE_MODE):
        rx = relative_keypoints[0].x
        ry = relative_keypoints[0].y
        lx = relative_keypoints[1].x
        ly = relative_keypoints[1].y
    else:
        rx = relative_keypoints[4].x
        ry = relative_keypoints[4].y
        lx = relative_keypoints[5].x
        ly = relative_keypoints[5].y

    # 오른쪽, 왼쪽 절대 좌표 구하기
    right_x = int(rx * width)
    right_y = int(ry * height)
    left_x = int(lx * width)
    left_y = int(ly * height)

    right_pos = (right_x, right_y)
    left_pos = (left_x, left_y)

    return right_pos, left_pos


# 입력: 오른쪽 좌표, 왼쪽 좌표
# 출력: 기준 좌표 사이 거리
def GetDistance(right_pos, left_pos):
    a = right_pos[0] - left_pos[0]
    b = right_pos[1] - left_pos[1]
    dist = math.sqrt((a * a) + (b * b))

    return dist


# 입력: 이미지, 스케일
# 출력: 크기 조절한 이미지
def ResizeImage(image, scale):
    height, width, _ = image.shape
    new_height = int(height * scale)
    new_width = int(width * scale)
    dim = (new_width, new_height)
    resized_img = cv2.resize(image, dim)

    return resized_img


# 입력: RGB 이미지
# 출력: 투명도 채널을 추가한 RGB 이미지
def AddAlphaChannel(image):
    r_channel, g_channel, b_channel = cv2.split(image)
    alpha_channel = np.ones(r_channel.shape, dtype=r_channel.dtype) * 255
    image = cv2.merge((r_channel, g_channel, b_channel, alpha_channel))
    # cv2.imshow(image)

    return image


# 입력: 모델 사진 경로, 사용자 사진 경로, 사용자 머리카락 마스크 경로
def HairSwap(user_img_path, model_img_path, user_hair_mask_path):
    # 사용자 오른쪽, 왼쪽 기준 좌표 사이 거리 구하기
    user_img, user_img_keypoints = ReadImage(user_img_path)
    user_img_height, user_img_width, _ = user_img.shape
    user_right_pos, user_left_pos = GetEyesKeypoint(user_img_width, user_img_height, user_img_keypoints, True)
    user_distance = GetDistance(user_right_pos, user_left_pos)

    # 모델 오른쪽, 왼쪽 기준 좌표 사이 거리 구하기
    model_img, model_img_keypoints = ReadImage(model_img_path)
    model_img_height, model_img_width, _ = model_img.shape
    model_right_pos, model_left_pos = GetEyesKeypoint(model_img_width, model_img_height, model_img_keypoints, True)
    model_distance = GetDistance(model_right_pos, model_left_pos)

    # 사용자와 모델의 distance가 같아지도록 사용자 이미지, 머리카락 마스크 비율 조절
    scale = model_distance / user_distance
    user_hair_mask = cv2.imread(user_hair_mask_path)
    resized_user_img = ResizeImage(user_img, scale)
    resized_hair_mask = ResizeImage(user_hair_mask, scale)

    # 크기 조절한 머리카락 마스크 다듬기
    resized_hair_mask = cv2.medianBlur(resized_hair_mask, 15)

    # 크기 조절한 머리카락 마스크의 너비, 높이 구하기
    height, width, _ = resized_hair_mask.shape

    # 사용자 오른쪽 기준 좌표 계산
    user_x = int(user_right_pos[0] * scale)
    user_y = int(user_right_pos[1] * scale)

    # 모델 사진에서 for문 돌리기 시작할 좌표 계산
    start_x = model_right_pos[0] - user_x
    start_y = model_right_pos[1] - user_y

    # 투명도 채널 추가하기
    model_img = AddAlphaChannel(model_img)
    resized_user_img = AddAlphaChannel(resized_user_img)

    # for문 돌려서 모델 사진에 사용자 머리카락 붙이기
    for h in range (start_y, start_y + height):
        for w in range(start_x, start_x + width):
            if (resized_hair_mask[h - start_y, w - start_x] > (0, 0, 0)).all():
                if (resized_hair_mask[h - start_y, w - start_x] < (5, 5, 5)).all():
                    resized_user_img[h - start_y, w - start_x][3] = 230
                for i in range(0, 4):
                    model_img[h, w][i] = resized_user_img[h - start_y, w - start_x][i]

    # 사용자 머리카락 붙인 모델 사진 저장하기
    # 경로명 나중에 수정할 것: model + user
    model_name = model_img_path.split('/')[-1].split('.')[0]
    img_name = user_img_path.split('/')[-1].split('.')[0]
    # cv2.imwrite(f"C:/Users/omocomo/Documents/GitHub/Virtual-Clothing-Try-On/FastAPI/DATA/output/{img_name}_result.png", model_img)
    cv2.imwrite(f"./DATA/output/{img_name}_{model_name}_result.png", model_img)

    return f"{img_name}_{model_name}_result.png"
