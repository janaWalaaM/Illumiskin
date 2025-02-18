from flask import Flask, request, jsonify
import numpy as np
import tensorflow.lite as tflite
from PIL import Image

app = Flask(__name__)

# تحميل النموذج
interpreter = tflite.Interpreter(model_path="backend/best_float32 (2).tflite")
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# قائمة التصنيفات (labels)
labels = ["Acne", "Benign Tumors", "Eczema", "Fungal Infections", 
          "Malignant Lesions", "Nail Fungus", "Psoriasis", "Viral Infections"]

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({"error": "No image file provided"}), 400

    file = request.files['image']
    image = Image.open(file).convert('RGB')
    image = image.resize((640, 640))
    input_data = np.expand_dims(np.array(image, dtype=np.float32) / 255.0, axis=0)

    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()

    output_data = interpreter.get_tensor(output_details[0]['index'])[0]
    
    # استخراج أعلى خمس نتائج
    top_5_indices = np.argsort(output_data)[::-1][:5]
    top_5_predictions = [{"label": labels[i], "confidence": float(output_data[i])} for i in top_5_indices]

    return jsonify({
        "predictions": top_5_predictions
    })

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5001)
