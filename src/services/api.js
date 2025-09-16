import axios from 'axios';

const API_BASE_URL = window.REACT_APP_API_URL || process.env.REACT_APP_API_URL || 'REACT_APP_API_URL_PLACEHOLDER';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const uploadAudioFile = async (file) => {
  try {
    // Converte o arquivo para base64
    const reader = new FileReader();
    const base64Promise = new Promise((resolve, reject) => {
      reader.onload = () => {
        // Remove o prefixo data:audio/...;base64,
        const base64 = reader.result.split(',')[1];
        resolve(base64);
      };
      reader.onerror = reject;
    });
    
    reader.readAsDataURL(file);
    const audioData = await base64Promise;
    
    const response = await api.post('/upload', {
      audio_data: audioData
    });
    return response.data;
  } catch (error) {
    throw new Error(`Upload failed: ${error.response?.data?.error || error.message}`);
  }
};

export const checkTaskStatus = async (taskId) => {
  try {
    const response = await api.get(`/results/${taskId}`);
    return response.data;
  } catch (error) {
    throw new Error(`Status check failed: ${error.response?.data?.error || error.message}`);
  }
};

export default api;