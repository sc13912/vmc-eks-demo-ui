import axios from 'axios';

// const URL = 'http://localhost:4000/api/';
const URL =  window.location.protocol + /api/;

export async function fetchMessages() {
    const getApiUrl = URL + 'getAll';

    try {
      const allMessages = await axios.get(getApiUrl);
      return allMessages.data.map(({ id, name, message, created_on }) => ({ id, name, message, created_on }));

    } catch (error) {
      return error;
    }
};


export function postMessage(newMessage) {
  const postApiUrl = URL + 'add';
  return axios
    .post(postApiUrl, newMessage);
        
};
