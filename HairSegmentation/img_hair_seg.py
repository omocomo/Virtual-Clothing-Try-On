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


def run(args, model, checkpoint):
    img_path = args.image
    model.eval()

    transformer = ImgTransformer(args.imsize, color_aug=False)
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


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-cp", "--checkpoint")
    parser.add_argument("-im", "--image")
    parser.add_argument("--save_dir", type=str, default="checkpoints", help="folder for models")
    parser.add_argument("--model_name", type=str, default="default", help="model name")
    parser.add_argument("--imsize", type=int, default=448, help="training image size")
    args = parser.parse_args()

    print("args: ", args)

    # SAVE_PATH = os.path.join(DIR_PATH, args.save_dir, args.model_name)
    # print("Saving path:", SAVE_PATH)
    # checkpoint_mng = CheckpointManager(SAVE_PATH)

    checkpoint = None
    if args.checkpoint:
        print("Load checkpoint:", args.checkpoint)
        checkpoint = checkpoint_mng.load(args.checkpoint, device)

    model = build_model(checkpoint)

    run(args, model, checkpoint)


if __name__ == "__main__":
    main()
