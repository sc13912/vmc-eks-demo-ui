import React from 'react'
import logo from '../../assets/eks_vmc.png';
import PostMessage from "../../components/PostMessage";
import ShowMessage from "../../components/ShowMessage";
import {fetchMessages, postMessage}  from '../../services/index';
import { Grid} from '@material-ui/core';


export const Home = () => {
    const [messages, setCurrentMessages] = React.useState({});
    let [messagesLoaded, setMessagesLoaded] = React.useState(false);
    let [name, setName] = React.useState('');
    let [message, setMessage] = React.useState('');

    const getAllMessages = async () => {
        const messages = await fetchMessages();
  
        setCurrentMessages(messages);
        setMessagesLoaded(true);
      };
      
    React.useEffect(function() {
          getAllMessages();
    }, []);
    
    function  clearState()  {
        setMessage('');
        setName('');

      }
    function handleFormPost() {
        //Create an object to match the API
        let newMsg = {
          message,
          name
        };        

        postMessage(newMsg).then(function(response) {
            clearState()

            if (response.data === 'OK') {
                clearState();
                getAllMessages(); 

            }
        })
        .catch(function(error) {
            console.error(error);
        });

    
    };
    
      //Dynamically Update States for the form
    function handleNameEdit(event) {
        const { value } = event.target;
        setName(() => (value));
    }

        //Dynamically Update States for the form
    function handleMessageEdit(event) {
        const { value } = event.target;
        setMessage(() => (value));
    }

    return (
        <div className="container">
            <div className="title">
                <img src={logo} alt={"EKS+VMC LOGO"} />
                <h2 style={{ color: 'blue' }}>Guest Book Message Board -ver 2.5</h2>
            </div>

            <Grid container className="master-container" spacing={3}>
                <Grid item xs={12}>
                    <PostMessage
                        name={name}
                        message={message}
                        handleFormPost={handleFormPost}
                        handleNameEdit={handleNameEdit}
                        handleMessageEdit={handleMessageEdit}
                        setName={setName}
                    />
                </Grid>
                <Grid item xs={12}>
                    <ShowMessage messages={messages} messagesLoaded={messagesLoaded} />
                </Grid>
            </Grid>
        </div>
    )
}
