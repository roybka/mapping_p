import socket
import torch
import numpy as np
import time
import cv2
from ultralytics import YOLO
# todo: improve dummy mode (currently fixed location)

dummy = False # if you can't run a vision model locally
plot_frames = 1

host = "127.0.0.1"
port = 12345
classes_of_interest = [0] # 0=person, 41=cup
SLEEP_TIME = 0.1

def create_server_socket(host="127.0.0.1", port=12345):
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((host, port))
    server_socket.listen()
    print(f"{host}:{port} - Waiting for client...")
    return server_socket


def get_results(results):
    if not dummy:
        out = 'Nothing'
        inds = np.where([elem in classes_of_interest for elem in results[0].boxes.cls.cpu().numpy()])[0]
        if len(inds) > 0:
            # print(ind)
            mask = [e in classes_of_interest for e in results[0].boxes.cls]
            res = results[0][mask].boxes
            if len(res):

                classes = res.cls.cpu().numpy()
                ids = res.id.cpu().numpy()
                confs = res.conf.cpu().numpy()
                locs = res.xywh.cpu().numpy()
                out = ''
                for i in range(len(ids)):
                    out += str([ids[i], classes[i], confs[i]] + list(locs[i]))+','
                    # output structure: [id,cls,conf,x,y,w,h],[.....],[.....]
                out = out[:-1]
        return out
    else:
        return str([3,34,0.9443,432,321,412,123])


def main():
    if not dummy:
        model = YOLO('yolov8m.pt') # load a computer vision detection model.
        if torch.cuda.is_available():
            model.cuda()
            print('using gpu')
    server_socket = create_server_socket(host, port)
    client_socket, addr = server_socket.accept()
    print("Got a connection from %s" % str(addr))
    if not dummy:
        vid = cv2.VideoCapture(0)
        ret, frame = vid.read()
    try:
        while True:
            ret, frame = vid.read()
            if ret:
                if not dummy:
                    results = model.track(frame, persist=True, stream=False)
                    # print(st - time.time())
                    # Visualize the results on the frame
                    if plot_frames:
                        annotated_frame = results[0].plot()
                        # Display the annotated frame
                        cv2.imshow("YOLOv8 Tracking", annotated_frame)
                    r = get_results(results)
                else:
                    r = get_results(None)
                data = r.encode('utf-8')
                client_socket.send(data)
                time.sleep(SLEEP_TIME)  # Delay

            if cv2.waitKey(1) & 0xFF == ord('q'):
                client_socket.close()
                break
    finally:
        client_socket.close()
        vid.release()
        cv2.destroyAllWindows()


if __name__ == '__main__':
    main()