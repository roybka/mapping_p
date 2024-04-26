import torch
import numpy as np
import time
import cv2
from ultralytics import YOLO
# todo: improve dummy mode (currently fixed location)
dummy = False # if you can't run a vision model locally

if not dummy:
    model = YOLO('yolov8m.pt') # load a computer vision detection model.
classes_of_interest = [41]  # cup (0=person)
#  test the GPU
if not dummy:
    a = torch.Tensor(np.random.randn(640 * 8, 8 * 640))
    st = time.time()
    for i in range(100):
        b = a * a
    print('CPU:', time.time() - st)

    a = a.cuda()
    st = time.time()
    for i in range(100):
        b = a * a
    print('GPU:', time.time() - st)
    model.cuda()
    print(model.device)
    import socket

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    host = "127.0.0.1"
    port = 12345
    print(host)
    print('Waiting for client...')
    server_socket.bind((host, port))
    server_socket.listen()
    client_socket, addr = server_socket.accept()

    print("Got a connection from %s" % str(addr))

    vid = cv2.VideoCapture(0)
    ret, frame = vid.read()


def get_results(results):
    if not dummy:
        ind = np.where([elem in classes_of_interest for elem in results[0].boxes.cls.cpu().numpy()])[0]
        if len(ind) > 0:
            print(ind)
            print(results[0].boxes.cls)
            out = list(results[0].boxes.xywh[ind[0]].cpu().numpy())
            out = str(out)[1:-1]
            # out=out+list(results[0].boxes.cls[ind[0]].cpu().numpy())
        else:
            out = 'Nothing'
        return out
    else:
        return '100,100,100,100'

while (True):

    # Capture the video frame
    # by frame
    st = time.time()
    ret, frame = vid.read()
    if ret:
        if not dummy:
            results = model.track(frame, persist=True, stream=False)
            print(st - time.time())
            # Visualize the results on the frame
            annotated_frame = results[0].plot()

            # Display the annotated frame
            cv2.imshow("YOLOv8 Tracking", annotated_frame)
            out = get_results(results)
        else:
            out=get_results(None)
        data = out.encode('utf-8')
        client_socket.send(data)
        time.sleep(0.1)  # Delay

    if cv2.waitKey(1) & 0xFF == ord('q'):
        client_socket.close()
        break
