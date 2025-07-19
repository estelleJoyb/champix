import torch
import torch.nn as nn
from torchvision import models, transforms
from PIL import Image
import os

CLASS_NAMES = ['conditionally_edible', 'deadly', 'edible', 'poisonous']
NUM_CLASSES = len(CLASS_NAMES)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
MODEL_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "mushroom_classifier.pth")

def load_model(model_path, num_classes):
    model = models.resnet50(weights=None)
    model.fc = nn.Linear(model.fc.in_features, num_classes)
    model.load_state_dict(torch.load(model_path, map_location=device))
    model.to(device)
    model.eval()
    return model

model = load_model(MODEL_PATH, NUM_CLASSES)
transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])