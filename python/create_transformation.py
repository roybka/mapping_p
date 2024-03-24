
import os
import cv2
import numpy as np
import pandas as pd
path='/home/ro/sketchbook/mapping_processing/resources'
df=pd.read_csv(os.path.join(path,'rectangle_corners.csv'),header=None)
df.columns=['x','y']
df=df.astype(float)
print(df)
# Define points of the original quadrilateral (e.g., the whole screen)
# Points are in order: top-left, top-right, bottom-right, bottom-left
pts_src = np.array([[0, 0], [df.x.iloc[4], 0], [df.x.iloc[4], df.x.iloc[5]], [0, df.x.iloc[5]]])

# Define points of the target quadrilateral (the specific rectangle on the screen)
# Replace these coordinates with your rectangle's coordinates
pts_dst = np.array([[df.x.iloc[0], df.y.iloc[0]], [df.x.iloc[1], df.y.iloc[1]], [df.x.iloc[2], df.y.iloc[2]], [df.x.iloc[3], df.y.iloc[3]]])

# Calculate the perspective transformation matrix
matrix = cv2.getPerspectiveTransform(pts_src.astype(np.float32), pts_dst.astype(np.float32))

# Optionally, print or export the matrix
print("Transformation matrix:")
print(matrix)
pd.DataFrame(matrix).to_csv(os.path.join(path,"transformation_matrix.csv"), header=False, index=False)


