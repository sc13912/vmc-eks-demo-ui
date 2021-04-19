import React from 'react'
import { TextField, TextareaAutosize, Button, Grid} from '@material-ui/core';
 

export default function PostMessage({name, message, handleFormPost, handleNameEdit, handleMessageEdit}) {
    
    function postFormUpdate(e) {
        e.preventDefault();
    
        handleFormPost();
    }



    return (
        <div className="postMessage">
            <form className="post_message" noValidate autoComplete="off" onSubmit={postFormUpdate}>
                <Grid container justify="flex-start"  alignItems="center" spacing={3}>
                    <Grid key="name-grid" item>
                        <TextField id="name" label="Username"  value={name} onChange={handleNameEdit}/>
                    </Grid>
                    <Grid key="message-grid" item>
                        <TextareaAutosize
                            rowsMin={5}
                            rowsMax={5}
                            aria-label="maximum height"
                            placeholder="Please leave a message"
                            value={message}
                            onChange={handleMessageEdit}
                            style={{ fontFamily: 'Arial', fontSize: 18, width: 300 }}
                        />
                    </Grid>
                    <Grid key="button-grid"  item>
                        <Button variant="contained" color="primary" type="submit">
                            Add Message
                        </Button>
                    </Grid>
                </Grid>            
            </form>
        </div>
    );
};
