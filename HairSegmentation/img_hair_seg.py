import os
import argparse
import torch

from models import MobileHairNet
from evaluate import evaluateOne
from dataset import ImgTransformer

import cv2

from utils import CheckpointManager

DIR_PATH = os.path.dirname(__file__)
USE_CUDA = torch.cuda.is_available()
device = torch.device("cuda" if USE_CUDA else "cpu")


def build_model(checkpoint):
    model = MobileHairNet()

    if checkpoint:
        model.load_state_dict(checkpoint["model"])

    # Use appropriate device
    model = model.to(device)

    return model


def run_img(img_path, model):
    model.eval()

    transformer = ImgTransformer(448, color_aug=False)
    img, img_size = transformer.load_img(img_path)
    mask_pred = evaluateOne(img, model, absolute=True)
    mask_pred = cv2.resize(mask_pred, dsize=img_size, interpolation=cv2.INTER_LINEAR)

    # save original hair mask image
    original_img = cv2.imread(img_path, cv2.IMREAD_COLOR)
    hair_masked_img = cv2.bitwise_and(original_img, original_img, mask=mask_pred)

    img_name = img_path.split('/')[-1].split('.')[0]

    cv2.imwrite(f"./outputs/{img_name}_hair_mask.png", mask_pred)
    cv2.imwrite(f"./outputs/{img_name}_original_img.png", original_img)
    cv2.imwrite(f"./outputs/{img_name}_masked_img.png", hair_masked_img)


def img_hair_seg(img_path):
    SAVE_PATH = os.path.join(DIR_PATH, "checkpoints", "default")
    print("Saving path:", SAVE_PATH)
    checkpoint_mng = CheckpointManager(SAVE_PATH)

    print("Load checkpoint:", "train_16")
    checkpoint = checkpoint_mng.load("train_16", device)

    model = build_model(checkpoint)

    run_img(img_path, model)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-im", "--image")
    args = parser.parse_args()

    img_hair_seg(args.image)


if __name__ == "__main__":
    main()