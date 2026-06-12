
from py4godot.classes.TextureRect import TextureRect
from py4godot.classes.Image import Image
from py4godot.classes.ImageTexture import ImageTexture
from py4godot.classes.core import PackedByteArray

from py4godot.classes.Image import Format
from py4godot.classes import gdclass


#from py4godot.classes.core import Vector3


import cv2
import numpy as np
import threading
import time

@gdclass
class opencv_camera(TextureRect):
	
	def __init__(self) -> None:
		super().__init__()
		self.cap = None
		self.img = None
		self.tex = None
		
		self.running = False
		self.worker_thread = None
		self.lock = threading.Lock()
		
		self.latest_frame_bytes = None
		self.frame_ready = False
		self.width = 640
		self.height = 480

	def _ready(self) -> None:
		self.img = Image.create_empty(self.width, self.height, False, Format.FORMAT_RGB8)
		self.tex = ImageTexture.create_from_image(self.img)
		self.set_texture(self.tex)
		
		self.running = True
		self.worker_thread = threading.Thread(target=self._camera_worker, daemon=True)
		self.worker_thread.start()

	def _process(self, delta:float) -> None:
		if (not self.frame_ready):
			return
		
		local_bytes = None
		with (self.lock):
			if (self.latest_frame_bytes):
				local_bytes = self.latest_frame_bytes
				self.frame_ready = False
			
		if (local_bytes is None):
			return
		
		godot_byte_array = PackedByteArray()
		try:
			godot_byte_array.PackedByteArray.create_from_bytes(local_bytes)
		except Exception:
			godot_byte_array.resize(len(local_bytes))
			for i, byte in enumerate(local_bytes):
				godot_byte_array.set(i, byte)
		
		self.img.set_data(self.width, self.height, False, Format.FORMAT_RGB8, godot_byte_array)
		self.tex.update(self.img)
	
	def _camera_worker(self):
		self.cap = cv2.VideoCapture(0)
		
		if (not self.cap.isOpened()):
			print("Python Error: Unable to access the camera hardware")
			self.running = False
			return
		
		self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, self.width)
		self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, self.height)
		
		while (self.running):
			success, frame = self.cap.read()
		
			if (not success or frame is None):
				time.sleep(0.01)
				continue
				
			rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
			rgb_frame = cv2.flip(rgb_frame, 1)
			raw_bytes = rgb_frame.tobytes()
			
			with (self.lock):
				self.latest_frame_bytes = raw_bytes
				self.frame_ready = True
			
			time.sleep(0.016)
			
		if (self.cap and self.cap.isOpened()):
			self.cap.release()
	
	def _exit_tree(self):
		print("Stopping webcam thread...")
		self.running = False
		if (self.worker_thread):
			self.worker_thread.join(timeout=1.0)
		
		if (self.cap and self.cap.isOpened()):
			self.cap.release()
			print("Webcam feed shut down cleanly.")
