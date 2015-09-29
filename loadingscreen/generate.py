from PIL import Image

W = 1024
H = 768

im = Image.open("loadingscreen.png")
w, h = im.size

if w != W or h != H:
	im = im.resize((W, H))

im.crop((0, 0, 512, 512)).save('output/TL.png')
im.crop((512, 0, 1024, 512)).save('output/TR.png')
im.crop((0,512,512,768)).save('output/BL.png')
im.crop((512,512,1024,768)).save('output/BR.png')