'''
Author: Naiyuan liu
Github: https://github.com/NNNNAI
Date: 2021-11-23 17:03:58
LastEditors: Naiyuan liu
LastEditTime: 2021-11-24 19:19:52
Description: 
'''
import os 
import cv2
import torch
from util.reverse2original import reverse2wholeimage
from util.norm import SpecificNorm
from parsing_model.model import BiSeNet


def _totensor(array): # numpy to tensor
    tensor = torch.from_numpy(array)
    img = tensor.transpose(0, 1).transpose(0, 2).contiguous()
    return img.float().div(255)


def image_swap(video_path, id_vetor, swap_model, detect_model, save_path, crop_size=224, no_simswaplogo=True, use_mask=False):

    spNorm = SpecificNorm()
    if use_mask:
        n_classes = 19
        net = BiSeNet(n_classes=n_classes)
        net.cuda()
        save_pth = os.path.join('./SimSwap/parsing_model/checkpoint', '79999_iter.pth')
        net.load_state_dict(torch.load(save_pth))
        net.eval()
    else:
        net = None

    frame = cv2.imread(video_path)
    detect_results = detect_model.get(frame, crop_size)

    frame_align_crop = detect_results[0][0]
    frame_mat_list = detect_results[1]

    frame_align_crop_tenor = _totensor(cv2.cvtColor(frame_align_crop,cv2.COLOR_BGR2RGB))[None,...].cuda()
    swap_result = swap_model(None, frame_align_crop_tenor, id_vetor, None, True)[0]
    swap_result_list = [swap_result]
    frame_align_crop_tenor_list = [frame_align_crop_tenor]


    reverse2wholeimage(frame_align_crop_tenor_list, swap_result_list, frame_mat_list, crop_size, frame, None,\
        os.path.join(save_path), no_simswaplogo, pasring_model=net, use_mask=use_mask, norm=spNorm)
