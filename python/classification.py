from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
import io
import tensorflow as tf
from tensorflow.keras.preprocessing import image

app = Flask(__name__)
CORS(app) 

interpreter = tf.lite.Interpreter(model_path="./model/model_unquant.tflite")
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

def prepare_image(img):
    img = img.resize((224, 224)) 
    img = image.img_to_array(img)  
    img = np.expand_dims(img, axis=0) 
    img = img / 255.0 
    print(f"Image shape: {img.shape}, Sample pixel values: {img[0][0][0]}")  
    return img

@app.route("/predict", methods=["POST"])
def predict():
    if "file" not in request.files:
        return jsonify({"error": "No file part"}), 400
    
    file = request.files["file"]

    if file.filename == "":
        return jsonify({"error": "No selected file"}), 400

    img = image.load_img(io.BytesIO(file.read()))
    img = prepare_image(img)

    interpreter.set_tensor(input_details[0]['index'], img)
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]['index'])

    print(f"Raw output data: {output_data}") 

    probabilities = output_data[0]
    labels = ['Pantalon', 'Short', 'T-shirt']

    highest_index = np.argmax(probabilities)
    highest_probability = float(probabilities[highest_index])
    highest_class = labels[highest_index]

    response = {
        "class": highest_class,
        "description": highest_class,
        "probability": highest_probability
    }
    print("reponse",response)
    return jsonify({"prediction": response})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
